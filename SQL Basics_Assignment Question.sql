use mavenmovies;
-- 1-Identify the primary keys and foreign keys in maven movies db. Discuss the differences

--  2- List all details of actors
select * from actor;
--  3 -List all customer information from DB.
select * from customer;
--  4 -List different countries.
select * from country;
select distinct country from country;
--  5 -Display all active customers.
select * from customer
where active=1;
--  6 -List of all rental IDs for customer with ID 1.
select * from rental;
SELECT rental_id 
FROM rental 
WHERE customer_id = 1;
--  7 - Display all the films whose rental duration is greater than 5 .
select title,rental_duration from film
where rental_duration>5;
--  8 - List the total number of films whose replacement cost is greater than $15 and less than $20.
select title,replacement_cost from film
where replacement_cost>15 and replacement_cost<20;
--  9 - Display the count of unique first names of actors.
select distinct first_name from actor;
--  10- Display the first 10 records from the customer table .
select * from customer
limit 10;
--  11 - Display the first 3 records from the customer table whose first name starts with ‘b’.
select * from customer
where first_name like 'b%'
limit 3;
--  12 -Display the names of the first 5 movies which are rated as ‘G’.
select title,rating from film
order by rating
limit 5;
--  13-Find all customers whose first name starts with "a".
select first_name from customer
where first_name like "a%";
--  14- Find all customers whose first name ends with "a".
select first_name from customer
where first_name like "%a";
--  15- Display the list of first 4 cities which start and end with ‘a’ .
select * from city
where city like "a%a"
limit 4;
--  16- Find all customers whose first name have "NI" in any position.
select first_name from customer
where first_name like "%NI%";
--  17- Find all customers whose first name have "r" in the second position .
SELECT first_name 
FROM customer 
WHERE first_name LIKE '_r%';
--  18 - Find all customers whose first name starts with "a" and are at least 5 characters in length.
SELECT *
FROM customer
WHERE first_name LIKE 'a%' AND LENGTH(first_name) >= 5;
--  19- Find all customers whose first name starts with "a" and ends with "o".
SELECT *
FROM customer
WHERE first_name LIKE 'a%o';
--  20 - Get the films with pg and pg-13 rating using IN operator.
SELECT *
FROM film
WHERE rating IN ('PG', 'PG-13');
--  21 - Get the films with length between 50 to 100 using between operator.
SELECT *
FROM film
WHERE length BETWEEN 50 AND 100;
--  22 - Get the top 50 actors using limit operator.
select first_name from actor
limit 50;
--  23 - Get the distinct film ids from inventory table
select distinct film_id from inventory;

-- Functions-- 
-- Basic Aggregate Functions--

-- Question 1:
--  Retrieve the total number of rentals made in the Sakila database.
--  Hint: Use the COUNT() function.
SELECT COUNT(*) AS total_rentals 
FROM rental;
--  Question 2:
--  Find the average rental duration (in days) of movies rented from the Sakila database.
--  Hint: Utilize the AVG() function.
SELECT AVG(rental_duration) AS avg_rental_duration 
FROM film;

-- String Functions:
--  Question 3:
--  Display the first name and last name of customers in uppercase.
--  Hint: Use the UPPER () function.
SELECT UPPER(first_name) AS first_name_upper, 
       UPPER(last_name) AS last_name_upper 
FROM customer;
--  Question 4:
--  Extract the month from the rental date and display it alongside the rental ID.
--  Hint: Employ the MONTH() function
SELECT rental_id, 
MONTH(rental_date) AS rental_month 
FROM rental;

--  Question 5:
--  Retrieve the count of rentals for each customer (display customer ID and the count of rentals).
--  Hint: Use COUNT () in conjunction with GROUP BY.

SELECT customer_id, COUNT(*) AS rental_count
FROM rental
GROUP BY customer_id;

-- Question 6:
--  Find the total revenue generated by each store.
--  Hint: Combine SUM() and GROUP BY.
SELECT s.store_id, SUM(p.amount) AS total_revenue
FROM payment p
JOIN staff s ON p.staff_id = s.staff_id
GROUP BY s.store_id;

-- Question 7:
--  Determine the total number of rentals for each category of movies.
--  Hint: JOIN film_category, film, and rental tables, then use cOUNT () and GROUP BY.
SELECT c.name AS category_name, COUNT(r.rental_id) AS total_rentals
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN film f ON fc.film_id = f.film_id
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY c.name;
-- Question 8:
--  Find the average rental rate of movies in each language.
--  Hint: JOIN film and language tables, then use AVG () and GROUP BY.
SELECT l.name AS language, AVG(f.rental_rate) AS average_rental_rate
FROM film f
JOIN language l ON f.language_id = l.language_id
GROUP BY l.name;

-- Joins
--  Questions 9 -
--  Display the title of the movie, customer s first name, and last name who rented it.
--  Hint: Use JOIN between the film, inventory, rental, and customer tables.
SELECT f.title AS movie_title, c.first_name, c.last_name
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN customer c ON r.customer_id = c.customer_id;


