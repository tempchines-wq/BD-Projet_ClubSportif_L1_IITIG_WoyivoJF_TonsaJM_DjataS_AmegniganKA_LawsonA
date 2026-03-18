# Projet 9 — Gestion d'une Ligue de Football (LNTF)

## Membres

| Nom & Prénom | Filière | N° Étudiant | GitHub |
|---|---|---|---|
| WOYIVO Kouami Jean-Fabrice | SI  | — | — |
| TONSA Jean-Marc            | SRI | — | — |
| DJATA Sévérin              | SRI | — | — |
| AMEGNIGAN Kossi Arman      | SRI | — | — |

---

## Résumé

Ce projet modélise le système d'information d'une ligue nationale de football fictive (Ligue Nationale Togo Football — LNTF). Il couvre la gestion des équipes, joueurs, entraîneurs, stades, compétitions, matchs et arbitrages. La base de données permet de suivre les résultats, mettre à jour automatiquement le classement via des triggers, et interroger les statistiques individuelles et collectives via des vues et procédures stockées.

---

## Technologies

- **SGBD** : Microsoft SQL Server 2022
- **Outils** : SQL Server Management Studio (SSMS), draw.io
- **Modélisation** : Méthode Merise (MCD → MLD → MPD)

---

## Contenu du dépôt

```
BD-Projet_ClubSportif_L1_IITIG_WoyivoJF_TonsaJM_DjataS_AmegniganKA/
│
├── README.md                        — Description du projet
├── REPORT.pdf                       — rapport final
├── LICENSE                          — licence MIT
│
├── /sql/
│   ├── 00_create_schema.sql         — DDL : création base + 11 tables + index
│   ├── 01_create_views.sql          — 4 vues métier
│   ├── 02_triggers_procs.sql        — 2 triggers + 3 procédures stockées
│   ├── 10_insert_sample_data.sql    — jeu de données de test (40+ lignes)
│   └── 20_queries_required.sql      — 20 requêtes obligatoires commentées
│
├── /data/
    └── equipes.csv   — export CSV des données de test
│   └── joueurs.csv   — export CSV des données de test
│
├── /docs/
│   ├── /diagrams/
│   │  
│   │   ├── MCD.png                  — MCD exporté en image
│   │   ├── MLD.png                  — Modèle Logique des Données
│   │   └── MPD.png                  — Modèle Physique des Données
│   └── /screenshots/
│       └── *.png                    — captures d'écran des résultats SSMS
│
└── /deploy/                         — optionnel
    └── docker-compose.yml
```

---

## Installation / Exécution

### Prérequis
- SQL Server 2022
- SQL Server Management Studio (SSMS)

### Étapes

**1. Créer la base et les tables :**
```
Ouvrir 00_create_schema.sql dans SSMS → F5
```

**2. Créer les vues :**
```
Ouvrir 01_create_views.sql dans SSMS → F5
```

**3. Créer les triggers et procédures :**
```
Ouvrir 02_triggers_procs.sql dans SSMS → F5
```

**4. Charger les données :**
```
Ouvrir 10_insert_sample_data.sql dans SSMS → F5
```

**5. Exécuter les requêtes obligatoires :**
```
Ouvrir 20_queries_required.sql dans SSMS → F5
```

> **Important** : exécuter les fichiers dans cet ordre exact. Vérifier que la base `LNTF_DB` est sélectionnée avant chaque fichier.

### Avec Docker (optionnel)
```bash
docker-compose up --build
```
Puis se connecter à SQL Server sur le port 1433 avec les identifiants définis dans docker-compose.yml.

---

## Requêtes importantes (socle)

Toutes les requêtes se trouvent dans `sql/20_queries_required.sql`.

| Code | Description | Technique |
|---|---|---|
| A.1 | Liste des équipes avec stade | SELECT + JOIN |
| A.2 | Fiche d'un joueur | SELECT + WHERE |
| A.3 | Matchs programmés | SELECT + WHERE |
| B.4 | Effectif d'une équipe | JOIN |
| B.5 | Détail d'un match (4 tables) | Multi-JOIN |
| B.6 | Match + arbitres (5 tables) | Multi-JOIN |
| C.7 | Matchs joués par équipe | GROUP BY + COUNT |
| C.8 | Buts marqués/encaissés | GROUP BY + SUM + CASE |
| C.9 | Équipes offensives | GROUP BY + HAVING |
| D.10 | Meilleur buteur | Sous-requête scalaire |
| D.11 | Équipes ayant joué à domicile | EXISTS |
| E.12 | Suspendre joueurs (2 cartons) | UPDATE + sous-requête |
| E.13 | Suppression avec contraintes FK | DELETE (commenté) |
| F.14 | Classement via vue | VUE_CLASSEMENT |
| F.15 | Top 5 buteurs | VUE_STATS_JOUEURS |
| P9.1 | Classement via procédure | EXEC SP_CLASSEMENT |
| P9.2 | Historique matchs d'une équipe | OR dans WHERE |
| P9.3 | Stats d'un joueur | VUE_STATS_JOUEURS |
| P9.4 | Équipes sans victoire | WHERE = 0 |
| P9.5 | Joueurs sans aucun match | NOT EXISTS |
| P9.6 | Taux victoire à domicile | CAST + NULLIF |

---

## Notes / Particularités

- Le mot `MATCH` étant réservé en SQL Server, la table est nommée `[MATCH]` avec crochets.
- Les tables `PARTICIPATION`, `MATCH_JOUEUR` et `MATCH_ARBITRE` sont des tables associatives issues des associations N:N du MCD — elles sont créées avec `CREATE TABLE` comme toutes les autres.
- Le trigger `TRG_MAJ_CLASSEMENT` met à jour automatiquement les points et statistiques dans `PARTICIPATION` dès qu'un match passe au statut `terminé`.
- Le trigger `TRG_CHECK_JOUEUR_STATUT` empêche l'alignement d'un joueur blessé, suspendu ou retraité dans une feuille de match.
- Les scores sont contraints à des valeurs positives (`CHECK score >= 0`).
- Le numéro de maillot est unique par équipe (`UNIQUE(id_equipe, numero_maillot)`).

---

## Licence

MIT — voir fichier `LICENSE`.
