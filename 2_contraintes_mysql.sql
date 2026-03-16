-- ============================================================
-- PokéDex TCG – Contraintes de validation (MySQL)
-- Fichier : 2_contraintes.sql
-- ============================================================
-- NOTE : Sous MySQL 8, les contraintes CHECK ne peuvent pas être
-- ajoutées via ALTER TABLE sur des colonnes déjà référencées par
-- une FK avec action (ON DELETE/UPDATE). Elles sont donc toutes
-- définies directement dans le CREATE TABLE (1_creation_mysql.sql).
-- Ce fichier sert à documenter et vérifier les contraintes en place.
-- ============================================================

USE pokedex_tcg;

-- ============================================================
-- LISTE DES CONTRAINTES ACTIVES PAR TABLE
-- ============================================================

-- Pour visualiser toutes les contraintes CHECK de la base :
SELECT
    tc.TABLE_NAME,
    tc.CONSTRAINT_NAME,
    cc.CHECK_CLAUSE
FROM information_schema.TABLE_CONSTRAINTS tc
JOIN information_schema.CHECK_CONSTRAINTS cc
    ON tc.CONSTRAINT_NAME = cc.CONSTRAINT_NAME
    AND tc.CONSTRAINT_SCHEMA = cc.CONSTRAINT_CATALOG
WHERE tc.CONSTRAINT_SCHEMA = 'pokedex_tcg'
  AND tc.CONSTRAINT_TYPE = 'CHECK'
ORDER BY tc.TABLE_NAME, tc.CONSTRAINT_NAME;

-- ============================================================
-- TESTS DE VALIDATION DES CONTRAINTES
-- (chaque INSERT doit provoquer une erreur pour prouver que
--  la contrainte fonctionne — à exécuter une par une en démo)
-- ============================================================

-- TEST 1 : Note hors plage 1-5 → doit échouer (chk_note_range)
-- INSERT INTO AVIS VALUES (1, 'BASE-001', 6, 'Test note invalide');

-- TEST 2 : Rareté invalide → doit échouer (chk_rarete)
-- INSERT INTO CARTE (id_carte, nom_carte, numero_carte, rarete, foil, id_edition)
-- VALUES ('TEST-001', 'Carte Test', 1, 'Mega Rare', 0, 'BASE');

-- TEST 3 : Statut d'échange invalide → doit échouer (chk_echange_statut)
-- INSERT INTO ECHANGE (date_echange, statut, id_emetteur, id_receveur)
-- VALUES ('2024-01-01', 'en_cours', 1, 2);

-- TEST 4 : Résultat de combat invalide → doit échouer (chk_combat_resultat)
-- INSERT INTO COMBAT (date_combat, resultat, id_joueur1, id_joueur2, id_tournoi)
-- VALUES ('2024-01-01 10:00:00', 'abandon', 1, 2, 1);

-- TEST 5 : PV négatifs → doit échouer (chk_pv_positif)
-- INSERT INTO CARTE (id_carte, nom_carte, numero_carte, rarete, foil, pv, id_edition)
-- VALUES ('TEST-002', 'Carte PV nul', 1, 'Commune', 0, -10, 'BASE');

-- TEST 6 : Quantité collection à 0 → doit échouer (chk_quantite_positive)
-- INSERT INTO COLLECTION (id_dresseur, id_carte, quantite)
-- VALUES (1, 'BASE-002', 0);

-- TEST 7 : ELO négatif → doit échouer (chk_elo_positif)
-- INSERT INTO DRESSEUR (pseudo, email, mot_de_passe, elo)
-- VALUES ('TestUser', 'test@test.fr', 'hash', -500);

-- TEST 8 : Type élémentaire invalide → doit échouer (chk_type_elementaire)
-- INSERT INTO POKEMON (nom_pokemon, numero_pokedex, type_elementaire)
-- VALUES ('FakeMon', 999, 'Cosmique');

-- TEST 9 : Edition avant 1996 → doit échouer (chk_edition_date_min)
-- INSERT INTO EDITION (id_edition, nom_edition, date_sortie, nb_cartes)
-- VALUES ('OLD', 'Trop vieille', '1990-01-01', 50);

-- TEST 10 : Date fin tournoi < date début → doit échouer (chk_tournoi_dates)
-- INSERT INTO TOURNOI (nom_tournoi, lieu, date_debut, date_fin)
-- VALUES ('Tournoi impossible', 'Paris', '2024-06-10', '2024-06-05');

-- ============================================================
-- POUR EXÉCUTER UN TEST EN DÉMO : décommenter la ligne voulue
-- et l'exécuter seule (Ctrl+Maj+Entrée sur la ligne sélectionnée)
-- ============================================================

-- ============================================================
-- CONTRAINTES D'INTÉGRITÉ RÉFÉRENTIELLE (FK)
-- ============================================================

-- TEST FK 1 : Carte avec édition inexistante → doit échouer
-- INSERT INTO CARTE (id_carte, nom_carte, numero_carte, rarete, foil, id_edition)
-- VALUES ('FAKE-001', 'Carte Fantome', 1, 'Commune', 0, 'EDITION_INEXISTANTE');

-- TEST FK 2 : ON DELETE CASCADE — supprimer une édition supprime ses cartes
-- (à faire en démo puis re-insérer les données via 3_insertion_mysql.sql)
-- DELETE FROM EDITION WHERE id_edition = 'JNG';
-- SELECT * FROM CARTE WHERE id_edition = 'JNG'; -- doit retourner 0 ligne

-- TEST FK 3 : ON DELETE RESTRICT — supprimer un dresseur référencé dans COMBAT
-- doit échouer car id_joueur1/id_joueur2 sont en RESTRICT
-- DELETE FROM DRESSEUR WHERE id_dresseur = 1;
