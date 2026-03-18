

USE LNTF_DB;
GO

-- ============================================================
-- A. REQUETES DE BASE
-- ============================================================

-- A.1 Liste de toutes les equipes avec leur stade de residence
SELECT E.id_equipe, E.nom_equipe, E.ville_equipe, E.date_creation,
       S.nom_stade AS stade_domicile
FROM EQUIPE E
INNER JOIN STADE S ON S.id_stade = E.id_stade
ORDER BY E.nom_equipe;
GO

-- A.2 Fiche d'un joueur par son identifiant
SELECT J.id_joueur, J.nom_joueur, J.prenom_joueur, J.date_naissance,
       J.poste, J.numero_maillot, J.statut, E.nom_equipe
FROM JOUEUR J
INNER JOIN EQUIPE E ON E.id_equipe = J.id_equipe
WHERE J.id_joueur = 'J003';
GO

-- A.3 Matchs non encore joues (statut = programme)
SELECT M.id_match, M.date_match, M.heure_match, M.journee,
       ED.nom_equipe AS domicile, EE.nom_equipe AS exterieur,
       C.nom_competition
FROM [MATCH] M
INNER JOIN EQUIPE      ED ON ED.id_equipe     = M.id_equipe_domicile
INNER JOIN EQUIPE      EE ON EE.id_equipe     = M.id_equipe_exterieur
INNER JOIN COMPETITION C  ON C.id_competition = M.id_competition
WHERE M.statut_match = 'programme'
ORDER BY M.date_match;
GO

-- ============================================================
-- B. JOINTURES
-- ============================================================

-- B.4 Effectif complet d'une equipe (jointure simple JOUEUR-EQUIPE)
SELECT J.nom_joueur, J.prenom_joueur, J.poste, J.numero_maillot, J.statut
FROM JOUEUR J
INNER JOIN EQUIPE E ON E.id_equipe = J.id_equipe
WHERE E.nom_equipe = 'Maranatha FC'
ORDER BY J.poste;
GO

-- B.5 Recap d'un match avec equipes, stade et competition (4 jointures)
SELECT M.id_match, M.date_match, M.journee,
       ED.nom_equipe AS domicile, M.score_domicile,
       M.score_exterieur, EE.nom_equipe AS exterieur,
       M.statut_match, ST.nom_stade, C.nom_competition
FROM [MATCH] M
INNER JOIN EQUIPE      ED ON ED.id_equipe      = M.id_equipe_domicile
INNER JOIN EQUIPE      EE ON EE.id_equipe      = M.id_equipe_exterieur
INNER JOIN STADE       ST ON ST.id_stade       = M.id_stade
INNER JOIN COMPETITION C  ON C.id_competition  = M.id_competition
ORDER BY M.date_match;
GO

-- B.6 Fiche complete d'un match avec les arbitres et leur role (5 jointures)
SELECT M.id_match, M.date_match, ED.nom_equipe AS domicile,
       EE.nom_equipe AS exterieur, M.score_domicile, M.score_exterieur,
       ST.nom_stade, C.nom_competition,
       AR.nom_arbitre + ' ' + AR.prenom_arbitre AS arbitre, MA.role_match
FROM [MATCH] M
INNER JOIN EQUIPE        ED ON ED.id_equipe     = M.id_equipe_domicile
INNER JOIN EQUIPE        EE ON EE.id_equipe     = M.id_equipe_exterieur
INNER JOIN STADE         ST ON ST.id_stade      = M.id_stade
INNER JOIN COMPETITION   C  ON C.id_competition = M.id_competition
INNER JOIN MATCH_ARBITRE MA ON MA.id_match      = M.id_match
INNER JOIN ARBITRE       AR ON AR.id_arbitre    = MA.id_arbitre
WHERE M.id_match = 'M001';
GO

-- ============================================================
-- C. AGREGATS (GROUP BY / HAVING)
-- ============================================================

-- C.7 Nombre de matchs joues par equipe (domicile + exterieur)
SELECT E.nom_equipe, COUNT(*) AS nb_matchs
FROM EQUIPE E
INNER JOIN [MATCH] M ON M.id_equipe_domicile = E.id_equipe
                     OR M.id_equipe_exterieur = E.id_equipe
WHERE M.statut_match = 'termine'
GROUP BY E.nom_equipe
ORDER BY nb_matchs DESC;
GO

