-- ============================================================
-- PokéDex TCG – Insertion des données (MySQL)
-- Fichier : 3_insertion_mysql.sql
-- ============================================================

USE pokedex_tcg;

SET FOREIGN_KEY_CHECKS = 0;

-- ------------------------------------------------------------
-- EDITIONS
-- ------------------------------------------------------------
INSERT INTO EDITION (id_edition, nom_edition, date_sortie, nb_cartes) VALUES
('BASE',    'Edition de Base',              '1999-01-09', 102),
('JNG',     'Jungle',                       '1999-06-16', 64),
('FOSSIL',  'Fossile',                      '1999-10-10', 62),
('NEO1',    'Neo Genesis',                  '2000-12-16', 111),
('EX1',     'EX Rubis et Saphir',           '2003-07-18', 109),
('DP1',     'Diamant et Perle',             '2007-05-23', 130),
('BW1',     'Noir et Blanc',                '2011-04-25', 114),
('XY1',     'XY',                           '2014-02-05', 146),
('SUN1',    'Soleil et Lune',               '2017-02-03', 149),
('SW1',     'Epee et Bouclier',             '2020-02-07', 202),
('SV1',     'Ecarlate et Violet',           '2023-03-31', 198),
('SV2',     'Evolutions a Paldea',          '2023-06-09', 193);

-- ------------------------------------------------------------
-- POKEMON
-- ------------------------------------------------------------
INSERT INTO POKEMON (nom_pokemon, numero_pokedex, type_elementaire) VALUES
('Bulbizarre',      1,   'Plante'),
('Herbizarre',      2,   'Plante'),
('Florizarre',      3,   'Plante'),
('Salamèche',       4,   'Feu'),
('Reptincel',       5,   'Feu'),
('Dracaufeu',       6,   'Feu'),
('Carapuce',        7,   'Eau'),
('Carabaffe',       8,   'Eau'),
('Tortank',         9,   'Eau'),
('Pikachu',         25,  'Électrik'),
('Raichu',          26,  'Électrik'),
('Mewtwo',          150, 'Psy'),
('Mew',             151, 'Incolore'),
('Evoli',           133, 'Incolore'),
('Aquali',          134, 'Eau'),
('Voltali',         135, 'Électrik'),
('Pyroli',          136, 'Feu'),
('Lokhlass',        131, 'Eau'),
('Ronflex',         143, 'Incolore'),
('Dracolosse',      149, 'Dragon');

