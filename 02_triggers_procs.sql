

USE LNTF_DB;
GO

-- ================================================================
-- TRIGGER 1 : TRG_MAJ_CLASSEMENT
-- Se declenche apres chaque UPDATE sur MATCH
-- Si le match passe a "termine", il met a jour automatiquement
-- les points, victoires, nuls, defaites et buts dans PARTICIPATION
-- ================================================================
CREATE TRIGGER TRG_MAJ_CLASSEMENT
ON [MATCH]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- On ne traite que les matchs qui viennent de passer a "termine"
    IF NOT EXISTS (
        SELECT 1 FROM inserted i
        INNER JOIN deleted d ON d.id_match = i.id_match
        WHERE i.statut_match = 'termine' AND d.statut_match <> 'termine'
    ) RETURN;

    DECLARE @id_match  VARCHAR(10), @id_dom  VARCHAR(10), @id_ext VARCHAR(10),
            @id_comp   VARCHAR(10), @sc_dom  INT,         @sc_ext INT;

    DECLARE cur CURSOR FOR
        SELECT i.id_match, i.id_equipe_domicile, i.id_equipe_exterieur,
               i.id_competition, i.score_domicile, i.score_exterieur
        FROM inserted i INNER JOIN deleted d ON d.id_match = i.id_match
        WHERE i.statut_match = 'termine' AND d.statut_match <> 'termine';

    OPEN cur;
    FETCH NEXT FROM cur INTO @id_match, @id_dom, @id_ext, @id_comp, @sc_dom, @sc_ext;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        IF @sc_dom > @sc_ext -- victoire domicile
        BEGIN
            UPDATE PARTICIPATION SET victoires=victoires+1, points=points+3,
                buts_pour=buts_pour+@sc_dom, buts_contre=buts_contre+@sc_ext
            WHERE id_equipe=@id_dom AND id_competition=@id_comp;
            UPDATE PARTICIPATION SET defaites=defaites+1,
                buts_pour=buts_pour+@sc_ext, buts_contre=buts_contre+@sc_dom
            WHERE id_equipe=@id_ext AND id_competition=@id_comp;
        END
        ELSE IF @sc_ext > @sc_dom -- victoire exterieur
        BEGIN
            UPDATE PARTICIPATION SET defaites=defaites+1,
                buts_pour=buts_pour+@sc_dom, buts_contre=buts_contre+@sc_ext
            WHERE id_equipe=@id_dom AND id_competition=@id_comp;
            UPDATE PARTICIPATION SET victoires=victoires+1, points=points+3,
                buts_pour=buts_pour+@sc_ext, buts_contre=buts_contre+@sc_dom
            WHERE id_equipe=@id_ext AND id_competition=@id_comp;
        END
        ELSE -- match nul : 1 point chacun
        BEGIN
            UPDATE PARTICIPATION SET nuls=nuls+1, points=points+1,
                buts_pour=buts_pour+@sc_dom, buts_contre=buts_contre+@sc_ext
            WHERE id_equipe=@id_dom AND id_competition=@id_comp;
            UPDATE PARTICIPATION SET nuls=nuls+1, points=points+1,
                buts_pour=buts_pour+@sc_ext, buts_contre=buts_contre+@sc_dom
            WHERE id_equipe=@id_ext AND id_competition=@id_comp;
        END

        FETCH NEXT FROM cur INTO @id_match, @id_dom, @id_ext, @id_comp, @sc_dom, @sc_ext;
    END

    CLOSE cur; DEALLOCATE cur;
END;
GO

-- ================================================================
-- TRIGGER 2 : TRG_CHECK_JOUEUR_STATUT
-- INSTEAD OF INSERT sur MATCH_JOUEUR
-- Bloque l'insertion si le joueur est blesse, suspendu ou retraite
-- On utilise INSTEAD OF pour intercepter avant l'ecriture en base
-- ================================================================
CREATE TRIGGER TRG_CHECK_JOUEUR_STATUT
ON MATCH_JOUEUR
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1 FROM inserted i
        INNER JOIN JOUEUR j ON j.id_joueur = i.id_joueur
        WHERE j.statut IN ('blesse','suspendu','retraite')
    )
    BEGIN
        RAISERROR('Impossible d''aligner un joueur blesse, suspendu ou retraite.', 16, 1);
        RETURN;
    END

    -- Si la verification passe, on insere normalement
    INSERT INTO MATCH_JOUEUR
        (id_match, id_joueur, titulaire, minutes_jouees,
         buts, passes_decisives, cartons_jaunes, cartons_rouges)
    SELECT id_match, id_joueur, titulaire, minutes_jouees,
           buts, passes_decisives, cartons_jaunes, cartons_rouges
    FROM inserted;
