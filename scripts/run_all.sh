#!/bin/bash

# Script d'installation complète de la base de données SportTracker
# Auteur: Admin SportTracker
# Date: 2023-10-01
# -------------------------------------------

# Variables de configuration
DB_NAME="sporttracker"
DB_USER="postgres"
PG_BIN="/Library/PostgreSQL/16/bin" # Chemin PostgreSQL - à adapter selon votre installation
SCRIPTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

# Couleurs pour le terminal
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Fonction pour la journalisation
log_message() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Vérifier si la base de données existe déjà
check_database() {
    log_message "Vérification de l'existence de la base de données ${DB_NAME}..."
    if ${PG_BIN}/psql -U ${DB_USER} -lqt | cut -d \| -f 1 | grep -qw ${DB_NAME}; then
        log_warning "La base de données ${DB_NAME} existe déjà."
        read -p "Voulez-vous supprimer et recréer la base de données? (o/n): " confirm
        if [[ $confirm =~ ^[Oo]$ ]]; then
            log_message "Suppression de la base de données existante..."
            ${PG_BIN}/dropdb -U ${DB_USER} ${DB_NAME}
            return 0
        else
            log_message "Utilisation de la base de données existante."
            return 1
        fi
    else
        log_message "La base de données ${DB_NAME} n'existe pas encore."
        return 0
    fi
}

# Créer la base de données
create_database() {
    log_message "Création de la base de données ${DB_NAME}..."
    ${PG_BIN}/createdb -U ${DB_USER} ${DB_NAME}
    if [ $? -eq 0 ]; then
        log_success "Base de données ${DB_NAME} créée avec succès."
    else
        log_error "Échec de la création de la base de données ${DB_NAME}."
        exit 1
    fi
}

# Exécuter un script SQL
run_sql_script() {
    local script_name=$1
    local script_path="${SCRIPTS_DIR}/${script_name}"
    
    log_message "Exécution du script ${script_name}..."
    ${PG_BIN}/psql -U ${DB_USER} -d ${DB_NAME} -f "${script_path}"
    
    if [ $? -eq 0 ]; then
        log_success "Script ${script_name} exécuté avec succès."
    else
        log_error "Échec de l'exécution du script ${script_name}."
        exit 1
    fi
}

# Fonction principale
main() {
    log_message "Début de l'installation complète de SportTracker"
    log_message "================================================"
    
    # Vérifier si l'exécution doit continuer
    check_database
    should_create=$?
    
    if [ $should_create -eq 0 ]; then
        create_database
    fi
    
    # Exécuter les scripts dans l'ordre
    run_sql_script "create_tables.sql"
    run_sql_script "import_csv.sql"
    run_sql_script "insert_data.sql"
    run_sql_script "create_indexes.sql"
    run_sql_script "create_users.sql"
    run_sql_script "security_config.sql"
    run_sql_script "maintenance.sql"
    
    log_message "Mise à jour des privilèges..."
    ${PG_BIN}/psql -U ${DB_USER} -d ${DB_NAME} -c "GRANT CONNECT ON DATABASE ${DB_NAME} TO sporttracker_app, sporttracker_admin;"
    
    log_success "Installation de SportTracker terminée avec succès!"
    log_message "================================================"
    log_message "Vous pouvez maintenant vous connecter à la base de données avec:"
    log_message "  - Utilisateur application: sporttracker_app"
    log_message "  - Utilisateur administrateur: sporttracker_admin"
    log_message "  - Base de données: ${DB_NAME}"
    log_message "N'oubliez pas de créer ou mettre à jour le fichier .env à la racine du projet."
}

# Exécuter la fonction principale
main