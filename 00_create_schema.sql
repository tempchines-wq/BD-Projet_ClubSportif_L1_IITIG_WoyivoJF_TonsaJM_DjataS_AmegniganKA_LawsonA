

-- -----------------------------------------------------
-- Creation de la base de donnees
-- -----------------------------------------------------
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'LNTF_DB')
BEGIN
    ALTER DATABASE LNTF_DB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE LNTF_DB;
END
GO

CREATE DATABASE LNTF_DB COLLATE French_CI_AS;
GO

USE LNTF_DB;
GO

-- -----------------------------------------------------
-- Tables sans dependances (pas de FK)
-- On les cree en premier pour eviter les erreurs de reference
-- -----------------------------------------------------

-- SAISON : une saison regroupe plusieurs competitions (ex: 2024-2025)
CREATE TABLE SAISON (
    id_saison   VARCHAR(10)  NOT NULL,
    annee_debut INT          NOT NULL,
    annee_fin   INT          NOT NULL,
    libelle     VARCHAR(50)  NOT NULL,
    CONSTRAINT PK_SAISON PRIMARY KEY (id_saison),
    CONSTRAINT CK_SAISON_ANNEES CHECK (annee_fin > annee_debut)
);
GO

-- STADE : lieu physique ou se deroulent les matchs
CREATE TABLE STADE (
    id_stade           VARCHAR(10)   NOT NULL,
    nom_stade          VARCHAR(100)  NOT NULL,
    capacite           INT           NOT NULL,
    ville_stade        VARCHAR(100)  NOT NULL,
    superficie         DECIMAL(10,2) NULL,
    annee_construction INT           NULL,
    CONSTRAINT PK_STADE PRIMARY KEY (id_stade),
    CONSTRAINT CK_STADE_CAPACITE CHECK (capacite > 0)
);
GO

-- ARBITRE : les arbitres sont independants des equipes
CREATE TABLE ARBITRE (
    id_arbitre     VARCHAR(10)  NOT NULL,
    nom_arbitre    VARCHAR(100) NOT NULL,
    prenom_arbitre VARCHAR(100) NOT NULL,
    nationalite    VARCHAR(50)  NOT NULL,
    grade          VARCHAR(50)  NOT NULL,
    CONSTRAINT PK_ARBITRE PRIMARY KEY (id_arbitre),
    CONSTRAINT CK_ARBITRE_GRADE CHECK (grade IN ('National','International','FIFA','Regional'))
);
GO

-- -----------------------------------------------------
-- Tables avec FK vers STADE
-- -----------------------------------------------------

-- EQUIPE : chaque equipe a un stade de residence (FK vers STADE)
CREATE TABLE EQUIPE (
    id_equipe       VARCHAR(10)  NOT NULL,
    nom_equipe      VARCHAR(100) NOT NULL,
    ville_equipe    VARCHAR(100) NOT NULL,
    date_creation   DATE         NOT NULL,
    couleur_maillot VARCHAR(50)  NULL,
    id_stade        VARCHAR(10)  NOT NULL,
    CONSTRAINT PK_EQUIPE       PRIMARY KEY (id_equipe),
    CONSTRAINT FK_EQUIPE_STADE FOREIGN KEY (id_stade) REFERENCES STADE(id_stade)
);
GO

-- -----------------------------------------------------
-- Tables avec FK vers EQUIPE
-- -----------------------------------------------------

-- ENTRAINEUR : un entraineur dirige exactement une equipe
CREATE TABLE ENTRAINEUR (
    id_entraineur     VARCHAR(10)  NOT NULL,
    nom_entraineur    VARCHAR(100) NOT NULL,
    prenom_entraineur VARCHAR(100) NOT NULL,
    nationalite       VARCHAR(50)  NOT NULL,
    date_embauche     DATE         NOT NULL,
    date_fin_contrat  DATE         NULL,
    id_equipe         VARCHAR(10)  NOT NULL,
    CONSTRAINT PK_ENTRAINEUR       PRIMARY KEY (id_entraineur),
    CONSTRAINT FK_ENTRAINEUR_EQUIPE FOREIGN KEY (id_equipe) REFERENCES EQUIPE(id_equipe)
);
GO

