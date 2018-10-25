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
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

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

-- Lets use it to cheat our way through this.
SELECT last_name, COUNT(*) AS C_1, COUNT(*) > 1 AS C_2
FROM actor      
DROP ROW if C_2 = 0
GROUP BY last_name;




