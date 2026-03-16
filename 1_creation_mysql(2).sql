-- ============================================================
-- PokéDex TCG – MPD MySQL
-- Fichier : 1_creation_mysql.sql
-- ============================================================

CREATE DATABASE IF NOT EXISTS pokedex_tcg CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE pokedex_tcg;

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS AVIS;
DROP TABLE IF EXISTS RECOIT;
DROP TABLE IF EXISTS PROPOSE;
DROP TABLE IF EXISTS ECHANGE;
DROP TABLE IF EXISTS COMBAT;
DROP TABLE IF EXISTS PARTICIPE;
DROP TABLE IF EXISTS TOURNOI;
DROP TABLE IF EXISTS COLLECTION;
DROP TABLE IF EXISTS CARTE;
DROP TABLE IF EXISTS EDITION;
DROP TABLE IF EXISTS POKEMON;
DROP TABLE IF EXISTS DRESSEUR;

SET FOREIGN_KEY_CHECKS = 1;

-- ------------------------------------------------------------
-- DRESSEUR
-- ------------------------------------------------------------
CREATE TABLE DRESSEUR (
    id_dresseur     INT             NOT NULL AUTO_INCREMENT,
    pseudo          VARCHAR(50)     NOT NULL,
    email           VARCHAR(100)    NOT NULL UNIQUE,
    mot_de_passe    VARCHAR(255)    NOT NULL,
    date_inscription DATE           NOT NULL DEFAULT (CURRENT_DATE),
    elo             INT             NOT NULL DEFAULT 1000,
    PRIMARY KEY (id_dresseur),
    CONSTRAINT chk_elo_positif      CHECK (elo >= 0),
    CONSTRAINT chk_pseudo_non_vide  CHECK (TRIM(pseudo) <> '')
);

-- ------------------------------------------------------------
-- EDITION
-- ------------------------------------------------------------
CREATE TABLE EDITION (
    id_edition      VARCHAR(10)     NOT NULL,
    nom_edition     VARCHAR(100)    NOT NULL,
    date_sortie     DATE            NOT NULL,
    nb_cartes       SMALLINT        NOT NULL,
    PRIMARY KEY (id_edition),
    CONSTRAINT chk_nb_cartes_positif    CHECK (nb_cartes >= 1),
    CONSTRAINT chk_edition_date_min     CHECK (date_sortie >= '1996-01-01')
);

-- ------------------------------------------------------------
-- POKEMON
-- ------------------------------------------------------------
CREATE TABLE POKEMON (
    id_pokemon          INT             NOT NULL AUTO_INCREMENT,
    nom_pokemon         VARCHAR(50)     NOT NULL,
    numero_pokedex      SMALLINT        NOT NULL UNIQUE,
    type_elementaire    VARCHAR(20)     NOT NULL,
    PRIMARY KEY (id_pokemon),
    CONSTRAINT chk_pokedex_range    CHECK (numero_pokedex BETWEEN 1 AND 9999),
    CONSTRAINT chk_type_elementaire CHECK (type_elementaire IN (
        'Feu','Eau','Plante','Électrik','Psy','Combat',
        'Ténèbres','Métal','Dragon','Fée','Normal',
        'Vol','Poison','Sol','Roche','Insecte',
        'Spectre','Glace','Incolore'
    ))
);

-- ------------------------------------------------------------
-- CARTE
-- ------------------------------------------------------------
CREATE TABLE CARTE (
    id_carte                VARCHAR(20)     NOT NULL,
    nom_carte               VARCHAR(100)    NOT NULL,
    numero_carte            SMALLINT        NOT NULL,
    rarete                  VARCHAR(30)     NOT NULL,
    foil                    TINYINT(1)      NOT NULL DEFAULT 0,
    pv                      SMALLINT,
    attaque_principale      VARCHAR(60),
    degats_attaque          SMALLINT,
    id_edition              VARCHAR(10)     NOT NULL,
    id_pokemon              INT,
    id_carte_precedente     VARCHAR(20),
    PRIMARY KEY (id_carte),
    CONSTRAINT fk_carte_edition
        FOREIGN KEY (id_edition) REFERENCES EDITION(id_edition)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_carte_pokemon
        FOREIGN KEY (id_pokemon) REFERENCES POKEMON(id_pokemon)
        ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT fk_carte_evolution
        FOREIGN KEY (id_carte_precedente) REFERENCES CARTE(id_carte)
        ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT chk_rarete CHECK (rarete IN (
        'Commune','Peu commune','Rare',
        'Rare Holographique','Ultra Rare','Secret Rare'
    )),
    CONSTRAINT chk_pv_positif           CHECK (pv IS NULL OR pv > 0),
    CONSTRAINT chk_degats_positifs      CHECK (degats_attaque IS NULL OR degats_attaque >= 0),
    CONSTRAINT chk_numero_carte_positif CHECK (numero_carte >= 1)
    -- Note : chk_evolution_non_reflexive supprimée car MySQL 8 interdit un CHECK
    -- sur une colonne déjà utilisée dans une action référentielle de FK
);

-- ------------------------------------------------------------
-- COLLECTION
-- ------------------------------------------------------------
CREATE TABLE COLLECTION (
    id_dresseur     INT             NOT NULL,
    id_carte        VARCHAR(20)     NOT NULL,
    quantite        SMALLINT        NOT NULL DEFAULT 1,
    PRIMARY KEY (id_dresseur, id_carte),
    CONSTRAINT fk_collection_dresseur
        FOREIGN KEY (id_dresseur) REFERENCES DRESSEUR(id_dresseur)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_collection_carte
        FOREIGN KEY (id_carte) REFERENCES CARTE(id_carte)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT chk_quantite_positive CHECK (quantite >= 1)
);