-- JOUEUR : appartient a une equipe, le numero de maillot est unique par equipe
CREATE TABLE JOUEUR (
    id_joueur      VARCHAR(10)  NOT NULL,
    nom_joueur     VARCHAR(100) NOT NULL,
    prenom_joueur  VARCHAR(100) NOT NULL,
    date_naissance DATE         NOT NULL,
    nationalite    VARCHAR(50)  NOT NULL,
    poste          VARCHAR(20)  NOT NULL,
    numero_maillot INT          NOT NULL,
    statut         VARCHAR(20)  NOT NULL DEFAULT 'actif',
    id_equipe      VARCHAR(10)  NOT NULL,
    CONSTRAINT PK_JOUEUR        PRIMARY KEY (id_joueur),
    CONSTRAINT FK_JOUEUR_EQUIPE FOREIGN KEY (id_equipe) REFERENCES EQUIPE(id_equipe),
    CONSTRAINT CK_JOUEUR_POSTE  CHECK (poste  IN ('Gardien','Defenseur','Milieu','Attaquant')),
    CONSTRAINT CK_JOUEUR_STATUT CHECK (statut IN ('actif','blesse','suspendu','retraite')),
    CONSTRAINT CK_JOUEUR_MAILLOT CHECK (numero_maillot BETWEEN 1 AND 99),
    -- deux joueurs d'une meme equipe ne peuvent pas avoir le meme numero
    CONSTRAINT UQ_MAILLOT_EQUIPE UNIQUE (id_equipe, numero_maillot)
);
GO

-- -----------------------------------------------------
-- COMPETITION : rattachee a une saison via FK
-- -----------------------------------------------------
CREATE TABLE COMPETITION (
    id_competition   VARCHAR(10)  NOT NULL,
    nom_competition  VARCHAR(100) NOT NULL,
    type_competition VARCHAR(20)  NOT NULL,
    pays             VARCHAR(50)  NOT NULL,
    date_debut       DATE         NOT NULL,
    date_fin         DATE         NULL,
    id_saison        VARCHAR(10)  NOT NULL,
    CONSTRAINT PK_COMPETITION        PRIMARY KEY (id_competition),
    CONSTRAINT FK_COMPETITION_SAISON FOREIGN KEY (id_saison) REFERENCES SAISON(id_saison),
    CONSTRAINT CK_COMPETITION_TYPE   CHECK (type_competition IN ('Championnat','Coupe','Tournoi','Amical'))
);
GO

-- -----------------------------------------------------
-- MATCH : implique 2 equipes, un stade et une competition
-- Le mot MATCH etant reserve en SQL Server, on utilise [MATCH]
-- -----------------------------------------------------
CREATE TABLE [MATCH] (
    id_match            VARCHAR(10) NOT NULL,
    date_match          DATE        NOT NULL,
    heure_match         TIME        NOT NULL,
    score_domicile      INT         NULL,
    score_exterieur     INT         NULL,
    statut_match        VARCHAR(20) NOT NULL DEFAULT 'programme',
    journee             INT         NULL,
    id_equipe_domicile  VARCHAR(10) NOT NULL,
    id_equipe_exterieur VARCHAR(10) NOT NULL,
    id_stade            VARCHAR(10) NOT NULL,
    id_competition      VARCHAR(10) NOT NULL,
    CONSTRAINT PK_MATCH        PRIMARY KEY (id_match),
    CONSTRAINT FK_MATCH_DOM    FOREIGN KEY (id_equipe_domicile)  REFERENCES EQUIPE(id_equipe),
    CONSTRAINT FK_MATCH_EXT    FOREIGN KEY (id_equipe_exterieur) REFERENCES EQUIPE(id_equipe),
    CONSTRAINT FK_MATCH_STADE  FOREIGN KEY (id_stade)            REFERENCES STADE(id_stade),
    CONSTRAINT FK_MATCH_COMP   FOREIGN KEY (id_competition)      REFERENCES COMPETITION(id_competition),
    CONSTRAINT CK_MATCH_STATUT CHECK (statut_match IN ('programme','en cours','termine','reporte','annule')),
    -- une equipe ne peut pas jouer contre elle-meme
    CONSTRAINT CK_MATCH_EQUIPES CHECK (id_equipe_domicile <> id_equipe_exterieur),
    CONSTRAINT CK_MATCH_SCORES  CHECK (score_domicile >= 0 AND score_exterieur >= 0)
);
GO

-- -----------------------------------------------------
-- Tables associatives : issues des associations N,N du MCD
-- Une association N,N ne peut pas exister directement en SQL,
-- elle se transforme obligatoirement en une table avec 2 FK
-- -----------------------------------------------------

