

SELECT a.name,
       ROUND(((a.rating + p.rating) / 2) ,2) AS avg_rating,
       ROUND(((a.price + REPLACE(p.price, '$', '')::NUMERIC) / 2),2) AS avg_price,
       SUM((CAST(a.review_count AS INT) + p.review_count)) AS total_review_count
FROM app_store_apps AS a
INNER JOIN play_store_apps AS p
    ON a.name = p.name
GROUP BY a.name, avg_rating, avg_price
HAVING ROUND(((a.price + REPLACE(p.price, '$', '')::NUMERIC) / 2),2) <= 1
    AND SUM((CAST(a.review_count AS INT) + p.review_count)) > 2000000
ORDER BY avg_rating DESC
LIMIT 10;


