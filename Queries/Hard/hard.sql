/* 8 Top Employee per Country by Total Sales*/
WITH employee_sales AS (
    SELECT 
        e.employee_id,
        e.first_name || ' ' || e.last_name AS employee_name,
        c.country,
        SUM(i.total) AS total_revenue
    FROM public.employee e
    JOIN public.customer c
        ON e.employee_id::int = c.support_rep_id
    JOIN public.invoice i
        ON c.customer_id = i.customer_id
    GROUP BY e.employee_id, employee_name, c.country
)
SELECT country, employee_id, employee_name, total_revenue
FROM (
    SELECT *,
           RANK() OVER (PARTITION BY country ORDER BY total_revenue DESC) AS rnk
    FROM employee_sales
) ranked
WHERE rnk = 1;
/* 9 Top 3 Tracks by Revenue in Each Genre */
SELECT genre_name, track_name, total_revenue
FROM (
    SELECT 
        g.name AS genre_name,
        t.name AS track_name,
        SUM(il.unit_price * il.quantity) AS total_revenue,
        ROW_NUMBER() OVER (PARTITION BY g.genre_id ORDER BY SUM(il.unit_price * il.quantity) DESC) AS rn
    FROM public.genre g
    JOIN public.track t
        ON g.genre_id = t.genre_id
    JOIN public.invoice_line il
        ON t.track_id = il.track_id
    GROUP BY g.genre_id, g.name, t.track_id, t.name
) ranked
WHERE rn <= 3
ORDER BY genre_name, total_revenue DESC;

/* 10 Customers Who Purchased Every Track of a Specific Genre*/
WITH rock_tracks AS (
    SELECT track_id
    FROM public.track t
    JOIN public.genre g ON t.genre_id = g.genre_id
    WHERE g.name = 'Rock'
),
customer_rock AS (
    SELECT c.customer_id, COUNT(DISTINCT il.track_id) AS purchased_tracks
    FROM public.customer c
    JOIN public.invoice i ON c.customer_id = i.customer_id
    JOIN public.invoice_line il ON i.invoice_id = il.invoice_id
    WHERE il.track_id IN (SELECT track_id FROM rock_tracks)
    GROUP BY c.customer_id
)
SELECT c.customer_id, c.first_name || ' ' || c.last_name AS customer_name
FROM customer_rock cr
JOIN public.customer c ON cr.customer_id = c.customer_id
WHERE purchased_tracks = (SELECT COUNT(*) FROM rock_tracks);

/*11 Monthly Sales Trend for Each Employee*/
SELECT 
    e.employee_id,
    e.first_name || ' ' || e.last_name AS employee_name,
    DATE_TRUNC('month', i.invoice_date) AS month,
    SUM(i.total) AS monthly_sales
FROM public.employee e
JOIN public.customer c
    ON e.employee_id::int = c.support_rep_id
JOIN public.invoice i
    ON c.customer_id = i.customer_id
WHERE i.invoice_date >= '2020-01-01' AND i.invoice_date < '2021-01-01'
GROUP BY e.employee_id, employee_name, month
ORDER BY e.employee_id, month;

/*12 Track with the Highest Single Invoice Sale*/
SELECT 
    t.track_id,
    t.name AS track_name,
    il.invoice_id,
    il.unit_price * il.quantity AS line_total
FROM public.invoice_line il
JOIN public.track t ON il.track_id = t.track_id
ORDER BY line_total DESC
LIMIT 1;
--The END--