

USE LNTF_DB;
GO

-- Saisons
INSERT INTO SAISON VALUES ('S2023',2023,2024,'Saison 2023-2024'),('S2024',2024,2025,'Saison 2024-2025');
GO

-- Stades
INSERT INTO STADE VALUES
('ST01','Stade de Kegue',         20000,'Lome',    11000.00,1965),
('ST02','Stade Municipal de Kara', 8000,'Kara',     8000.00,1980),
('ST03','Stade de Sokode',         5000,'Sokode',   5500.00,1975),
('ST04','Stade de Tsevie',         4000,'Tsevie',   4200.00,1990),
('ST05','Stade de Atakpame',       6000,'Atakpame', 6100.00,1985);
GO

-- Equipes
INSERT INTO EQUIPE VALUES
('EQ01','Maranatha FC',        'Lome',   '1990-03-15','Rouge et Blanc', 'ST01'),
('EQ02','Semassi FC',          'Sokode', '1985-06-20','Vert et Blanc',  'ST03'),
('EQ03','Dynamique Togolaise', 'Lome',   '1978-01-10','Bleu et Jaune',  'ST01'),
('EQ04','Sporting Club Kara',  'Kara',   '1995-08-05','Orange et Noir', 'ST02'),
('EQ05','AS Togo-Port',        'Lome',   '1970-11-30','Blanc et Bleu',  'ST01'),
('EQ06','Agaza FC',            'Tsevie', '2000-04-22','Jaune et Vert',  'ST04'),
('EQ07','Gomido FC',           'Kpalime','1998-09-12','Bordeaux et Or', 'ST03'),
('EQ08','ASCK Kara',           'Kara',   '1988-07-01','Bleu et Blanc',  'ST02');
GO

-- Entraineurs
INSERT INTO ENTRAINEUR VALUES
('EN01','Agbodjan', 'Koffi',  'Togolaise', '2022-07-01','2025-06-30','EQ01'),
('EN02','Tchakpele','Yaovi',  'Togolaise', '2021-01-15','2024-12-31','EQ02'),
('EN03','Mensah',   'Komlan', 'Togolaise', '2023-03-01','2026-02-28','EQ03'),
('EN04','Ouattara', 'Drissa', 'Burkinabe', '2022-08-10','2025-07-31','EQ04'),
('EN05','Doumbia',  'Seydou', 'Ivoirienne','2020-06-01','2024-05-31','EQ05'),
('EN06','Assogba',  'Messan', 'Togolaise', '2023-01-01','2025-12-31','EQ06'),
('EN07','Kpakpo',   'Edem',   'Togolaise', '2021-09-01','2024-08-31','EQ07'),
('EN08','Tchangani','Abdoul', 'Togolaise', '2022-05-15','2025-04-30','EQ08');
GO

