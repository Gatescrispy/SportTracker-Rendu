-- Script de création des utilisateurs et attribution des permissions
-- Auteur: Admin SportTracker
-- Date: 2023-10-01
-- -------------------------------------------

-- Création de l'utilisateur application
DO $$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'sporttracker_app') THEN
        CREATE USER sporttracker_app WITH PASSWORD 'app_password_secure123';
    END IF;
END
$$;

-- Création de l'utilisateur administrateur
DO $$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'sporttracker_admin') THEN
        CREATE USER sporttracker_admin WITH PASSWORD 'admin_password_secure456';
    END IF;
END
$$;

-- Permissions pour l'utilisateur de l'application
GRANT CONNECT ON DATABASE sporttracker TO sporttracker_app;
GRANT USAGE ON SCHEMA public TO sporttracker_app;

-- Droits SELECT, INSERT, UPDATE sur toutes les tables existantes
GRANT SELECT, INSERT, UPDATE ON ALL TABLES IN SCHEMA public TO sporttracker_app;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO sporttracker_app;

-- Permissions pour les futurs objets qui seront créés
ALTER DEFAULT PRIVILEGES IN SCHEMA public 
GRANT SELECT, INSERT, UPDATE ON TABLES TO sporttracker_app;

ALTER DEFAULT PRIVILEGES IN SCHEMA public 
GRANT USAGE, SELECT ON SEQUENCES TO sporttracker_app;

-- Permissions complètes pour l'administrateur
GRANT ALL PRIVILEGES ON DATABASE sporttracker TO sporttracker_admin;
GRANT ALL PRIVILEGES ON SCHEMA public TO sporttracker_admin;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO sporttracker_admin;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO sporttracker_admin;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public TO sporttracker_admin;

-- Permissions pour les futurs objets qui seront créés
ALTER DEFAULT PRIVILEGES IN SCHEMA public 
GRANT ALL PRIVILEGES ON TABLES TO sporttracker_admin;

ALTER DEFAULT PRIVILEGES IN SCHEMA public 
GRANT ALL PRIVILEGES ON SEQUENCES TO sporttracker_admin;

ALTER DEFAULT PRIVILEGES IN SCHEMA public 
GRANT ALL PRIVILEGES ON FUNCTIONS TO sporttracker_admin;