-- C.8 Buts marques et encaisses par equipe sur l'ensemble des matchs
SELECT E.nom_equipe,
    SUM(CASE WHEN M.id_equipe_domicile  = E.id_equipe THEN M.score_domicile  ELSE 0 END)
  + SUM(CASE WHEN M.id_equipe_exterieur = E.id_equipe THEN M.score_exterieur ELSE 0 END) AS buts_marques,
    SUM(CASE WHEN M.id_equipe_domicile  = E.id_equipe THEN M.score_exterieur ELSE 0 END)
  + SUM(CASE WHEN M.id_equipe_exterieur = E.id_equipe THEN M.score_domicile  ELSE 0 END) AS buts_encaisses
FROM EQUIPE E
INNER JOIN [MATCH] M ON M.id_equipe_domicile = E.id_equipe
                     OR M.id_equipe_exterieur = E.id_equipe
WHERE M.statut_match = 'termine'
GROUP BY E.nom_equipe
ORDER BY buts_marques DESC;
GO

-- C.9 Equipes ayant marque plus de 3 buts au total (HAVING)
SELECT E.nom_equipe,
    SUM(CASE WHEN M.id_equipe_domicile  = E.id_equipe THEN M.score_domicile  ELSE 0 END)
  + SUM(CASE WHEN M.id_equipe_exterieur = E.id_equipe THEN M.score_exterieur ELSE 0 END) AS total_buts
FROM EQUIPE E
INNER JOIN [MATCH] M ON M.id_equipe_domicile = E.id_equipe
                     OR M.id_equipe_exterieur = E.id_equipe
WHERE M.statut_match = 'termine'
GROUP BY E.nom_equipe
HAVING (
    SUM(CASE WHEN M.id_equipe_domicile  = E.id_equipe THEN M.score_domicile  ELSE 0 END)
  + SUM(CASE WHEN M.id_equipe_exterieur = E.id_equipe THEN M.score_exterieur ELSE 0 END)
) > 3
ORDER BY total_buts DESC;
GO

-- ============================================================
-- D. SOUS-REQUETES
-- ============================================================

-- D.10 Meilleur buteur : sous-requete scalaire pour recuperer le max
SELECT J.nom_joueur, J.prenom_joueur, E.nom_equipe, SUM(MJ.buts) AS total_buts
FROM MATCH_JOUEUR MJ
INNER JOIN JOUEUR J ON J.id_joueur = MJ.id_joueur
INNER JOIN EQUIPE E ON E.id_equipe = J.id_equipe
GROUP BY J.nom_joueur, J.prenom_joueur, E.nom_equipe
HAVING SUM(MJ.buts) = (
    SELECT MAX(total) FROM (SELECT SUM(buts) AS total FROM MATCH_JOUEUR GROUP BY id_joueur) t
);
GO

-- D.11 Equipes ayant joue au moins un match a domicile (EXISTS)
SELECT E.nom_equipe, E.ville_equipe
FROM EQUIPE E
WHERE EXISTS (
    SELECT 1 FROM [MATCH] M
    WHERE M.id_equipe_domicile = E.id_equipe AND M.statut_match = 'termine'
)
ORDER BY E.nom_equipe;
GO

-- ============================================================
-- E. MISE A JOUR ET SUPPRESSION
-- ============================================================

-- E.12 Suspendre les joueurs ayant cumule 2 cartons jaunes ou plus
UPDATE JOUEUR SET statut = 'suspendu'
WHERE id_joueur IN (
    SELECT id_joueur FROM MATCH_JOUEUR
    GROUP BY id_joueur HAVING SUM(cartons_jaunes) >= 2
)
AND statut = 'actif';

-- Verification apres mise a jour
SELECT J.nom_joueur, J.prenom_joueur, J.statut, SUM(MJ.cartons_jaunes) AS total_cj
FROM JOUEUR J INNER JOIN MATCH_JOUEUR MJ ON MJ.id_joueur = J.id_joueur
GROUP BY J.nom_joueur, J.prenom_joueur, J.statut
HAVING SUM(MJ.cartons_jaunes) >= 2;
GO

