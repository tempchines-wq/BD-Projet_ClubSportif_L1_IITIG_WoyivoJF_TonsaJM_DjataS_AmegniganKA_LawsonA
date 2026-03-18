

USE LNTF_DB;
GO

-- Classement par competition
-- RANK() partitionne par competition pour avoir un classement independant par compet
CREATE VIEW VUE_CLASSEMENT AS
SELECT
    C.nom_competition,
    E.nom_equipe,
    P.points,
    P.victoires,
    P.nuls,
    P.defaites,
    P.buts_pour,
    P.buts_contre,
    (P.buts_pour - P.buts_contre) AS diff_buts,
    (P.victoires + P.nuls + P.defaites) AS matchs_joues,
    RANK() OVER (
        PARTITION BY P.id_competition
        ORDER BY P.points DESC,
                 (P.buts_pour - P.buts_contre) DESC,
                 P.buts_pour DESC
    ) AS classement
FROM PARTICIPATION P
INNER JOIN EQUIPE      E ON E.id_equipe      = P.id_equipe
INNER JOIN COMPETITION C ON C.id_competition = P.id_competition;
GO

-- Statistiques individuelles des joueurs sur l'ensemble de leurs matchs
-- LEFT JOIN pour inclure les joueurs qui n'ont encore joue aucun match
CREATE VIEW VUE_STATS_JOUEURS AS
SELECT
    J.id_joueur,
    J.nom_joueur,
    J.prenom_joueur,
    J.poste,
    E.nom_equipe,
    COUNT(MJ.id_match)       AS matchs_joues,
    SUM(MJ.buts)             AS total_buts,
    SUM(MJ.passes_decisives) AS total_passes,
    SUM(MJ.cartons_jaunes)   AS total_cartons_jaunes,
    SUM(MJ.cartons_rouges)   AS total_cartons_rouges,
    SUM(MJ.minutes_jouees)   AS total_minutes
FROM JOUEUR J
INNER JOIN EQUIPE       E  ON E.id_equipe  = J.id_equipe
LEFT  JOIN MATCH_JOUEUR MJ ON MJ.id_joueur = J.id_joueur
GROUP BY J.id_joueur, J.nom_joueur, J.prenom_joueur, J.poste, E.nom_equipe;
GO

-- Planning des matchs avec calcul automatique du vainqueur via CASE WHEN
CREATE VIEW VUE_PLANNING_MATCHS AS
SELECT
    M.id_match,
    M.date_match,
    M.heure_match,
    M.journee,
    ED.nom_equipe AS equipe_domicile,
    EE.nom_equipe AS equipe_exterieur,
    M.score_domicile,
    M.score_exterieur,
    M.statut_match,
    ST.nom_stade,
    C.nom_competition,
    CASE
        WHEN M.statut_match = 'termine' AND M.score_domicile  > M.score_exterieur THEN ED.nom_equipe
        WHEN M.statut_match = 'termine' AND M.score_exterieur > M.score_domicile  THEN EE.nom_equipe
        WHEN M.statut_match = 'termine' AND M.score_domicile  = M.score_exterieur THEN 'Match nul'
        ELSE 'Non joue'
    END AS vainqueur
FROM [MATCH] M
INNER JOIN EQUIPE      ED ON ED.id_equipe     = M.id_equipe_domicile
INNER JOIN EQUIPE      EE ON EE.id_equipe     = M.id_equipe_exterieur
INNER JOIN STADE       ST ON ST.id_stade      = M.id_stade
INNER JOIN COMPETITION C  ON C.id_competition = M.id_competition;
GO

-- Classement des buteurs : HAVING filtre les joueurs sans but
CREATE VIEW VUE_BUTEURS AS
SELECT
    J.nom_joueur,
    J.prenom_joueur,
    J.poste,
    E.nom_equipe,
    SUM(MJ.buts)       AS total_buts,
    COUNT(MJ.id_match) AS matchs_joues
FROM JOUEUR J
INNER JOIN EQUIPE       E  ON E.id_equipe  = J.id_equipe
INNER JOIN MATCH_JOUEUR MJ ON MJ.id_joueur = J.id_joueur
GROUP BY J.nom_joueur, J.prenom_joueur, J.poste, E.nom_equipe
HAVING SUM(MJ.buts) > 0;
GO

-- Verification
SELECT TABLE_NAME AS vues_creees
FROM INFORMATION_SCHEMA.VIEWS;
GO
