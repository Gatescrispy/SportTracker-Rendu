#!/bin/bash

# Script de sauvegarde et restauration pour la base de données SportTracker
# Auteur: Admin SportTracker
# Date: 2023-10-01
# -------------------------------------------

# Variables de configuration
DB_NAME="sporttracker"
BACKUP_DIR="./backups"
DATE=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="${BACKUP_DIR}/${DB_NAME}_${DATE}.sql"
LOG_FILE="${BACKUP_DIR}/backup_log.txt"
PG_BIN="/Library/PostgreSQL/16/bin" # Chemin PostgreSQL - à adapter selon votre installation

# Assurez-vous que le répertoire de sauvegarde existe
mkdir -p ${BACKUP_DIR}

# Fonction pour la journalisation
log_message() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" | tee -a ${LOG_FILE}
}

# Fonction pour effectuer la sauvegarde
perform_backup() {
    log_message "Début de la sauvegarde de la base de données ${DB_NAME}"
    
    # Ajoutez les variables d'environnement pour la connexion si nécessaire
    # export PGHOST="localhost"
    # export PGPORT="5432"
    # export PGUSER="sporttracker_admin"
    # export PGPASSWORD="admin_password_secure456"
    
    # Effectuer la sauvegarde avec pg_dump
    ${PG_BIN}/pg_dump -Fc -v --file=${BACKUP_FILE} ${DB_NAME}
    
    # Vérifier si la sauvegarde a réussi
    if [ $? -eq 0 ]; then
        log_message "Sauvegarde réussie: ${BACKUP_FILE}"
        # Compresser le fichier de sauvegarde
        gzip ${BACKUP_FILE}
        log_message "Fichier compressé: ${BACKUP_FILE}.gz"
    else
        log_message "ERREUR: La sauvegarde a échoué!"
        exit 1
    fi
}

# Fonction pour effectuer une restauration
perform_restore() {
    if [ -z "$1" ]; then
        log_message "ERREUR: Aucun fichier de sauvegarde spécifié pour la restauration"
        echo "Usage: $0 restore <fichier_sauvegarde>"
        exit 1
    fi
    
    RESTORE_FILE=$1
    
    # Vérifier si le fichier existe
    if [ ! -f ${RESTORE_FILE} ]; then
        log_message "ERREUR: Le fichier de sauvegarde ${RESTORE_FILE} n'existe pas"
        exit 1
    fi
    
    log_message "Début de la restauration de la base de données ${DB_NAME} à partir de ${RESTORE_FILE}"
    
    # Pour les fichiers gzippés
    if [[ ${RESTORE_FILE} == *.gz ]]; then
        log_message "Décompression du fichier de sauvegarde"
        gunzip -c ${RESTORE_FILE} > ${RESTORE_FILE%.gz}
        RESTORE_FILE=${RESTORE_FILE%.gz}
    fi
    
    # Restaurer la base de données
    if [[ ${RESTORE_FILE} == *.sql ]]; then
        # Fichier SQL standard
        ${PG_BIN}/psql -d ${DB_NAME} -f ${RESTORE_FILE}
    else
        # Format personnalisé
        ${PG_BIN}/pg_restore -v -d ${DB_NAME} ${RESTORE_FILE}
    fi
    
    # Vérifier si la restauration a réussi
    if [ $? -eq 0 ]; then
        log_message "Restauration réussie à partir de ${RESTORE_FILE}"
    else
        log_message "ERREUR: La restauration a échoué!"
        exit 1
    fi
}

# Fonction pour lister les sauvegardes disponibles
list_backups() {
    log_message "Liste des sauvegardes disponibles:"
    ls -lh ${BACKUP_DIR}/*.sql* 2>/dev/null || echo "Aucune sauvegarde trouvée dans ${BACKUP_DIR}"
}

# Fonction pour nettoyer les anciennes sauvegardes
cleanup_old_backups() {
    log_message "Nettoyage des sauvegardes de plus de 30 jours"
    find ${BACKUP_DIR} -name "${DB_NAME}_*.sql*" -type f -mtime +30 -delete
    log_message "Nettoyage terminé"
}

# Main - traiter les arguments
case "$1" in
    backup)
        perform_backup
        ;;
    restore)
        perform_restore "$2"
        ;;
    list)
        list_backups
        ;;
    cleanup)
        cleanup_old_backups
        ;;
    *)
        echo "Usage: $0 {backup|restore <fichier>|list|cleanup}"
        echo "  backup  : Effectue une sauvegarde de la base de données"
        echo "  restore : Restaure la base de données à partir d'une sauvegarde"
        echo "  list    : Liste les sauvegardes disponibles"
        echo "  cleanup : Supprime les sauvegardes de plus de 30 jours"
        exit 1
        ;;
esac

exit 0