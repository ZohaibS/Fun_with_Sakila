USE sakila;

-- 1a
SELECT first_name, last_name
FROM actor;

-- 1b
ALTER TABLE actor ADD COLUMN `Actor Name` VARCHAR(150);
UPDATE actor SET `Actor Name` = CONCAT(UCASE(first_name), ' ', UCASE(last_name));

SELECT `Actor Name`
FROM actor;

-- 2a
SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name = 'joe';

-- 2b
SELECT `Actor Name`
FROM actor
WHERE LOCATE('gen', last_name)>0;

-- 2c
SELECT `Actor Name`
FROM actor
WHERE locate('li', last_name)>0
ORDER BY last_name, first_name;

-- 2d
SELECT country_id, country
FROM country
WHERE country 
IN ('Afghanistan', 'Bangladesh', 'China');

-- 3a
ALTER TABLE actor ADD COLUMN description LONGBLOB;

-- 3b
ALTER TABLE actor DROP COLUMN description;

-- 4a
SELECT last_name ,COUNT(*)
FROM actor      
GROUP BY last_name;

-- 4b

-- Interesting Result: we obtain this in the form of a Boolean.
-- SELECT last_name, COUNT(*) > 1 
-- FROM actor      
-- GROUP BY last_name;

SELECT last_name, first_name, COUNT(*) 
FROM actor 
GROUP BY last_name 
HAVING COUNT(*) >=2;

-- 4c
SELECT *
FROM actor 
WHERE first_name = 'Harpo' AND last_name='Williams';

UPDATE actor 
SET `Actor Name` = 'HARPO WILLIAMS'
WHERE `Actor Name` = 'GROUCH WILLIAMS';

UPDATE actor
SET first_name='Harpo', last_name = 'Williams', `Actor Name` = 'HARPO WILLIAMS' 
WHERE first_name = 'Groucho' AND last_name='Williams';

-- 4d
UPDATE actor
SET first_name='Groucho', `Actor Name` = 'GROUCHO WILLIAMS' 
WHERE first_name = 'HARPO' AND last_name='WILLIAMS';

-- 5a
 CREATE TABLE address (
   address_id smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT,
   address varchar(50) NOT NULL,
   address2 varchar(50) DEFAULT NULL,
   district varchar(20) NOT NULL,
   city_id smallint(5) unsigned NOT NULL,
   postal_code varchar(10) DEFAULT NULL,
   phone varchar(20) NOT NULL,
   location geometry NOT NULL,
   last_update timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
   PRIMARY KEY (`address_id`),
   KEY `idx_fk_city_id` (`city_id`),
   SPATIAL KEY `idx_location` (`location`),
   CONSTRAINT `fk_address_city` FOREIGN KEY (`city_id`) REFERENCES `city` (`city_id`) ON UPDATE CASCADE
 ) ENGINE=InnoDB AUTO_INCREMENT=606 DEFAULT CHARSET=utf8

-- 6a
SELECT * FROM staff;
SELECT * FROM address;
SELECT s.first_name AS 'First Name', s.last_name AS 'Last Name', a.address AS 'Address' 
FROM staff s
JOIN address a 
ON s.staff_id= a.address_id;

-- 6b
SELECT * FROM payment WHERE payment_date LIKE '%2005-08%';
SELECT sum(p.amount) AS 'Total Amount', 
	s.first_name AS 'First Name', s.last_name AS 'Last Name', p.payment_date AS 'Payment Date' 
	FROM staff s 
    INNER JOIN payment p 
    ON s.staff_id= p.staff_id 
    WHERE p.payment_date 
    LIKE '%2005-08%'
    GROUP BY first_name;

-- 6c
SELECT * 
FROM film;

SELECT * 
FROM actor;

SELECT f.title, COUNT(a.`Actor Name`) 
AS 'Number of Actors in Film' 
FROM film f
JOIN actor a 
ON f.film_id= a.actor_id 
GROUP BY title;