-- Joueurs (5 par equipe = 40 joueurs)
INSERT INTO JOUEUR VALUES
('J001','Amegavi', 'Kossi',   '1998-05-12','Togolaise','Gardien',    1,'actif',    'EQ01'),
('J002','Kpodo',   'Selom',   '2000-03-22','Togolaise','Defenseur',  4,'actif',    'EQ01'),
('J003','Tossou',  'Foli',    '1997-08-14','Togolaise','Milieu',     10,'actif',   'EQ01'),
('J004','Agbeko',  'Komi',    '1999-11-30','Togolaise','Attaquant',   9,'blesse',  'EQ01'),
('J005','Dossou',  'Yao',     '2001-02-18','Togolaise','Defenseur',   5,'actif',   'EQ01'),
('J006','Tchakpe', 'Essosnam','1996-07-04','Togolaise','Gardien',     1,'actif',   'EQ02'),
('J007','Boukari', 'Latif',   '2002-01-15','Togolaise','Milieu',      8,'actif',   'EQ02'),
('J008','Djobo',   'Ibrahim', '1999-09-28','Togolaise','Attaquant',  11,'actif',   'EQ02'),
('J009','Alassane','Moustafa','2000-04-07','Togolaise','Defenseur',   3,'suspendu','EQ02'),
('J010','Kpadenou','Koffi',   '1998-12-20','Togolaise','Milieu',      6,'actif',   'EQ02'),
('J011','Mensah',  'Kwami',   '1997-03-11','Togolaise','Gardien',     1,'actif',   'EQ03'),
('J012','Agba',    'Dodzi',   '2001-06-25','Togolaise','Attaquant',   7,'actif',   'EQ03'),
('J013','Sassou',  'Elom',    '1999-10-03','Togolaise','Milieu',     10,'actif',   'EQ03'),
('J014','Kpegbe',  'Kojo',    '2000-08-17','Togolaise','Defenseur',   2,'actif',   'EQ03'),
('J015','Attou',   'Eyram',   '1998-01-29','Togolaise','Defenseur',   6,'blesse',  'EQ03'),
('J016','Nadjombe','Pali',    '1996-05-08','Togolaise','Gardien',     1,'actif',   'EQ04'),
('J017','Tchani',  'Abalo',   '2000-02-14','Togolaise','Milieu',      8,'actif',   'EQ04'),
('J018','Lamboni', 'Lamba',   '1999-07-31','Togolaise','Attaquant',   9,'actif',   'EQ04'),
('J019','Yerima',  'Adamou',  '2001-11-22','Togolaise','Defenseur',   4,'actif',   'EQ04'),
('J020','Djagba',  'Mipendo', '1997-04-16','Togolaise','Defenseur',   5,'actif',   'EQ04'),
('J021','Aziamble','Komla',   '1995-09-09','Togolaise','Gardien',     1,'actif',   'EQ05'),
('J022','Foli',    'Kossi',   '2000-12-01','Togolaise','Attaquant',  10,'actif',   'EQ05'),
('J023','Kekeh',   'Edem',    '1998-06-20','Togolaise','Milieu',      6,'actif',   'EQ05'),
('J024','Agbodjan','Selom',   '2002-03-08','Togolaise','Defenseur',   3,'actif',   'EQ05'),
('J025','Akakpo',  'Yawo',    '1997-10-14','Togolaise','Defenseur',   5,'suspendu','EQ05'),
('J026','Sossou',  'Kodjo',   '1999-08-22','Togolaise','Gardien',     1,'actif',   'EQ06'),
('J027','Awuitor', 'Mawuli',  '2001-05-18','Togolaise','Attaquant',   9,'actif',   'EQ06'),
('J028','Doglo',   'Komi',    '1998-02-07','Togolaise','Milieu',      7,'actif',   'EQ06'),
('J029','Yovo',    'Elom',    '2000-09-30','Togolaise','Defenseur',   4,'actif',   'EQ06'),
('J030','Gbati',   'Koffi',   '1996-11-11','Togolaise','Defenseur',   2,'actif',   'EQ06'),
('J031','Agbotse', 'Edem',    '1997-07-25','Togolaise','Gardien',     1,'actif',   'EQ07'),
('J032','Kokou',   'Dodzi',   '2001-04-12','Togolaise','Attaquant',  11,'actif',   'EQ07'),
('J033','Ayeva',   'Messan',  '1999-01-28','Togolaise','Milieu',      8,'actif',   'EQ07'),
('J034','Dotse',   'Kwasi',   '2000-06-15','Togolaise','Defenseur',   3,'blesse',  'EQ07'),
('J035','Apetsi',  'Yao',     '1998-10-04','Togolaise','Defenseur',   6,'actif',   'EQ07'),
('J036','Takpara', 'Kossi',   '1996-03-19','Togolaise','Gardien',     1,'actif',   'EQ08'),
('J037','Gnama',   'Lalle',   '2001-08-06','Togolaise','Attaquant',  10,'actif',   'EQ08'),
('J038','Boubakari','Aliou',  '1999-05-23','Togolaise','Milieu',      6,'actif',   'EQ08'),
('J039','Patcha',  'Tchapo',  '2000-12-17','Togolaise','Defenseur',   4,'actif',   'EQ08'),
('J040','Kpoti',   'Dama',    '1997-09-01','Togolaise','Defenseur',   5,'actif',   'EQ08');
GO

-- Arbitres
INSERT INTO ARBITRE VALUES
('AR01','Amegavi', 'Kwami',  'Togolaise','National'),
('AR02','Segbenou','Koffi',  'Togolaise','International'),
('AR03','Foli',    'Mawuli', 'Togolaise','National'),
('AR04','Agou',    'Kokou',  'Togolaise','FIFA'),
('AR05','Tettey',  'Edem',   'Togolaise','Regional');
GO

-- Competitions
INSERT INTO COMPETITION VALUES
('CP01','Championnat National D1','Championnat','Togo','2024-09-01','2025-05-31','S2024'),
('CP02','Coupe du Togo',          'Coupe',      'Togo','2024-10-01','2025-04-30','S2024'),
('CP03','Tournoi Independance',   'Tournoi',    'Togo','2024-04-15','2024-04-27','S2023'),
('CP04','Match Amical LNTF',      'Amical',     'Togo','2024-07-14','2024-07-14','S2023');
GO

