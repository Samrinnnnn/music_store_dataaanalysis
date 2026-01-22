/*5 Employee with the Highest Total Sales Revenue */
SELECT 
    e.employee_id,
    e.first_name || ' ' || e.last_name AS employee_name,
    SUM(i.total) AS total_revenue
FROM public.employee e
JOIN public.customer c
    ON e.employee_id::int = c.support_rep_id
JOIN public.invoice i
    ON c.customer_id = i.customer_id
GROUP BY e.employee_id, employee_name
ORDER BY total_revenue DESC
LIMIT 1;
/*6 Top 5 Customers by Total Spending*/
SELECT 
    c.customer_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    SUM(i.total) AS total_spent
FROM public.customer c
JOIN public.invoice i
    ON c.customer_id = i.customer_id
GROUP BY c.customer_id, customer_name
ORDER BY total_spent DESC
LIMIT 5;
/*7 Most Popular Genre by Number of Purchases*/
SELECT 
    g.name AS genre_name,
    COUNT(il.invoice_line_id) AS total_purchases
FROM public.genre g
JOIN public.track t
    ON g.genre_id = t.genre_id
JOIN public.invoice_line il
    ON t.track_id = il.track_id
GROUP BY g.genre_id, genre_name
ORDER BY total_purchases DESC
LIMIT 1;


