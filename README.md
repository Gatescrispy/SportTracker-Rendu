# SportTracker Basic - Rendu d'Évaluation PostgreSQL

Ce dépôt contient le rendu de l'évaluation finale du cours d'administration PostgreSQL. Le projet SportTracker Basic est une application permettant de suivre les équipes sportives universitaires, les joueurs, les matchs et les statistiques.

## Guide pour l'évaluateur

### Structure du dépôt

```
SportTracker-Rendu/
├── SportTrackerBasic/          # Code source de l'application
├── fichiers_Annexes/
│   ├── data/                   # Fichiers CSV de données
│   └── scripts/                # Scripts SQL et shell
├── backups/                    # Dossier pour les sauvegardes
├── rapport_administration.txt  # Rapport détaillé de l'administration
├── configuration.txt           # Documentation de la configuration
└── .env                        # Variables d'environnement (exemple)
```

### Installation et test

#### Méthode 1: Installation automatique (recommandée)

1. Cloner ce dépôt :
   ```bash
   git clone https://github.com/Gatescrispy/SportTracker-Rendu.git
   cd SportTracker-Rendu
   ```

2. Exécuter le script d'installation complet :
   ```bash
   chmod +x fichiers_Annexes/scripts/run_all.sh
   ./fichiers_Annexes/scripts/run_all.sh
   ```

Ce script effectue automatiquement:
- Création de la base de données `sporttracker`
- Création des tables
- Importation des données (équipes, joueurs, sports, matchs, statistiques)
- Création des utilisateurs avec les permissions appropriées
- Optimisation avec les index
- Configuration de la sécurité
- Maintenance initiale (VACUUM, ANALYZE)
- Création des vues d'analyse

#### Méthode 2: Installation manuelle

1. Créer la base de données :
   ```bash
   createdb -U postgres sporttracker
   ```

2. Exécuter les scripts SQL dans l'ordre suivant :
   ```bash
   psql -U postgres -d sporttracker -f fichiers_Annexes/scripts/create_tables.sql
   psql -U postgres -d sporttracker -f fichiers_Annexes/scripts/manual_import.sql
   psql -U postgres -d sporttracker -f fichiers_Annexes/scripts/insert_data.sql
   psql -U postgres -d sporttracker -f fichiers_Annexes/scripts/create_indexes.sql
   psql -U postgres -d sporttracker -f fichiers_Annexes/scripts/create_users.sql
   psql -U postgres -d sporttracker -f fichiers_Annexes/scripts/security_config.sql
   psql -U postgres -d sporttracker -f fichiers_Annexes/scripts/maintenance.sql
   psql -U postgres -d sporttracker -f fichiers_Annexes/scripts/create_views.sql
   ```

### Accès à la base de données

#### Informations de connexion

- **Host**: localhost
- **Port**: 5432
- **Database**: sporttracker

#### Utilisateurs créés

1. **Utilisateur application**
   - **Nom**: sporttracker_app
   - **Mot de passe**: app_password_secure123
   - **Droits**: SELECT, INSERT, UPDATE sur les tables

2. **Utilisateur administrateur**
   - **Nom**: sporttracker_admin
   - **Mot de passe**: admin_password_secure456
   - **Droits**: Tous les privilèges (ALL PRIVILEGES)

#### Connexion via Terminal

```bash
# Connexion en tant qu'utilisateur application
psql -U sporttracker_app -d sporttracker

# Connexion en tant qu'administrateur
psql -U sporttracker_admin -d sporttracker
```

#### Connexion via pgAdmin

1. Ouvrir pgAdmin
2. Ajouter un nouveau serveur
   - Nom: SportTracker
   - Host: localhost
   - Port: 5432
   - Database: sporttracker
   - Username: sporttracker_admin ou sporttracker_app
   - Password: (mot de passe correspondant)

### Vérification des fonctionnalités

1. **Vérifier les tables et leurs contenus**:
   ```sql
   SELECT COUNT(*) FROM equipes;    -- Doit afficher 10
   SELECT COUNT(*) FROM joueurs;    -- Doit afficher 50
   SELECT COUNT(*) FROM sports;     -- Doit afficher 5
   SELECT COUNT(*) FROM matchs;     -- Doit afficher 15
   SELECT COUNT(*) FROM statistiques_joueurs; -- Doit afficher 28
   ```

2. **Vérifier les vues créées**:
   ```sql
   \dv
   ```

3. **Tester les requêtes d'analyse**:
   ```sql
   -- Top 5 des équipes par victoires
   SELECT * FROM team_stats ORDER BY victoires DESC LIMIT 5;
   
   -- Meilleurs joueurs par points marqués
   SELECT * FROM top_players ORDER BY total_points DESC LIMIT 5;
   
   -- Détails des matchs
   SELECT * FROM match_details ORDER BY date DESC LIMIT 5;
   ```

4. **Tester la sauvegarde/restauration**:
   ```bash
   # Sauvegarde
   ./fichiers_Annexes/scripts/backup_restore.sh backup
   
   # Voir les sauvegardes disponibles
   ./fichiers_Annexes/scripts/backup_restore.sh list
   ```

### Points clés de l'implémentation

1. **Structure de la base**: 5 tables relationnelles avec contraintes d'intégrité
2. **Optimisation**: 13 index stratégiques sur colonnes fréquemment utilisées
3. **Sécurité**: Utilisateurs séparés, permissions limitées, audit d'opérations
4. **Vues**: 10 vues d'analyse pour simplifier les requêtes complexes
5. **Maintenance**: Scripts VACUUM et ANALYZE pour optimisation automatique
6. **Sauvegarde**: Script shell complet pour backup/restore/gestion

### Documentation fournie

Pour plus de détails, consultez les fichiers:
- **rapport_administration.txt**: Rapport détaillé des étapes d'administration
- **configuration.txt**: Documentation technique complète
- **fichiers_Annexes/scripts/requetes_demonstration.sql**: Exemples d'utilisation

### Résultats de l'implémentation

- Base de données opérationnelle avec 5 tables principales
- Données cohérentes pour démontrer le fonctionnement (10 équipes, 50 joueurs)
- Système de gestion des utilisateurs et permissions conforme aux bonnes pratiques
- Optimisations par index et vues pour des performances améliorées
- Scripts d'administration pour une gestion facile et automatisée