-- E.13 Suppression : en SQL les FK imposent un ordre strict de suppression.
-- On ne peut pas supprimer une equipe directement si elle a des donnees liees.
-- Ordre obligatoire : MATCH_JOUEUR > MATCH_ARBITRE > MATCH > PARTICIPATION > JOUEUR > ENTRAINEUR > EQUIPE
-- Requete commentee volontairement pour ne pas alterer les donnees de test :
/*
DELETE FROM MATCH_JOUEUR  WHERE id_match IN (SELECT id_match FROM [MATCH] WHERE id_equipe_domicile='EQ99' OR id_equipe_exterieur='EQ99');
DELETE FROM MATCH_ARBITRE WHERE id_match IN (SELECT id_match FROM [MATCH] WHERE id_equipe_domicile='EQ99' OR id_equipe_exterieur='EQ99');
DELETE FROM [MATCH]       WHERE id_equipe_domicile='EQ99' OR id_equipe_exterieur='EQ99';
DELETE FROM PARTICIPATION WHERE id_equipe='EQ99';
DELETE FROM JOUEUR        WHERE id_equipe='EQ99';
DELETE FROM ENTRAINEUR    WHERE id_equipe='EQ99';
DELETE FROM EQUIPE        WHERE id_equipe='EQ99';
*/
GO

-- ============================================================
-- F. VUES
-- ============================================================

-- F.14 Classement du Championnat National D1 via VUE_CLASSEMENT
SELECT classement, nom_equipe, matchs_joues,
       victoires, nuls, defaites, buts_pour, buts_contre, diff_buts, points
FROM VUE_CLASSEMENT
WHERE nom_competition = 'Championnat National D1'
ORDER BY classement;
GO

-- F.15 Top 5 buteurs via VUE_STATS_JOUEURS
SELECT TOP 5 nom_joueur, prenom_joueur, nom_equipe, poste, total_buts, matchs_joues
FROM VUE_STATS_JOUEURS
WHERE total_buts > 0
ORDER BY total_buts DESC;
GO

-- ============================================================
-- P9. REQUETES SPECIFIQUES AU PROJET
-- ============================================================

-- P9.1 Classement via la procedure stockee SP_CLASSEMENT
EXEC SP_CLASSEMENT 'CP01';
GO

-- P9.2 Historique complet d'une equipe : matchs a domicile ET a l'exterieur
SELECT M.id_match, M.date_match, M.journee,
       ED.nom_equipe AS domicile, M.score_domicile,
       M.score_exterieur, EE.nom_equipe AS exterieur, M.statut_match
FROM [MATCH] M
INNER JOIN EQUIPE ED ON ED.id_equipe = M.id_equipe_domicile
INNER JOIN EQUIPE EE ON EE.id_equipe = M.id_equipe_exterieur
WHERE M.id_equipe_domicile = 'EQ01' OR M.id_equipe_exterieur = 'EQ01'
ORDER BY M.date_match;
GO

-- P9.3 Statistiques completes d'un joueur via VUE_STATS_JOUEURS
SELECT nom_joueur, prenom_joueur, nom_equipe, poste,
       matchs_joues, total_buts, total_passes,
       total_cartons_jaunes, total_cartons_rouges, total_minutes
FROM VUE_STATS_JOUEURS
WHERE id_joueur = 'J022';
GO

-- P9.4 Equipes sans aucune victoire dans le championnat
SELECT E.nom_equipe, P.points, P.victoires, P.nuls, P.defaites
FROM PARTICIPATION P
INNER JOIN EQUIPE      E ON E.id_equipe      = P.id_equipe
INNER JOIN COMPETITION C ON C.id_competition = P.id_competition
WHERE P.victoires = 0 AND C.nom_competition = 'Championnat National D1'
ORDER BY P.points DESC;
GO

-- P9.5 Joueurs n'ayant participe a aucun match (NOT EXISTS)
SELECT J.nom_joueur, J.prenom_joueur, J.poste, J.statut, E.nom_equipe
FROM JOUEUR J
INNER JOIN EQUIPE E ON E.id_equipe = J.id_equipe
WHERE NOT EXISTS (
    SELECT 1 FROM MATCH_JOUEUR MJ WHERE MJ.id_joueur = J.id_joueur
)
ORDER BY E.nom_equipe;
GO

-- P9.6 Taux de victoire a domicile par equipe
-- NULLIF evite la division par zero si une equipe n'a pas joue a domicile
SELECT E.nom_equipe,
       COUNT(*) AS matchs_domicile,
       SUM(CASE WHEN M.score_domicile > M.score_exterieur THEN 1 ELSE 0 END) AS victoires_dom,
       CAST(
           100.0 * SUM(CASE WHEN M.score_domicile > M.score_exterieur THEN 1 ELSE 0 END)
           / NULLIF(COUNT(*), 0)
       AS DECIMAL(5,1)) AS taux_pct
FROM EQUIPE E
INNER JOIN [MATCH] M ON M.id_equipe_domicile = E.id_equipe
WHERE M.statut_match = 'termine'
GROUP BY E.nom_equipe
ORDER BY taux_pct DESC;
GO