-- ------------------------------------------------------------
-- TOURNOI
-- ------------------------------------------------------------
CREATE TABLE TOURNOI (
    id_tournoi      INT             NOT NULL AUTO_INCREMENT,
    nom_tournoi     VARCHAR(100)    NOT NULL,
    lieu            VARCHAR(150)    NOT NULL,
    date_debut      DATE            NOT NULL,
    date_fin        DATE            NOT NULL,
    PRIMARY KEY (id_tournoi),
    CONSTRAINT chk_tournoi_dates    CHECK (date_fin >= date_debut),
    CONSTRAINT chk_lieu_non_vide    CHECK (TRIM(lieu) <> '')
);

-- ------------------------------------------------------------
-- PARTICIPE
-- ------------------------------------------------------------
CREATE TABLE PARTICIPE (
    id_dresseur     INT             NOT NULL,
    id_tournoi      INT             NOT NULL,
    PRIMARY KEY (id_dresseur, id_tournoi),
    CONSTRAINT fk_participe_dresseur
        FOREIGN KEY (id_dresseur) REFERENCES DRESSEUR(id_dresseur)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_participe_tournoi
        FOREIGN KEY (id_tournoi) REFERENCES TOURNOI(id_tournoi)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- ------------------------------------------------------------
-- COMBAT
-- ------------------------------------------------------------
CREATE TABLE COMBAT (
    id_combat       INT             NOT NULL AUTO_INCREMENT,
    date_combat     DATETIME        NOT NULL,
    resultat        VARCHAR(10),
    id_joueur1      INT             NOT NULL,
    id_joueur2      INT             NOT NULL,
    id_tournoi      INT             NOT NULL,
    PRIMARY KEY (id_combat),
    CONSTRAINT fk_combat_joueur1
        FOREIGN KEY (id_joueur1) REFERENCES DRESSEUR(id_dresseur)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_combat_joueur2
        FOREIGN KEY (id_joueur2) REFERENCES DRESSEUR(id_dresseur)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_combat_tournoi
        FOREIGN KEY (id_tournoi) REFERENCES TOURNOI(id_tournoi)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT chk_combat_resultat CHECK (resultat IN ('joueur1','joueur2','nul') OR resultat IS NULL)
    -- Note : chk_combat_joueurs_differents supprimée (MySQL 8 interdit CHECK sur colonne FK avec action)
);

-- ------------------------------------------------------------
-- ECHANGE
-- ------------------------------------------------------------
CREATE TABLE ECHANGE (
    id_echange      INT             NOT NULL AUTO_INCREMENT,
    date_echange    DATE            NOT NULL DEFAULT (CURRENT_DATE),
    statut          VARCHAR(20)     NOT NULL DEFAULT 'en_attente',
    id_emetteur     INT             NOT NULL,
    id_receveur     INT             NOT NULL,
    PRIMARY KEY (id_echange),
    CONSTRAINT fk_echange_emetteur
        FOREIGN KEY (id_emetteur) REFERENCES DRESSEUR(id_dresseur)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_echange_receveur
        FOREIGN KEY (id_receveur) REFERENCES DRESSEUR(id_dresseur)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT chk_echange_statut CHECK (statut IN ('en_attente','accepte','refuse'))
    -- Note : chk_echange_joueurs_differents supprimée (MySQL 8 interdit CHECK sur colonne FK avec action)
);

-- ------------------------------------------------------------
-- PROPOSE
-- ------------------------------------------------------------
CREATE TABLE PROPOSE (
    id_echange      INT             NOT NULL,
    id_carte        VARCHAR(20)     NOT NULL,
    id_dresseur     INT             NOT NULL,
    PRIMARY KEY (id_echange, id_carte, id_dresseur),
    CONSTRAINT fk_propose_echange
        FOREIGN KEY (id_echange) REFERENCES ECHANGE(id_echange)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_propose_carte
        FOREIGN KEY (id_carte) REFERENCES CARTE(id_carte)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_propose_dresseur
        FOREIGN KEY (id_dresseur) REFERENCES DRESSEUR(id_dresseur)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- ------------------------------------------------------------
-- RECOIT
-- ------------------------------------------------------------
CREATE TABLE RECOIT (
    id_echange      INT             NOT NULL,
    id_carte        VARCHAR(20)     NOT NULL,
    id_dresseur     INT             NOT NULL,
    PRIMARY KEY (id_echange, id_carte, id_dresseur),
    CONSTRAINT fk_recoit_echange
        FOREIGN KEY (id_echange) REFERENCES ECHANGE(id_echange)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_recoit_carte
        FOREIGN KEY (id_carte) REFERENCES CARTE(id_carte)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_recoit_dresseur
        FOREIGN KEY (id_dresseur) REFERENCES DRESSEUR(id_dresseur)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- ------------------------------------------------------------
-- AVIS
-- ------------------------------------------------------------
CREATE TABLE AVIS (
    id_dresseur     INT             NOT NULL,
    id_carte        VARCHAR(20)     NOT NULL,
    note            SMALLINT        NOT NULL,
    commentaire     VARCHAR(500),
    PRIMARY KEY (id_dresseur, id_carte),
    CONSTRAINT fk_avis_dresseur
        FOREIGN KEY (id_dresseur) REFERENCES DRESSEUR(id_dresseur)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_avis_carte
        FOREIGN KEY (id_carte) REFERENCES CARTE(id_carte)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT chk_note_range CHECK (note BETWEEN 1 AND 5)
);
