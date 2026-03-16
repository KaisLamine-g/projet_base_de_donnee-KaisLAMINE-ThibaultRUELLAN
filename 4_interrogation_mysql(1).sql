-- ============================================================
-- PokéDex TCG – Interrogation (MySQL)
-- Fichier : 4_interrogation_mysql.sql
-- ============================================================

USE pokedex_tcg;

-- ============================================================
-- BLOC 1 : PROJECTIONS, SÉLECTIONS, TRI, MASQUES, IN, BETWEEN
-- ============================================================

-- Requête 1 : Dresseurs avec ELO >= 1600, triés du plus fort au plus faible
SELECT pseudo, email, elo
FROM DRESSEUR
WHERE elo >= 1600
ORDER BY elo DESC;

-- Requête 2 : Cartes rares holographiques dans le catalogue premium
SELECT DISTINCT c.nom_carte, c.rarete, e.nom_edition
FROM CARTE c
JOIN EDITION e ON c.id_edition = e.id_edition
WHERE c.rarete IN ('Rare Holographique', 'Ultra Rare', 'Secret Rare')
  AND c.foil = 1
ORDER BY c.rarete, c.nom_carte;

-- Requête 3 : Cartes avec PV compris entre 80 et 150
SELECT nom_carte, pv, attaque_principale, degats_attaque
FROM CARTE
WHERE pv BETWEEN 80 AND 150
ORDER BY pv DESC;

-- Requête 4 : Dresseurs inscrits entre le 01/01/2023 et le 30/06/2023
SELECT pseudo, email, date_inscription
FROM DRESSEUR
WHERE date_inscription BETWEEN '2023-01-01' AND '2023-06-30'
ORDER BY date_inscription;

-- Requête 5 : Toutes les versions de Dracaufeu
SELECT id_carte, nom_carte, rarete, foil, id_edition
FROM CARTE
WHERE nom_carte LIKE '%Dracaufeu%'
ORDER BY id_edition;

-- Requête 6 : Echanges en attente ou acceptés
SELECT id_echange, statut, date_echange, id_emetteur, id_receveur
FROM ECHANGE
WHERE statut IN ('en_attente', 'accepte')
ORDER BY date_echange DESC;

-- Requête 7 : Liste des pseudos uniques
SELECT DISTINCT pseudo
FROM DRESSEUR
ORDER BY pseudo;

-- ============================================================
-- BLOC 2 : AGRÉGATIONS, GROUP BY, HAVING
-- ============================================================

-- Requête 8 : Nombre de cartes enregistrées par édition
SELECT e.nom_edition, COUNT(c.id_carte) AS nb_cartes_enregistrees
FROM EDITION e
LEFT JOIN CARTE c ON e.id_edition = c.id_edition
GROUP BY e.id_edition, e.nom_edition
ORDER BY nb_cartes_enregistrees DESC;

-- Requête 9 : ELO moyen, min et max des participants par tournoi
SELECT t.nom_tournoi,
       ROUND(AVG(d.elo), 0) AS elo_moyen,
       MIN(d.elo)            AS elo_min,
       MAX(d.elo)            AS elo_max
FROM TOURNOI t
JOIN PARTICIPE p ON t.id_tournoi = p.id_tournoi
JOIN DRESSEUR d  ON p.id_dresseur = d.id_dresseur
GROUP BY t.id_tournoi, t.nom_tournoi
ORDER BY elo_moyen DESC;

-- Requête 10 : Dresseurs ayant participé à plus de 2 tournois
SELECT d.pseudo, COUNT(p.id_tournoi) AS nb_tournois
FROM DRESSEUR d
JOIN PARTICIPE p ON d.id_dresseur = p.id_dresseur
GROUP BY d.id_dresseur, d.pseudo
HAVING COUNT(p.id_tournoi) > 2
ORDER BY nb_tournois DESC;

-- Requête 11 : Note moyenne des cartes avec au moins 2 avis
SELECT c.nom_carte,
       ROUND(AVG(a.note), 2) AS note_moyenne,
       COUNT(a.id_dresseur)  AS nb_avis
FROM CARTE c
JOIN AVIS a ON c.id_carte = a.id_carte
GROUP BY c.id_carte, c.nom_carte
HAVING COUNT(a.id_dresseur) >= 2
ORDER BY note_moyenne DESC;

-- Requête 12 : Nombre total de combats par dresseur
SELECT d.pseudo, COUNT(*) AS nb_combats
FROM DRESSEUR d
JOIN COMBAT c ON d.id_dresseur = c.id_joueur1
              OR d.id_dresseur = c.id_joueur2
GROUP BY d.id_dresseur, d.pseudo
ORDER BY nb_combats DESC;

-- Requête 13 : Taille de collection par dresseur
SELECT d.pseudo,
       SUM(col.quantite)   AS total_exemplaires,
       COUNT(col.id_carte) AS cartes_distinctes
FROM DRESSEUR d
JOIN COLLECTION col ON d.id_dresseur = col.id_dresseur
GROUP BY d.id_dresseur, d.pseudo
ORDER BY total_exemplaires DESC;

-- ============================================================
-- BLOC 3 : JOINTURES
-- ============================================================

-- Requête 14 : Catalogue complet cartes + Pokémon + édition (jointure multiple)
SELECT c.id_carte, c.nom_carte, c.rarete, p.nom_pokemon, p.type_elementaire, e.nom_edition
FROM CARTE c
JOIN EDITION e    ON c.id_edition = e.id_edition
LEFT JOIN POKEMON p ON c.id_pokemon = p.id_pokemon
ORDER BY e.date_sortie, c.numero_carte;

-- Requête 15 : Echanges avec noms de l'émetteur et du receveur
SELECT d.pseudo AS emetteur, ex.id_echange, ex.statut, ex.date_echange,
       d2.pseudo AS receveur