END;
GO

-- ================================================================
-- PROCEDURE 1 : SP_CREER_MATCH
-- Cree un match apres validation :
-- - les deux equipes doivent etre differentes
-- - les deux equipes doivent participer a la competition
-- ================================================================
CREATE PROCEDURE SP_CREER_MATCH
    @id_match       VARCHAR(10), @date_match    DATE,
    @heure_match    TIME,        @id_equipe_dom VARCHAR(10),
    @id_equipe_ext  VARCHAR(10), @id_stade      VARCHAR(10),
    @id_competition VARCHAR(10), @journee       INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @id_equipe_dom = @id_equipe_ext
    BEGIN RAISERROR('Une equipe ne peut pas jouer contre elle-meme.', 16, 1); RETURN; END

    IF NOT EXISTS (SELECT 1 FROM PARTICIPATION WHERE id_equipe=@id_equipe_dom AND id_competition=@id_competition)
    BEGIN RAISERROR('L equipe domicile ne participe pas a cette competition.', 16, 1); RETURN; END

    IF NOT EXISTS (SELECT 1 FROM PARTICIPATION WHERE id_equipe=@id_equipe_ext AND id_competition=@id_competition)
    BEGIN RAISERROR('L equipe exterieure ne participe pas a cette competition.', 16, 1); RETURN; END

    INSERT INTO [MATCH] (id_match, date_match, heure_match, id_equipe_domicile,
        id_equipe_exterieur, id_stade, id_competition, journee, statut_match)
    VALUES (@id_match, @date_match, @heure_match, @id_equipe_dom,
        @id_equipe_ext, @id_stade, @id_competition, @journee, 'programme');

    PRINT 'Match ' + @id_match + ' cree avec succes.';
END;
GO

-- ================================================================
-- PROCEDURE 2 : SP_SAISIR_RESULTAT
-- Enregistre le score d'un match et passe son statut a "termine"
-- Le trigger TRG_MAJ_CLASSEMENT se declenche automatiquement ensuite
-- ================================================================
CREATE PROCEDURE SP_SAISIR_RESULTAT
    @id_match  VARCHAR(10),
    @score_dom INT,
    @score_ext INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM [MATCH] WHERE id_match=@id_match)
    BEGIN RAISERROR('Match introuvable.', 16, 1); RETURN; END

    IF EXISTS (SELECT 1 FROM [MATCH] WHERE id_match=@id_match AND statut_match='termine')
    BEGIN RAISERROR('Ce match est deja termine.', 16, 1); RETURN; END

    IF @score_dom < 0 OR @score_ext < 0
    BEGIN RAISERROR('Les scores ne peuvent pas etre negatifs.', 16, 1); RETURN; END

    UPDATE [MATCH] SET
        score_domicile  = @score_dom,
        score_exterieur = @score_ext,
        statut_match    = 'termine'
    WHERE id_match = @id_match;

    PRINT 'Resultat enregistre : ' + CAST(@score_dom AS VARCHAR) + ' - ' + CAST(@score_ext AS VARCHAR);
END;
GO

-- ================================================================
-- PROCEDURE 3 : SP_CLASSEMENT
-- Retourne le classement d'une competition donnee
-- Appelle directement la vue VUE_CLASSEMENT
-- ================================================================
CREATE PROCEDURE SP_CLASSEMENT
    @id_competition VARCHAR(10)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM COMPETITION WHERE id_competition=@id_competition)
    BEGIN RAISERROR('Competition introuvable.', 16, 1); RETURN; END

    SELECT classement, nom_equipe, matchs_joues,
           victoires, nuls, defaites,
           buts_pour, buts_contre, diff_buts, points
    FROM VUE_CLASSEMENT
    WHERE nom_competition = (SELECT nom_competition FROM COMPETITION WHERE id_competition=@id_competition)
    ORDER BY classement;
END;
GO