-- Participations
INSERT INTO PARTICIPATION (id_equipe,id_competition) VALUES
('EQ01','CP01'),('EQ02','CP01'),('EQ03','CP01'),('EQ04','CP01'),
('EQ05','CP01'),('EQ06','CP01'),('EQ07','CP01'),('EQ08','CP01'),
('EQ01','CP02'),('EQ02','CP02'),('EQ03','CP02'),('EQ05','CP02'),('EQ06','CP02'),('EQ07','CP02'),
('EQ01','CP03'),('EQ03','CP03'),('EQ05','CP03'),('EQ07','CP03'),
('EQ02','CP04'),('EQ04','CP04');
GO

-- Matchs (8 termines + 2 programmes)
INSERT INTO [MATCH] VALUES
('M001','2024-09-08','15:00',2,1,'termine', 1,'EQ01','EQ02','ST01','CP01'),
('M002','2024-09-08','17:00',0,0,'termine', 1,'EQ03','EQ04','ST01','CP01'),
('M003','2024-09-15','15:00',3,2,'termine', 2,'EQ05','EQ06','ST01','CP01'),
('M004','2024-09-15','17:00',1,1,'termine', 2,'EQ07','EQ08','ST03','CP01'),
('M005','2024-09-22','15:00',2,0,'termine', 3,'EQ01','EQ03','ST01','CP01'),
('M006','2024-09-22','17:00',1,3,'termine', 3,'EQ02','EQ04','ST03','CP01'),
('M007','2024-09-29','15:00',0,2,'termine', 4,'EQ05','EQ07','ST01','CP01'),
('M008','2024-09-29','17:00',2,2,'termine', 4,'EQ06','EQ08','ST04','CP01'),
('M009','2024-10-06','15:00',NULL,NULL,'programme',5,'EQ01','EQ04','ST01','CP01'),
('M010','2024-10-06','17:00',NULL,NULL,'programme',5,'EQ03','EQ05','ST01','CP01');
GO