--  Question 10:
--  Retrieve the names of all actors who have appeared in the film "Gone with the Wind."
--  Hint: Use JOIN between the film actor, film, and actor tables.

SELECT a.first_name, a.last_name
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
WHERE f.title = 'Gone with the Wind';

--  Question 11:
--  Retrieve the customer names along with the total amount they've spent on rentals.
--  Hint: JOIN customer, payment, and rental tables, then use SUM() and GROUP BY.
SELECT c.first_name, c.last_name, SUM(p.amount) AS total_spent
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;

--  Question 12:
--  List the titles of movies rented by each customer in a particular city (e.g., 'London').
--  Hint: JOIN customer, address, city, rental, inventory, and film tables, then use GROUP BY.
SELECT c.first_name, c.last_name, ci.city, f.title
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
WHERE ci.city = 'London'
ORDER BY c.last_name, f.title;

-- Advanced Joins and GROUP BY:
--  Question 13:
--  Display the top 5 rented movies along with the number of times they've been rented.
--  Hint: JOIN film, inventory, and rental tables, then use COUNT () and GROUP BY, and limit the results.
SELECT f.title, COUNT(r.rental_id) AS rental_count
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.title
ORDER BY rental_count DESC
LIMIT 5;

--  Question 14:
--  Determine the customers who have rented movies from both stores (store ID 1 and store ID 2).
--  Hint: Use JOINS with rental, inventory, and customer tables and consider COUNT() and GROUP BY.
SELECT customer_id
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
GROUP BY r.customer_id
HAVING COUNT(DISTINCT i.store_id) = 2;

-- Windows Function:
--  1. Rank the customers based on the total amount they've spent on rentals.
SELECT 
    customer_id, 
    SUM(amount) AS total_spent,
    RANK() OVER (ORDER BY SUM(amount) DESC) AS spending_rank
FROM payment
GROUP BY customer_id;

--  2. Calculate the cumulative revenue generated by each film over time.
SELECT 
    f.title,
    r.rental_date,
    SUM(p.amount) OVER (PARTITION BY f.film_id ORDER BY r.rental_date) AS cumulative_revenue
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.rental_id = p.rental_id;

--  3. Determine the average rental duration for each film, considering films with similar lengths.
SELECT 
    f.film_id,
    f.title,
    f.length,
    AVG(DATEDIFF(r.return_date, r.rental_date)) AS avg_rental_duration,
    AVG(AVG(DATEDIFF(r.return_date, r.rental_date))) 
        OVER (PARTITION BY f.length) AS avg_duration_by_length_group
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.film_id, f.title, f.length;

--  4. Identify the top 3 films in each category based on their rental counts.
SELECT *
FROM (
    SELECT 
        c.name AS category,
        f.title,
        COUNT(r.rental_id) AS rental_count,
        RANK() OVER (PARTITION BY c.category_id ORDER BY COUNT(r.rental_id) DESC) AS rank_in_category
    FROM category c
    JOIN film_category fc ON c.category_id = fc.category_id
    JOIN film f ON fc.film_id = f.film_id
    JOIN inventory i ON f.film_id = i.film_id
    JOIN rental r ON i.inventory_id = r.inventory_id
    GROUP BY c.name, c.category_id, f.title
) ranked
WHERE rank_in_category <= 3;

--  5. Calculate the difference in rental counts between each customer's total rentals and the average rentals
--  across all customers.
SELECT 
    customer_id,
    COUNT(*) AS total_rentals,
    COUNT(*) - AVG(COUNT(*)) OVER () AS rental_diff_from_avg
FROM rental
GROUP BY customer_id;

--  6. Find the monthly revenue trend for the entire rental store over time.
SELECT 
    DATE_FORMAT(payment_date, '%Y-%m') AS month,
    SUM(amount) AS total_revenue
FROM payment
GROUP BY DATE_FORMAT(payment_date, '%Y-%m')
ORDER BY month;

--  7. Identify the customers whose total spending on rentals falls within the top 20% of all customers.
WITH customer_spending AS (
    SELECT customer_id, SUM(amount) AS total_spent
    FROM payment
    GROUP BY customer_id
),
ranked_customers AS (
    SELECT *,
           NTILE(5) OVER (ORDER BY total_spent DESC) AS spending_percentile
    FROM customer_spending
)
SELECT customer_id, total_spent
FROM ranked_customers
WHERE spending_percentile = 1;

--  8. Calculate the running total of rentals per category, ordered by rental count.
WITH category_rentals AS (
    SELECT 
        c.name AS category,
        COUNT(r.rental_id) AS rental_count
    FROM category c
    JOIN film_category fc ON c.category_id = fc.category_id
    JOIN film f ON fc.film_id = f.film_id
    JOIN inventory i ON f.film_id = i.film_id
    JOIN rental r ON i.inventory_id = r.inventory_id
    GROUP BY c.name
)
SELECT 
    category,
    rental_count,
    SUM(rental_count) OVER (ORDER BY rental_count DESC) AS running_total
