/*============================================================
 * NAME: GREYSON KNIPPEL
 * ASSIGN: HW-4
 * COURSE: CPSC 321, Fall 2026
 * DESC: queries 9-12 on the cpsc321_db movie rental database.
 *============================================================*/


-- question 9: unreturned rentals of G-rated films whose copy belongs to
-- store 1
SELECT c.first_name, c.last_name, c.email, f.title, r.rental_date
FROM rental AS r
    JOIN inventory AS i ON r.inventory_id = i.inventory_id
    JOIN film AS f ON i.film_id = f.film_id
    JOIN customer AS c ON r.customer_id = c.customer_id
WHERE f.rating = 'G'
    AND i.store_id = 1
    AND r.return_date IS NULL
ORDER BY c.last_name, c.first_name;

-- question 10: customer 43's rentals returned more than 7 days after
-- the rental date, or not returned yet
SELECT f.title, r.rental_date, r.return_date
FROM rental AS r
    JOIN inventory AS i ON r.inventory_id = i.inventory_id
    JOIN film AS f ON i.film_id = f.film_id
WHERE r.customer_id = 43
    AND (r.return_date > r.rental_date + INTERVAL '7 days'
        OR r.return_date IS NULL)
ORDER BY r.rental_date;

-- question 11: G-rated films with no copies in either store's inventory
-- using a LEFT JOIN where no matching inventory row means NULL
SELECT f.film_id, f.title
FROM film AS f
    LEFT JOIN inventory AS i ON f.film_id = i.film_id
WHERE f.rating = 'G'
    AND i.inventory_id IS NULL
ORDER BY f.title;


-- question 12: actors in a horror film AND a sci fi film, both at least
-- 170 minutes long, and INTERSECT keeps actors found in both halves
SELECT a.actor_id, a.first_name, a.last_name
FROM actor AS a
    JOIN film_actor AS fa ON a.actor_id = fa.actor_id
    JOIN film AS f ON fa.film_id = f.film_id
    JOIN film_category AS fc ON f.film_id = fc.film_id
    JOIN category AS c ON fc.category_id = c.category_id
WHERE c.name = 'Horror'
    AND f.length >= 170
INTERSECT
SELECT a.actor_id, a.first_name, a.last_name
FROM actor AS a
    JOIN film_actor AS fa ON a.actor_id = fa.actor_id
    JOIN film AS f ON fa.film_id = f.film_id
    JOIN film_category AS fc ON f.film_id = fc.film_id
    JOIN category AS c ON fc.category_id = c.category_id
WHERE c.name = 'Sci-Fi'
    AND f.length >= 170
ORDER BY last_name, first_name;