-- 6d    
SELECT title, COUNT(title) 
AS "Copies Count" 
FROM film
JOIN inventory 
ON film.film_id = inventory.film_id
WHERE title = "Hunchback Impossible";

-- 6e
SELECT * 
FROM payment;
SELECT * 
FROM customer;
SELECT c.first_name, c.last_name, SUM(p.amount) AS 'Total Amount Paid' 
FROM payment p
LEFT JOIN customer c 
ON c.customer_id=p.customer_id
GROUP BY last_name ASC 
HAVING SUM(p.amount);

-- 7a
-- Testing Nesting
SELECT language_id 
FROM `language` 
WHERE language_id=1;

SELECT title 
FROM film 
WHERE ( title LIKE 'K%' or title LIKE 'Q%') 
AND 
(SELECT language_id 
FROM `language` 
WHERE language_id=1);


-- 7b
SELECT * 
FROM film 
WHERE title='Alone Trip';

SELECT first_name, last_name 
FROM actor
WHERE actor_id 
IN 
(SELECT actor_id 
FROM film_actor 
WHERE film_id 
IN (select film_id 
FROM film 
WHERE title = "Alone Trip"));
 
-- 7canada
SELECT c.email, c.first_name, c.last_name, cy.country 
FROM customer c
JOIN address ad 
ON c.address_id=ad.address_id
JOIN city ct 
ON ad.city_id = ct.city_id
JOIN country cy 
ON ct.country_id = cy.country_id
WHERE country= 'Canada';


-- 7d
SELECT f.film_id 
AS 'Film Id', f.title 
AS 'Film Title', a.`name` 
AS 'Film Category', a.category_id 
AS 'Family Category ID'
FROM film f
JOIN film_category c 
ON f.film_id = c.film_id
JOIN category a 
ON a.category_id = c.category_id
WHERE a.`name` ='Family';

-- 7e
SELECT title, count(rental_id) as "Rental Count" 
FROM rental 
JOIN inventory 
ON (rental.inventory_id = inventory.inventory_id)
JOIN film 
ON (inventory.film_id = film.film_id)
GROUP BY film.title
ORDER BY COUNT(rental_id) DESC;

-- 7f
SELECT staff.store_id 
AS 'Store', (SELECT SUM(payment.amount) 
FROM payment 
WHERE payment.staff_id = staff.staff_id) 
AS 'Total Sales per Store'
FROM staff
GROUP BY staff.store_id;

-- 7g
SELECT * FROM store;
SELECT * FROM city;
SELECT * FROM address;
SELECT * FROM country;

SELECT st.store_id, ct.city, cy.country 
FROM city ct
JOIN country cy 
ON ct.country_id = cy.country_id
JOIN address ad 
ON ct.city_id = ad.city_id
JOIN store st 
ON ad.city_id = st.address_id
GROUP BY st.store_id;
-- What diversity for a company with only two locations.

-- 7h
SELECT `name`, SUM(amount) 
FROM category 
JOIN film_category 
ON category.category_id = film_category.category_id
JOIN inventory 
ON film_category.film_id = inventory.film_id
JOIN rental 
ON inventory.inventory_id = rental.inventory_id
JOIN payment 
ON rental.rental_id = payment.rental_id
GROUP BY `name`
ORDER BY SUM(amount) DESC LIMIT 5;

-- 8a
CREATE VIEW `Top 5 Genres by Gross Revenue` 
AS SELECT `name`, SUM(amount) 
FROM category 
JOIN film_category 
ON category.category_id = film_category.category_id
JOIN inventory 
ON film_category.film_id = inventory.film_id
JOIN rental 
ON inventory.inventory_id = rental.inventory_id
JOIN payment 
ON rental.rental_id = payment.rental_id
GROUP BY `name`
ORDER BY SUM(amount) DESC LIMIT 5;

SELECT * FROM `Top 5 Genres by Gross Revenue`;
 
-- 8b
SELECT * FROM `Top 5 Genres by Gross Revenue`;

-- 8c
DROP VIEW `Top 5 Genres by Gross Revenue`;