-- Mise a jour manuelle du classement (les matchs ont ete inseres directement
-- avec statut=termine donc le trigger ne s'est pas declenche)
UPDATE PARTICIPATION SET victoires=victoires+1,points=points+3,buts_pour=buts_pour+2,buts_contre=buts_contre+1 WHERE id_equipe='EQ01' AND id_competition='CP01';
UPDATE PARTICIPATION SET defaites=defaites+1,buts_pour=buts_pour+1,buts_contre=buts_contre+2                   WHERE id_equipe='EQ02' AND id_competition='CP01';
UPDATE PARTICIPATION SET nuls=nuls+1,points=points+1                                                           WHERE id_equipe='EQ03' AND id_competition='CP01';
UPDATE PARTICIPATION SET nuls=nuls+1,points=points+1                                                           WHERE id_equipe='EQ04' AND id_competition='CP01';
UPDATE PARTICIPATION SET victoires=victoires+1,points=points+3,buts_pour=buts_pour+3,buts_contre=buts_contre+2 WHERE id_equipe='EQ05' AND id_competition='CP01';
UPDATE PARTICIPATION SET defaites=defaites+1,buts_pour=buts_pour+2,buts_contre=buts_contre+3                   WHERE id_equipe='EQ06' AND id_competition='CP01';
UPDATE PARTICIPATION SET nuls=nuls+1,points=points+1,buts_pour=buts_pour+1,buts_contre=buts_contre+1           WHERE id_equipe='EQ07' AND id_competition='CP01';
UPDATE PARTICIPATION SET nuls=nuls+1,points=points+1,buts_pour=buts_pour+1,buts_contre=buts_contre+1           WHERE id_equipe='EQ08' AND id_competition='CP01';
UPDATE PARTICIPATION SET victoires=victoires+1,points=points+3,buts_pour=buts_pour+2,buts_contre=buts_contre+0 WHERE id_equipe='EQ01' AND id_competition='CP01';
UPDATE PARTICIPATION SET defaites=defaites+1,buts_pour=buts_pour+0,buts_contre=buts_contre+2                   WHERE id_equipe='EQ03' AND id_competition='CP01';
UPDATE PARTICIPATION SET defaites=defaites+1,buts_pour=buts_pour+1,buts_contre=buts_contre+3                   WHERE id_equipe='EQ02' AND id_competition='CP01';
UPDATE PARTICIPATION SET victoires=victoires+1,points=points+3,buts_pour=buts_pour+3,buts_contre=buts_contre+1 WHERE id_equipe='EQ04' AND id_competition='CP01';
UPDATE PARTICIPATION SET defaites=defaites+1,buts_pour=buts_pour+0,buts_contre=buts_contre+2                   WHERE id_equipe='EQ05' AND id_competition='CP01';
UPDATE PARTICIPATION SET victoires=victoires+1,points=points+3,buts_pour=buts_pour+2,buts_contre=buts_contre+0 WHERE id_equipe='EQ07' AND id_competition='CP01';
UPDATE PARTICIPATION SET nuls=nuls+1,points=points+1,buts_pour=buts_pour+2,buts_contre=buts_contre+2           WHERE id_equipe='EQ06' AND id_competition='CP01';
UPDATE PARTICIPATION SET nuls=nuls+1,points=points+1,buts_pour=buts_pour+2,buts_contre=buts_contre+2           WHERE id_equipe='EQ08' AND id_competition='CP01';
GO

-- Feuilles de match
INSERT INTO MATCH_JOUEUR (id_match,id_joueur,titulaire,minutes_jouees,buts,passes_decisives,cartons_jaunes,cartons_rouges) VALUES
('M001','J001',1,90,0,0,0,0),('M001','J002',1,90,0,0,1,0),('M001','J003',1,90,1,1,0,0),
('M001','J005',1,90,1,0,0,0),('M001','J006',1,90,0,0,0,0),('M001','J007',1,75,0,0,1,0),
('M001','J008',1,90,1,0,0,0),
('M002','J011',1,90,0,0,0,0),('M002','J013',1,90,0,0,0,0),('M002','J014',1,90,0,1,0,0),
('M002','J016',1,90,0,0,0,0),('M002','J017',1,90,0,0,1,0),
('M003','J021',1,90,0,0,0,0),('M003','J022',1,90,2,0,0,0),('M003','J023',1,90,1,1,0,0),
('M003','J026',1,90,0,0,0,0),('M003','J027',1,90,2,0,1,0),
('M004','J031',1,90,0,0,0,0),('M004','J032',1,90,1,0,0,0),('M004','J033',1,90,0,1,1,0),
('M004','J036',1,90,0,0,0,0),('M004','J037',1,90,1,0,0,0),
('M005','J001',1,90,0,0,0,0),('M005','J003',1,90,1,0,0,0),('M005','J005',1,90,1,1,0,0),
('M005','J011',1,90,0,0,0,0),('M005','J013',1,90,0,0,1,0),
('M006','J006',1,90,0,0,0,0),('M006','J007',1,90,1,0,0,0),('M006','J016',1,90,0,0,0,0),
('M006','J018',1,90,2,1,0,0),
('M007','J021',1,90,0,0,0,0),('M007','J022',1,90,0,1,0,0),('M007','J031',1,90,0,0,0,0),
('M007','J032',1,90,2,0,0,0),
('M008','J026',1,90,0,0,0,0),('M008','J027',1,90,1,0,0,0),('M008','J028',1,90,1,1,0,0),
('M008','J036',1,90,0,0,0,0),('M008','J038',1,90,1,0,1,0),('M008','J039',1,90,1,0,0,0);
GO

-- Arbitrages
INSERT INTO MATCH_ARBITRE (id_match,id_arbitre,role_match) VALUES
('M001','AR04','Principal'),('M001','AR01','Assistant 1'),('M001','AR02','Assistant 2'),
('M002','AR02','Principal'),('M002','AR03','Assistant 1'),('M002','AR05','Assistant 2'),
('M003','AR04','Principal'),('M003','AR01','Assistant 1'),('M003','AR03','Assistant 2'),
('M004','AR02','Principal'),('M004','AR05','Assistant 1'),
('M005','AR04','Principal'),('M005','AR01','Assistant 1'),('M005','AR02','Assistant 2'),
('M006','AR03','Principal'),('M006','AR05','Assistant 1'),
('M007','AR04','Principal'),('M007','AR01','Assistant 1'),
('M008','AR02','Principal'),('M008','AR03','Assistant 1');
GO

-- Verification du nombre de lignes par table
SELECT 'EQUIPE'        AS table_name, COUNT(*) AS nb_lignes FROM EQUIPE        UNION ALL
SELECT 'JOUEUR',       COUNT(*) FROM JOUEUR       UNION ALL
SELECT 'ENTRAINEUR',   COUNT(*) FROM ENTRAINEUR   UNION ALL
SELECT 'STADE',        COUNT(*) FROM STADE         UNION ALL
SELECT 'COMPETITION',  COUNT(*) FROM COMPETITION  UNION ALL
SELECT 'MATCH',        COUNT(*) FROM [MATCH]       UNION ALL
SELECT 'PARTICIPATION',COUNT(*) FROM PARTICIPATION UNION ALL
SELECT 'MATCH_JOUEUR', COUNT(*) FROM MATCH_JOUEUR  UNION ALL
SELECT 'MATCH_ARBITRE',COUNT(*) FROM MATCH_ARBITRE;
GO
