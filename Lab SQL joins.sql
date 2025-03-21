USE sakila;
SELECT * FROM film;
SELECT * FROM film_category;
SELECT * FROM store;
SELECT * FROM address;
SELECT * FROM city;
SELECT * FROM payment;
SELECT * FROM rental;
SELECT * FROM inventory;

-- List the number of films per category.

SELECT c.category_id, c.name AS category_name, COUNT(fc.film_id) AS film_count
FROM category c
INNER JOIN film_category fc ON c.category_id = fc.category_id
GROUP BY c.category_id, c.name
ORDER BY film_count DESC;

-- Retrieve the store ID, city, and country for each store.
SELECT s.store_id, ci.city, co.country AS country
FROM store s
JOIN address a ON s.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id;

-- Calculate the total revenue generated by each store in dollars.
SELECT s.store_id, SUM(py.amount) AS total_revenue
FROM store s
JOIN customer c ON s.store_id = c.store_id
JOIN payment py ON c.customer_id = py.customer_id
GROUP BY store_id;

-- Determine the average running time of films for each category.
SELECT c.name AS film_category, ROUND(AVG(f.length), 2) AS avg_duration_film_min
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name
ORDER BY avg_duration_film_min DESC;

-- Identify the film categories with the longest average running time
SELECT c.name AS film_category, ROUND(AVG(f.length), 2) AS avg_duration_film_min
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name
ORDER BY avg_duration_film_min DESC
LIMIT 1;

-- Display the top 10 most frequently rented movies in descending order.
SELECT f.title, COUNT(r.inventory_id) AS rental_counts
FROM film f
JOIN inventory i ON i.film_id = f.film_id
JOIN rental r ON r.inventory_id = i.inventory_id
GROUP BY f.title
ORDER BY rental_counts DESC 
LIMIT 10;

-- Determine if "Academy Dinosaur" can be rented from Store 1.
SELECT f.title, s.store_id
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN store s ON i.store_id = s.store_id
WHERE f.title = "Academy Dinosaur" AND s.store_id = "1";

-- Provide a list of all distinct film titles, along with their availability status in the inventory.
-- Include a column indicating whether each title is 'Available' or 'NOT available.'
-- Note that there are 42 titles that are not in the inventory, and this information can be obtained using a CASE statement combined with IFNULL."

SELECT
	f.title,
	CASE 
		WHEN COUNT(i.inventory_id) > 0 THEN "Available"
        ELSE "Not Available"
	END AS availability_status
FROM film f
LEFT JOIN inventory i ON f.film_id = i.film_id
GROUP BY f.title;