-- ------------------------------------------------------------
-- CARTES
-- (on insère d'abord les cartes sans id_carte_precedente, puis les évolutions)
-- ------------------------------------------------------------

-- Cartes de base (pas d'évolution précédente)
INSERT INTO CARTE (id_carte, nom_carte, numero_carte, rarete, foil, pv, attaque_principale, degats_attaque, id_edition, id_pokemon, id_carte_precedente) VALUES
('BASE-003', 'Salamèche',        46, 'Commune',            0, 50,  'Griffe',          10,  'BASE',  4,  NULL),
('BASE-006', 'Carapuce',         63, 'Commune',            0, 40,  'Morsure',         10,  'BASE',  7,  NULL),
('BASE-009', 'Bulbizarre',       44, 'Commune',            0, 40,  'Charge',          10,  'BASE',  1,  NULL),
('BASE-010', 'Mewtwo',           10, 'Rare Holographique', 1, 60,  'Psyko',           10,  'BASE',  12, NULL),
('BASE-011', 'Pikachu',          58, 'Commune',            0, 40,  'Tonnerre',        20,  'BASE',  10, NULL),
('JNG-001',  'Aquali',           12, 'Rare Holographique', 1, 80,  'Morsure',         20,  'JNG',   15, NULL),
('JNG-002',  'Voltali',          23, 'Rare Holographique', 1, 70,  'Tonnerre',        40,  'JNG',   16, NULL),
('JNG-003',  'Pyroli',           19, 'Rare Holographique', 1, 60,  'Brulure',         30,  'JNG',   17, NULL),
('JNG-004',  'Lokhlass',         8,  'Rare Holographique', 1, 90,  'Chant',           0,   'JNG',   18, NULL),
('JNG-005',  'Ronflex',          17, 'Rare',               0, 90,  'Charge',          20,  'JNG',   19, NULL),
('EX1-001',  'Dracolosse-EX',    1,  'Ultra Rare',         1, 150, 'Hyper Beam',      100, 'EX1',   20, NULL),
('SUN1-001', 'Pikachu-GX',       29, 'Ultra Rare',         1, 110, 'Eclair Geant',    50,  'SUN1',  10, NULL),
('SW1-002',  'Dracaufeu V',      19, 'Ultra Rare',         1, 220, 'Nova Flammes',    130, 'SW1',   6,  NULL),
('SV1-001',  'Mew ex',           151,'Ultra Rare',         1, 180, 'Genetique',       80,  'SV1',   13, NULL),
('SV1-002',  'Pikachu',          20, 'Commune',            0, 60,  'Tonnerre',        20,  'SV1',   10, NULL),
('SV2-001',  'Mewtwo ex',        85, 'Ultra Rare',         1, 200, 'Psyko Furie',     120, 'SV2',   12, NULL);

-- Cartes avec évolution précédente (insérées après)
INSERT INTO CARTE (id_carte, nom_carte, numero_carte, rarete, foil, pv, attaque_principale, degats_attaque, id_edition, id_pokemon, id_carte_precedente) VALUES
('BASE-008', 'Herbizarre',       43, 'Peu commune',        0, 70,  'Fouet Lianes',    30,  'BASE',  2,  'BASE-009'),
('BASE-005', 'Carabaffe',        21, 'Peu commune',        0, 80,  'Jet eau',         25,  'BASE',  8,  'BASE-006'),
('BASE-002', 'Reptincel',        23, 'Peu commune',        0, 80,  'Braise',          30,  'BASE',  5,  'BASE-003'),
('BASE-012', 'Raichu',           14, 'Rare',               0, 80,  'Eclair',          60,  'BASE',  11, 'BASE-011');

INSERT INTO CARTE (id_carte, nom_carte, numero_carte, rarete, foil, pv, attaque_principale, degats_attaque, id_edition, id_pokemon, id_carte_precedente) VALUES
('BASE-007', 'Florizarre',       15, 'Rare Holographique', 1, 100, 'Tranche-Herbe',   80,  'BASE',  3,  'BASE-008'),
('BASE-004', 'Tortank',          2,  'Rare Holographique', 1, 100, 'Hydrocanon',      100, 'BASE',  9,  'BASE-005'),
('BASE-001', 'Dracaufeu',        4,  'Rare Holographique', 1, 120, 'Lance-Flammes',   100, 'BASE',  6,  'BASE-002'),
('SW1-001',  'Dracaufeu VMAX',   20, 'Secret Rare',        1, 330, 'Feu Dechaine',    300, 'SW1',   6,  'SW1-002');

-- ------------------------------------------------------------
-- DRESSEURS
-- ------------------------------------------------------------
INSERT INTO DRESSEUR (pseudo, email, mot_de_passe, date_inscription, elo) VALUES
('AshKetchum',   'ash.ketchum@pokedextcg.fr',   '$2b$12$LQv3c1yqBWVHxkd0LHAkCO', '2023-01-15', 1850),
('MistyWater',   'misty.water@pokedextcg.fr',    '$2b$12$N9v4d2zrCXWIylE1MIBbDP', '2023-02-10', 1620),
('BrockRock',    'brock.rock@pokedextcg.fr',     '$2b$12$QRv5e3asCYXJzmF2NJCcEQ', '2023-03-05', 1540),
('GaryOak',      'gary.oak@pokedextcg.fr',       '$2b$12$KSv6f4btDZYKanG3OKDdFR', '2023-01-20', 2100),
('TrainerRed',   'trainer.red@pokedextcg.fr',    '$2b$12$HSv7g5cuEAZLboH4PLEeGS', '2022-11-30', 2350),
('PokeMaster99', 'pokemaster99@pokedextcg.fr',   '$2b$12$ISv8h6dvFBAMcpI5QMFfHT', '2023-06-01', 1200),
('SaraFlame',    'sara.flame@pokedextcg.fr',     '$2b$12$JSv9i7ewGCBNdqJ6RNGgIU', '2023-07-14', 1750),
('LucasStorm',   'lucas.storm@pokedextcg.fr',    '$2b$12$KSv0j8fxHDCOerK7SOHhJV', '2023-04-22', 1680),
('LilyLeaf',     'lily.leaf@pokedextcg.fr',      '$2b$12$LSv1k9gyIEDPfsL8TPIiKW', '2023-09-03', 1430),
('MaxSpeed',     'max.speed@pokedextcg.fr',      '$2b$12$MSv2l0hzJFEQgtM9UQJjLX', '2022-12-18', 1960);

-- ------------------------------------------------------------
-- COLLECTIONS
-- ------------------------------------------------------------
INSERT INTO COLLECTION (id_dresseur, id_carte, quantite) VALUES
(1, 'BASE-001', 1),(1, 'BASE-004', 2),(1, 'BASE-007', 1),(1, 'BASE-010', 1),
(1, 'BASE-011', 4),(1, 'BASE-012', 1),(1, 'SW1-001',  1),(1, 'SUN1-001', 1),
(2, 'BASE-004', 1),(2, 'BASE-005', 3),(2, 'BASE-006', 2),(2, 'JNG-001',  1),(2, 'JNG-004',  1),
(3, 'BASE-009', 4),(3, 'BASE-007', 1),(3, 'BASE-002', 2),(3, 'JNG-005',  1),
(4, 'BASE-001', 2),(4, 'BASE-010', 2),(4, 'EX1-001',  1),(4, 'SW1-001',  2),(4, 'SW1-002',  3),(4, 'SV1-001',  1),(4, 'SV2-001',  1),
(5, 'BASE-001', 1),(5, 'BASE-004', 1),(5, 'BASE-007', 1),(5, 'BASE-010', 3),(5, 'SW1-001',  1),(5, 'SV2-001',  2),
(6, 'BASE-011', 6),(6, 'BASE-003', 3),(6, 'BASE-006', 3),(6, 'BASE-009', 2),
(7, 'BASE-001', 1),(7, 'BASE-002', 1),(7, 'BASE-003', 2),(7, 'JNG-003',  1),(7, 'SW1-002',  1),
(8, 'BASE-011', 2),(8, 'BASE-012', 1),(8, 'JNG-002',  1),(8, 'SUN1-001', 2),
(9, 'BASE-007', 2),(9, 'BASE-008', 1),(9, 'BASE-009', 3),(9, 'JNG-004',  1),
(10,'BASE-001', 1),(10,'EX1-001',  1),(10,'SV1-001',  2),(10,'SW1-001',  1);

-- ------------------------------------------------------------
-- TOURNOIS
-- ------------------------------------------------------------
INSERT INTO TOURNOI (nom_tournoi, lieu, date_debut, date_fin) VALUES
('Championnat de Paris 2023',   'Paris, Salle Pleyel',         '2023-05-12', '2023-05-13'),
('Open Ete PokeDex TCG',        'Lyon, Centre de congres',     '2023-07-22', '2023-07-23'),
('Grand Prix Automne',          'Bordeaux, Palais des Sports', '2023-10-07', '2023-10-08'),
('Tournoi de Noel',             'Paris, Espace Champerret',    '2023-12-16', '2023-12-16'),
('Championnat de France 2024',  'Marseille, Palais du Pharo',  '2024-04-20', '2024-04-21'),
('Open Printemps 2024',         'Nantes, La Cite des Congres', '2024-03-09', '2024-03-10');

-- ------------------------------------------------------------
-- PARTICIPATIONS
-- ------------------------------------------------------------
INSERT INTO PARTICIPE (id_dresseur, id_tournoi) VALUES
(1,1),(2,1),(3,1),(4,1),(5,1),(7,1),(8,1),
(1,2),(4,2),(5,2),(6,2),(9,2),(10,2),
(2,3),(3,3),(5,3),(7,3),(8,3),(10,3),
(1,4),(2,4),(4,4),(6,4),(9,4),
(1,5),(4,5),(5,5),(7,5),(8,5),(10,5),
(2,6),(3,6),(6,6),(9,6);

-- ------------------------------------------------------------
-- COMBATS
-- ------------------------------------------------------------
INSERT INTO COMBAT (date_combat, resultat, id_joueur1, id_joueur2, id_tournoi) VALUES
('2023-05-12 10:00:00', 'joueur1', 1, 3,  1),
('2023-05-12 11:00:00', 'joueur2', 2, 4,  1),
('2023-05-12 12:00:00', 'joueur1', 5, 7,  1),
('2023-05-12 14:00:00', 'joueur2', 8, 1,  1),
('2023-05-12 15:00:00', 'joueur1', 4, 5,  1),
('2023-05-13 10:00:00', 'joueur2', 1, 4,  1),
('2023-05-13 14:00:00', 'joueur1', 5, 4,  1),
('2023-07-22 10:00:00', 'joueur1', 5, 1,  2),
('2023-07-22 11:00:00', 'nul',     4, 10, 2),
('2023-07-22 14:00:00', 'joueur2', 6, 9,  2),
('2023-07-23 10:00:00', 'joueur1', 5, 4,  2),
('2023-10-07 10:00:00', 'joueur2', 2, 5,  3),
('2023-10-07 11:00:00', 'joueur1', 7, 3,  3),
('2023-10-07 14:00:00', 'joueur1', 10,8,  3),
('2023-10-08 10:00:00', 'joueur2', 7, 5,  3),
('2023-12-16 10:00:00', 'joueur1', 1, 6,  4),
('2023-12-16 11:00:00', 'joueur2', 4, 2,  4),
('2023-12-16 14:00:00', 'joueur1', 1, 9,  4),
('2024-04-20 10:00:00', 'joueur1', 5, 8,  5),
('2024-04-20 11:00:00', 'joueur2', 1, 4,  5),
('2024-04-21 10:00:00', 'joueur1', 5, 4,  5),
('2024-03-09 10:00:00', 'joueur1', 2, 6,  6),
('2024-03-09 11:00:00', 'nul',     3, 9,  6),
('2024-03-10 10:00:00', 'joueur1', 2, 3,  6);

-- ------------------------------------------------------------
-- ECHANGES
-- ------------------------------------------------------------
INSERT INTO ECHANGE (date_echange, statut, id_emetteur, id_receveur) VALUES
('2023-06-01', 'accepte',    1, 2),
('2023-06-15', 'refuse',     3, 4),
('2023-07-10', 'accepte',    5, 6),
('2023-08-20', 'en_attente', 7, 8),
('2023-09-05', 'accepte',    2, 9),
('2023-11-12', 'refuse',     4, 10),
('2024-01-08', 'accepte',    6, 1),
('2024-02-14', 'en_attente', 8, 5);

-- ------------------------------------------------------------
-- PROPOSE
-- ------------------------------------------------------------
INSERT INTO PROPOSE (id_echange, id_carte, id_dresseur) VALUES
(1, 'BASE-011', 1),
(1, 'BASE-012', 1),
(3, 'BASE-010', 5),
(5, 'BASE-004', 2),
(7, 'BASE-011', 6),
(8, 'SUN1-001', 8);

-- ------------------------------------------------------------
-- RECOIT
-- ------------------------------------------------------------
INSERT INTO RECOIT (id_echange, id_carte, id_dresseur) VALUES
(1, 'JNG-001',  2),
(3, 'SW1-001',  6),
(5, 'JNG-004',  9),
(7, 'BASE-001', 1),
(8, 'BASE-010', 5);

-- ------------------------------------------------------------
-- AVIS
-- ------------------------------------------------------------
INSERT INTO AVIS (id_dresseur, id_carte, note, commentaire) VALUES
(1,  'BASE-001', 5, 'La carte emblematique, un indispensable de toute collection !'),
(1,  'BASE-010', 5, 'Mewtwo Base Set, legendaire et puissant.'),
(2,  'BASE-004', 5, 'Tortank holographique, chef-oeuvre absolu.'),
(2,  'JNG-001',  4, 'Aquali holo, magnifique illustration.'),
(3,  'BASE-007', 4, 'Florizarre, tres bon pour les decks Plante.'),
(4,  'SW1-001',  5, 'Dracaufeu VMAX, la star de la generation Epee et Bouclier.'),
(4,  'EX1-001',  4, 'Dracolosse EX, une des premieres cartes EX, nostalgique.'),
(5,  'BASE-001', 5, 'Dracaufeu Base Set shadowless, carte de reve.'),
(5,  'SV2-001',  4, 'Mewtwo ex Ecarlate et Violet, tres bon artwork moderne.'),
(6,  'BASE-011', 3, 'Pikachu commune, basique mais attachant.'),
(7,  'JNG-003',  4, 'Pyroli holo, bel artwork et bon Pokemon Feu.'),
(7,  'SW1-002',  5, 'Dracaufeu V, excellent pour les tournois actuels.'),
(8,  'SUN1-001', 5, 'Pikachu-GX, illustre magnifiquement pour Soleil et Lune.'),
(9,  'BASE-007', 3, 'Florizarre holo correct, mais je prefere le Tortank.'),
(9,  'JNG-004',  5, 'Lokhlass holo, illustration iconique de la Jungle.'),
(10, 'BASE-001', 5, 'Dracaufeu, le must-have ultime de toute collection.');

SET FOREIGN_KEY_CHECKS = 1;
