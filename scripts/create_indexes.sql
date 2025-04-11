-- Script de création des index pour optimiser les performances
-- Auteur: Admin SportTracker
-- Date: 2023-10-01
-- -------------------------------------------

-- Index sur la table équipes
-- Pour optimiser les recherches par nom d'équipe
CREATE INDEX IF NOT EXISTS idx_equipes_nom ON equipes (nom);
-- Pour optimiser les filtres par établissement
CREATE INDEX IF NOT EXISTS idx_equipes_etablissement ON equipes (etablissement);
-- Pour optimiser les filtres par division
CREATE INDEX IF NOT EXISTS idx_equipes_division ON equipes (division);

-- Index sur la table joueurs
-- Pour optimiser les jointures avec la table équipes
CREATE INDEX IF NOT EXISTS idx_joueurs_equipe_id ON joueurs (equipe_id);
-- Pour optimiser les recherches par nom/prénom
CREATE INDEX IF NOT EXISTS idx_joueurs_nom_prenom ON joueurs (nom, prenom);
-- Pour optimiser les filtres par position
CREATE INDEX IF NOT EXISTS idx_joueurs_position ON joueurs (position);

-- Index sur la table matchs
-- Pour optimiser les recherches chronologiques
CREATE INDEX IF NOT EXISTS idx_matchs_date ON matchs (date);
-- Pour optimiser les recherches par équipe domicile
CREATE INDEX IF NOT EXISTS idx_matchs_equipe_domicile ON matchs (equipe_domicile_id);
-- Pour optimiser les recherches par équipe visiteuse
CREATE INDEX IF NOT EXISTS idx_matchs_equipe_visiteur ON matchs (equipe_visiteur_id);
-- Pour optimiser les filtres par sport
CREATE INDEX IF NOT EXISTS idx_matchs_sport ON matchs (sport_id);

-- Index sur la table statistiques_joueurs
-- Pour optimiser les recherches par joueur
CREATE INDEX IF NOT EXISTS idx_statistiques_joueur ON statistiques_joueurs (joueur_id);
-- Pour optimiser les recherches par match
CREATE INDEX IF NOT EXISTS idx_statistiques_match ON statistiques_joueurs (match_id);
-- Pour optimiser les classements par points marqués
CREATE INDEX IF NOT EXISTS idx_statistiques_points ON statistiques_joueurs (points_marques DESC);

-- Commentaire sur les index créés
COMMENT ON INDEX idx_equipes_nom IS 'Index pour optimiser les recherches par nom d''équipe';
COMMENT ON INDEX idx_joueurs_equipe_id IS 'Index pour optimiser les jointures entre joueurs et équipes';
COMMENT ON INDEX idx_matchs_date IS 'Index pour optimiser les recherches chronologiques de matchs';