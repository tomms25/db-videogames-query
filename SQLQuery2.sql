
--Singola tabella

1- Selezionare tutte le software house americane (3)
SELECT * FROM software_houses
WHERE country = 'United States' 


2- Selezionare tutti i giocatori della città di 'Rogahnland' (2)
SELECT * FROM players
WHERE city = 'Rogahnland'


3- Selezionare tutti i giocatori il cui nome finisce per "a" (220)
SELECT * FROM players
WHERE name LIKE '%a'

4- Selezionare tutte le recensioni scritte dal giocatore con ID = 800 (11)
SELECT * FROM reviews
WHERE player_id = 800


5- Contare quanti tornei ci sono stati nell'anno 2015 (9)
SELECT COUNT(*) FROM tournaments
WHERE `year`  = 2015

6- Selezionare tutti i premi che contengono nella descrizione la parola 'facere' (2)
SELECT * FROM awards
WHERE description LIKE '%facere%'

7- Selezionare tutti i videogame che hanno la categoria 2 (FPS) o 6 (RPG), mostrandoli una sola volta (del videogioco vogliamo solo l'ID) (287)
SELECT DISTINCT videogames.id
FROM videogames
JOIN category_videogame ON videogames.id = category_videogame.videogame_id
WHERE category_videogame.category_id IN (2, 6)

8- Selezionare tutte le recensioni con voto compreso tra 2 e 4 (2947)
SELECT * FROM reviews
WHERE rating  BETWEEN 2 AND 4

9- Selezionare tutti i dati dei videogiochi rilasciati nell'anno 2020 (46)
SELECT * FROM videogames
WHERE YEAR(release_date) = 2020

10- Selezionare gli id dei videogame che hanno ricevuto almeno una recensione da 5 stelle, mostrandoli una sola volta (443)
SELECT DISTINCT videogame_id
FROM videogames.reviews
WHERE rating = 5

##### **BONUS**
11. Selezionare il numero e la media delle recensioni per il videogioco con ID = 412 (review number = 12, avg_rating = 3.16 circa)
SELECT COUNT(*), avg(rating)
FROM videogames.reviews
WHERE videogame_id = 412

12. Selezionare il numero di videogame che la software house con ID = 1 ha rilasciato nel 2018 (13)
SELECT COUNT(*)
FROM videogames.videogames
WHERE software_house_id = 1 AND YEAR(release_date) = 2018



--GROUP BY

1- Contare quante software house ci sono per ogni paese (3)
SELECT country, COUNT(*) as num_software_houses
FROM software_houses
GROUP BY country

2- Contare quante recensioni ha ricevuto ogni videogioco (del videogioco vogliamo solo l'ID)  (500)
SELECT videogame_id, COUNT(*) as num_recensioni
FROM reviews
GROUP BY videogame_id

3- Contare quanti videogiochi hanno ciascuna classificazione PEGI (della classificazione PEGI vogliamo solo l'ID) (13)
select count(*)
from pegi_label_videogame plv 
group by pegi_label_id

4- Mostrare il numero di videogiochi rilasciati ogni anno (11)
SELECT YEAR(release_date) as year, COUNT(*) as num_videogiochi
FROM videogames
GROUP BY year
ORDER BY year ASC

5- Contare quanti videogiochi sono disponbiili per ciascun device (del device vogliamo solo l'ID) (7)
SELECT device_id, COUNT(*) as num_videogiochi
FROM device_videogame 
GROUP BY device_id

6- Ordinare i videogame in base alla media delle recensioni (del videogioco vogliamo solo l'ID) (500)
SELECT videogame_id, AVG(rating) as avg_rating
FROM reviews
GROUP BY videogame_id
ORDER BY avg_rating DESC


--JOIN

1- Selezionare i dati di tutti giocatori che hanno scritto almeno una recensione, mostrandoli una sola volta (996)
SELECT DISTINCT players.*
FROM players
INNER JOIN reviews ON players.id = reviews.player_id;

2- Sezionare tutti i videogame dei tornei tenuti nel 2016, mostrandoli una sola volta (226)
SELECT DISTINCT videogames.*
FROM videogames
INNER JOIN tournament_videogame ON videogames.id = tournament_videogame.videogame_id
INNER JOIN tournaments ON tournament_videogame.tournament_id = tournaments.id
WHERE tournaments.`year` = 2016;

3- Mostrare le categorie di ogni videogioco (1718)
SELECT categories.name, videogames.name 
FROM videogames.categories
JOIN category_videogame
ON categories.id = category_videogame.category_id
JOIN videogames
ON category_videogame.videogame_id = videogames.id

4- Selezionare i dati di tutte le software house che hanno rilasciato almeno un gioco dopo il 2020, mostrandoli una sola volta (6)
SELECT DISTINCT software_houses.*
FROM software_houses
INNER JOIN videogames ON software_houses.id = videogames.software_house_id
WHERE videogames.release_date  > 2020;

5- Selezionare i premi ricevuti da ogni software house per i videogiochi che ha prodotto (55)
SELECT software_houses.name AS software_house, awards.name AS award, COUNT(*) AS num_awards
FROM software_houses
INNER JOIN videogames ON software_houses.id = videogames.software_house_id
INNER JOIN award_videogame ON videogames.id = award_videogame.videogame_id
INNER JOIN awards ON award_videogame.award_id = awards.id
GROUP BY software_houses.id, awards.id;

6. Selezionare categorie e classificazioni PEGI dei videogiochi che hanno ricevuto recensioni da 4 e 5 stelle, mostrandole una sola volta (3363)
SELECT DISTINCT categories.name, pegi_labels.name,videogames.name
FROM videogames.videogames
JOIN category_videogame
ON videogames.id = category_videogame.videogame_id
JOIN categories
ON category_videogame.category_id = categories.id
JOIN pegi_label_videogame
ON videogames.id = pegi_label_videogame.videogame_id
JOIN pegi_labels
ON pegi_label_videogame.pegi_label_id = pegi_labels.id
JOIN reviews
ON videogames.id = reviews.videogame_id
WHERE rating >=4

7. Selezionare quali giochi erano presenti nei tornei nei quali hanno partecipato i giocatori il cui nome inizia per 'S' (474)
SELECT DISTINCT videogames.name
FROM videogames.videogames
JOIN tournament_videogame
ON videogames.id = tournament_videogame.videogame_id
JOIN tournaments
ON tournament_videogame.tournament_id = tournaments.id
JOIN player_tournament
ON tournaments.id = player_tournament.tournament_id
JOIN players
ON player_tournament.player_id = players.id

WHERE players.name LIKE 's%'

8. Selezionare le cittÃ  in cui Ã¨ stato giocato il gioco dell'anno del 2018 (36)
SELECT  DISTINCT tournaments.city
FROM videogames.tournaments
JOIN tournament_videogame
ON tournaments.id = tournament_videogame.tournament_id
JOIN videogames
ON tournament_videogame.videogame_id = videogames.id
JOIN award_videogame
ON videogames.id = award_videogame.videogame_id
JOIN awards
ON award_videogame.award_id = awards.id
WHERE YEAR(videogames.release_date) = 2018 AND awards.id = 1

9. Selezionare i giocatori che hanno giocato al gioco piÃ¹ atteso del 2018 in un torneo del 2019 (3306)
SELECT DISTINCT players.*
FROM videogames.players
JOIN player_tournament
ON players.id = player_tournament.player_id
JOIN tournaments
ON player_tournament.tournament_id = tournaments.id
JOIN tournament_videogame
ON tournaments.id = tournament_videogame.tournament_id
JOIN videogames
ON tournament_videogame.videogame_id = videogame_id
JOIN award_videogame
ON videogames.id = award_videogame.videogame_id
JOIN awards
ON award_videogame.award_id = awards.id
WHERE awards.id = 5 AND award_videogame.year=2018 AND tournaments.year = 2019