FROM category_rentals;

--  9. Find the films that have been rented less than the average rental count for their respective categories.
WITH film_rentals AS (
    SELECT 
        c.category_id,
        f.film_id,
        f.title,
        COUNT(r.rental_id) AS rental_count
    FROM category c
    JOIN film_category fc ON c.category_id = fc.category_id
    JOIN film f ON fc.film_id = f.film_id
    JOIN inventory i ON f.film_id = i.film_id
    JOIN rental r ON i.inventory_id = r.inventory_id
    GROUP BY c.category_id, f.film_id, f.title
),
category_avg AS (
    SELECT 
        category_id,
        AVG(rental_count) AS avg_rentals
    FROM film_rentals
    GROUP BY category_id
)
SELECT fr.title, fr.rental_count, ca.avg_rentals
FROM film_rentals fr
JOIN category_avg ca ON fr.category_id = ca.category_id
WHERE fr.rental_count < ca.avg_rentals;

--  10. Identify the top 5 months with the highest revenue and display the revenue generated in each month.
SELECT *
FROM (
    SELECT 
        DATE_FORMAT(payment_date, '%Y-%m') AS month,
        SUM(amount) AS monthly_revenue,
        RANK() OVER (ORDER BY SUM(amount) DESC) AS revenue_rank
    FROM payment
    GROUP BY DATE_FORMAT(payment_date, '%Y-%m')
) ranked_months
WHERE revenue_rank <= 5;



-- Normalisation & CTE
--  1. First Normal Form (1NF):
--                a. Identify a table in the Sakila database that violates 1NF. Explain how you
--                would normalize it to achieve 1NF.


--  2. Second Normal Form (2NF):
--                a. Choose a table in Sakila and describe how you would determine whether it is in 2NF. 
--             If it violates 2NF, explain the steps to normalize it.
--  3. Third Normal Form (3NF):
--                a. Identify a table in Sakila that violates 3NF. Describe the transitive dependencies 
--                present and outline the steps to normalize the table to 3NF.
Issue: customer_city depends on customer_name, which depends on customer_id → transitive dependency.
Normalization:
Keep rental_id and customer_id in rental.
Move customer_name, customer_city to a customer table (already done in Sakila).

--  4. Normalization Process:
--                a. Take a specific table in Sakila and guide through the process of normalizing it from the initial  
--             unnormalized form up to at least 2NF.
Imagine a raw table:
Unnormalized Table: rental_details
rental_id	customer_id	name	film_titles
1	101	John Doe	"Matrix, Inception"
1NF: Split film_titles into separate rows.
2NF: Separate into two tables:
rental: rental_id, customer_id
rental_film: rental_id, film_title
--  5. CTE Basics:
--                 a. Write a query using a CTE to retrieve the distinct list of actor names and the number of films they 
--                 have acted in from the actor and film_actor tables.
WITH actor_film_count AS (
    SELECT actor_id, COUNT(film_id) AS film_count
    FROM film_actor
    GROUP BY actor_id
)
SELECT a.first_name, a.last_name, afc.film_count
FROM actor a
JOIN actor_film_count afc ON a.actor_id = afc.actor_id;

--  6. CTE with Joins:
--                 a. Create a CTE that combines information from the film and language tables to display the film title, 
--                  language name, and rental rate.
WITH film_lang AS (
    SELECT f.film_id, f.title, f.rental_rate, l.name AS language
    FROM film f
    JOIN language l ON f.language_id = l.language_id
)
SELECT * FROM film_lang;

--  7.CTE for Aggregation:
--                a. Write a query using a CTE to find the total revenue generated by each customer (sum of payments) 
--                 from the customer and payment tables.
WITH customer_revenue AS (
    SELECT customer_id, SUM(amount) AS total_revenue
    FROM payment
    GROUP BY customer_id
)
SELECT c.first_name, c.last_name, cr.total_revenue
FROM customer c
JOIN customer_revenue cr ON c.customer_id = cr.customer_id;

--  8.CTE with Window Functions:
--                a. Utilize a CTE with a window function to rank films based on their rental duration from the film table.

WITH film_ranks AS (
    SELECT 
        film_id, 
        title, 
        rental_duration,
        RANK() OVER (ORDER BY rental_duration DESC) AS duration_rank
    FROM film
)
SELECT * FROM film_ranks;

--  9.CTE and Filtering:
--                a. Create a CTE to list customers who have made more than two rentals, and then join this CTE with the 
--             customer table to retrieve additional customer details
WITH frequent_customers AS (
    SELECT customer_id, COUNT(*) AS rental_count
    FROM rental
    GROUP BY customer_id
    HAVING COUNT(*) > 2
)
SELECT c.first_name, c.last_name, fc.rental_count
FROM customer c
JOIN frequent_customers fc ON c.customer_id = fc.customer_id;