-- PARTICIPATION : une equipe peut participer a plusieurs competitions
-- et une competition regroupe plusieurs equipes (N,N)
CREATE TABLE PARTICIPATION (
    id_participation INT         IDENTITY(1,1) NOT NULL,
    id_equipe        VARCHAR(10) NOT NULL,
    id_competition   VARCHAR(10) NOT NULL,
    points           INT         NOT NULL DEFAULT 0,
    victoires        INT         NOT NULL DEFAULT 0,
    nuls             INT         NOT NULL DEFAULT 0,
    defaites         INT         NOT NULL DEFAULT 0,
    buts_pour        INT         NOT NULL DEFAULT 0,
    buts_contre      INT         NOT NULL DEFAULT 0,
    CONSTRAINT PK_PARTICIPATION PRIMARY KEY (id_participation),
    CONSTRAINT FK_PART_EQUIPE   FOREIGN KEY (id_equipe)      REFERENCES EQUIPE(id_equipe),
    CONSTRAINT FK_PART_COMP     FOREIGN KEY (id_competition) REFERENCES COMPETITION(id_competition),
    -- une equipe ne peut etre inscrite qu'une seule fois par competition
    CONSTRAINT UQ_PARTICIPATION UNIQUE (id_equipe, id_competition)
);
GO

-- MATCH_JOUEUR : feuille de match — un joueur peut jouer dans plusieurs matchs
-- et un match implique plusieurs joueurs (N,N)
CREATE TABLE MATCH_JOUEUR (
    id_match_joueur  INT         IDENTITY(1,1) NOT NULL,
    id_match         VARCHAR(10) NOT NULL,
    id_joueur        VARCHAR(10) NOT NULL,
    titulaire        BIT         NOT NULL DEFAULT 1,
    minutes_jouees   INT         NOT NULL DEFAULT 0,
    buts             INT         NOT NULL DEFAULT 0,
    passes_decisives INT         NOT NULL DEFAULT 0,
    cartons_jaunes   INT         NOT NULL DEFAULT 0,
    cartons_rouges   INT         NOT NULL DEFAULT 0,
    CONSTRAINT PK_MATCH_JOUEUR PRIMARY KEY (id_match_joueur),
    CONSTRAINT FK_MJ_MATCH     FOREIGN KEY (id_match)  REFERENCES [MATCH](id_match),
    CONSTRAINT FK_MJ_JOUEUR    FOREIGN KEY (id_joueur) REFERENCES JOUEUR(id_joueur),
    CONSTRAINT UQ_MJ           UNIQUE (id_match, id_joueur),
    CONSTRAINT CK_MJ_MINUTES   CHECK (minutes_jouees BETWEEN 0 AND 120),
    CONSTRAINT CK_MJ_CJ        CHECK (cartons_jaunes BETWEEN 0 AND 2),
    CONSTRAINT CK_MJ_CR        CHECK (cartons_rouges BETWEEN 0 AND 1)
);
GO

-- MATCH_ARBITRE : un arbitre peut officier dans plusieurs matchs
-- et un match est arbitre par plusieurs arbitres (N,N)
CREATE TABLE MATCH_ARBITRE (
    id_match_arbitre INT         IDENTITY(1,1) NOT NULL,
    id_match         VARCHAR(10) NOT NULL,
    id_arbitre       VARCHAR(10) NOT NULL,
    role_match       VARCHAR(30) NOT NULL,
    CONSTRAINT PK_MATCH_ARBITRE PRIMARY KEY (id_match_arbitre),
    CONSTRAINT FK_MA_MATCH      FOREIGN KEY (id_match)   REFERENCES [MATCH](id_match),
    CONSTRAINT FK_MA_ARBITRE    FOREIGN KEY (id_arbitre) REFERENCES ARBITRE(id_arbitre),
    CONSTRAINT CK_MA_ROLE       CHECK (role_match IN ('Principal','Assistant 1','Assistant 2','VAR','Quatrieme arbitre'))
);
GO

-- -----------------------------------------------------
-- Index sur les colonnes les plus utilisees en recherche
-- Ameliore les performances des jointures et des WHERE
-- -----------------------------------------------------
CREATE INDEX IDX_JOUEUR_EQUIPE ON JOUEUR(id_equipe);
CREATE INDEX IDX_MATCH_DOM     ON [MATCH](id_equipe_domicile);
CREATE INDEX IDX_MATCH_EXT     ON [MATCH](id_equipe_exterieur);
CREATE INDEX IDX_MATCH_COMP    ON [MATCH](id_competition);
CREATE INDEX IDX_MJ_MATCH      ON MATCH_JOUEUR(id_match);
CREATE INDEX IDX_MJ_JOUEUR     ON MATCH_JOUEUR(id_joueur);
CREATE INDEX IDX_PART_COMP     ON PARTICIPATION(id_competition);
GO

-- Verification : afficher toutes les tables creees
SELECT TABLE_NAME AS tables_creees
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;
GO
