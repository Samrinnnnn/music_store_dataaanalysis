/*1 List the top 10 most expensive tracks*/
SELECT 
    t.name AS track_name,
    ar.name AS artist,
    al.title AS album,
    t.unit_price
FROM track t
JOIN album al ON t.album_id = al.album_id
JOIN artist ar ON al.artist_id = ar.artist_id
ORDER BY t.unit_price DESC
LIMIT 10;
/*2 Total number of tracks per genre (most to least)*/
SELECT 
    g.name AS genre,
    COUNT(t.track_id) AS track_count
FROM genre g
JOIN track t ON g.genre_id = t.genre_id
GROUP BY g.name
ORDER BY track_count DESC;
/*3 */
SELECT 
    first_name || ' ' || last_name AS full_name,
    city,
    email
FROM customer
WHERE country = 'Brazil'
ORDER BY last_name, first_name;
/*4 Employee with most customer*/
SELECT
    e.employee_id,
    e.first_name || ' ' || e.last_name AS employee_name,
    COUNT(c.customer_id) AS total_customers
FROM employee e
JOIN customer c
    ON e.employee_id::INT = c.support_rep_id
GROUP BY
    e.employee_id,
    employee_name
ORDER BY total_customers DESC
LIMIT 1;





