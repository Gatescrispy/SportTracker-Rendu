-- Création de la base de données SportTracker
-- Ce script va créer toutes les tables nécessaires pour le système SportTracker

-- Création de la table des sports
CREATE TABLE IF NOT EXISTS sports (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    type VARCHAR(50),
    description TEXT
);

-- Création de la table des équipes
CREATE TABLE IF NOT EXISTS equipes (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    etablissement VARCHAR(200) NOT NULL,
    coach VARCHAR(100),
    division VARCHAR(50)
);

-- Création de la table des joueurs
CREATE TABLE IF NOT EXISTS joueurs (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    equipe_id INTEGER REFERENCES equipes(id),
    position VARCHAR(50),
    annee_naissance INTEGER
);

-- Création de la table des matchs
CREATE TABLE IF NOT EXISTS matchs (
    id SERIAL PRIMARY KEY,
    date TIMESTAMP NOT NULL,
    equipe_domicile_id INTEGER REFERENCES equipes(id),
    equipe_visiteur_id INTEGER REFERENCES equipes(id),
    score_domicile INTEGER NOT NULL DEFAULT 0,
    score_visiteur INTEGER NOT NULL DEFAULT 0,
    sport_id INTEGER REFERENCES sports(id),
    CONSTRAINT equipes_differentes CHECK (equipe_domicile_id != equipe_visiteur_id)
);

-- Création de la table des statistiques des joueurs par match
CREATE TABLE IF NOT EXISTS statistiques_joueurs (
    id SERIAL PRIMARY KEY,
    joueur_id INTEGER REFERENCES joueurs(id),
    match_id INTEGER REFERENCES matchs(id),
    points_marques INTEGER DEFAULT 0,
    temps_jeu INTEGER, -- en minutes
    autres_stats JSONB, -- stockage flexible pour différentes statistiques selon le sport
    CONSTRAINT unique_joueur_match UNIQUE (joueur_id, match_id)
);