FROM DRESSEUR d
JOIN ECHANGE ex   ON d.id_dresseur = ex.id_emetteur
JOIN DRESSEUR d2  ON ex.id_receveur = d2.id_dresseur
ORDER BY ex.date_echange;

-- Requête 16 : Tous les dresseurs, même sans avis (LEFT JOIN)
SELECT d.pseudo, COUNT(a.id_carte) AS nb_avis_postes
FROM DRESSEUR d
LEFT JOIN AVIS a ON d.id_dresseur = a.id_dresseur
GROUP BY d.id_dresseur, d.pseudo
ORDER BY nb_avis_postes DESC;

-- Requête 17 : Cartes proposées dans un échange avec détails
SELECT d.pseudo AS proposant, c.nom_carte, c.rarete, ex.statut, ex.date_echange
FROM PROPOSE pr
JOIN ECHANGE ex  ON pr.id_echange  = ex.id_echange
JOIN CARTE c     ON pr.id_carte    = c.id_carte
JOIN DRESSEUR d  ON pr.id_dresseur = d.id_dresseur
ORDER BY ex.date_echange;

-- Requête 18 : Combats avec noms des deux joueurs et tournoi
SELECT t.nom_tournoi,
       j1.pseudo   AS joueur1,
       j2.pseudo   AS joueur2,
       cb.resultat,
       cb.date_combat
FROM COMBAT cb
JOIN DRESSEUR j1 ON cb.id_joueur1 = j1.id_dresseur
JOIN DRESSEUR j2 ON cb.id_joueur2 = j2.id_dresseur
JOIN TOURNOI  t  ON cb.id_tournoi = t.id_tournoi
ORDER BY cb.date_combat;

-- Requête 19 : Chaînes d'évolution (association récursive)
SELECT c1.nom_carte AS carte_actuelle,
       c2.nom_carte AS evolue_depuis,
       c1.rarete,
       e.nom_edition
FROM CARTE c1
LEFT JOIN CARTE c2 ON c1.id_carte_precedente = c2.id_carte
JOIN EDITION e     ON c1.id_edition = e.id_edition
WHERE c1.id_carte_precedente IS NOT NULL
ORDER BY e.date_sortie, c1.nom_carte;

-- ============================================================
-- BLOC 4 : REQUÊTES IMBRIQUÉES
-- ============================================================

-- Requête 20 : Dresseurs possédant au moins une Ultra Rare ou Secret Rare (IN)
SELECT DISTINCT d.pseudo, d.elo
FROM DRESSEUR d
WHERE d.id_dresseur IN (
    SELECT col.id_dresseur
    FROM COLLECTION col
    JOIN CARTE c ON col.id_carte = c.id_carte
    WHERE c.rarete IN ('Ultra Rare', 'Secret Rare')
)
ORDER BY d.elo DESC;

-- Requête 21 : Cartes jamais impliquées dans un échange (NOT IN)
SELECT c.nom_carte, c.rarete, e.nom_edition
FROM CARTE c
JOIN EDITION e ON c.id_edition = e.id_edition
WHERE c.id_carte NOT IN (
    SELECT DISTINCT id_carte FROM PROPOSE
    UNION
    SELECT DISTINCT id_carte FROM RECOIT
)
ORDER BY c.nom_carte;

-- Requête 22 : Dresseurs ayant participé à un tournoi à Paris (EXISTS)
SELECT d.pseudo, d.elo
FROM DRESSEUR d
WHERE EXISTS (
    SELECT 1
    FROM PARTICIPE p
    JOIN TOURNOI t ON p.id_tournoi = t.id_tournoi
    WHERE p.id_dresseur = d.id_dresseur
      AND t.lieu LIKE '%Paris%'
)
ORDER BY d.elo DESC;

-- Requête 23 : Dresseurs n'ayant jamais posté d'avis (NOT EXISTS)
SELECT d.pseudo, d.date_inscription
FROM DRESSEUR d
WHERE NOT EXISTS (
    SELECT 1
    FROM AVIS a
    WHERE a.id_dresseur = d.id_dresseur
)
ORDER BY d.date_inscription;

-- Requête 24 : Cartes notées par au moins un dresseur avec note > 3 (ANY)
SELECT DISTINCT c.nom_carte, c.rarete
FROM CARTE c
WHERE c.id_carte = ANY (
    SELECT a.id_carte
    FROM AVIS a
    WHERE a.note > 3
)
ORDER BY c.nom_carte;

-- Requête 25 : Dresseurs dont l'ELO dépasse celui de tous les inscrits en 2023 (ALL)
SELECT pseudo, elo
FROM DRESSEUR
WHERE elo > ALL (
    SELECT elo
    FROM DRESSEUR
    WHERE date_inscription BETWEEN '2023-01-01' AND '2023-12-31'
      AND elo < 2000
)
ORDER BY elo DESC;

-- Requête 26 : Classement des dresseurs par victoires (table dérivée + UNION ALL)
SELECT d.pseudo,
       d.elo,
       COALESCE(SUM(v.nb_victoires), 0) AS nb_victoires
FROM DRESSEUR d
LEFT JOIN (
    SELECT id_joueur1 AS id_vainqueur, COUNT(*) AS nb_victoires
    FROM COMBAT WHERE resultat = 'joueur1'
    GROUP BY id_joueur1
    UNION ALL
    SELECT id_joueur2 AS id_vainqueur, COUNT(*) AS nb_victoires
    FROM COMBAT WHERE resultat = 'joueur2'
    GROUP BY id_joueur2
) v ON d.id_dresseur = v.id_vainqueur
GROUP BY d.id_dresseur, d.pseudo, d.elo
ORDER BY nb_victoires DESC, d.elo DESC;
