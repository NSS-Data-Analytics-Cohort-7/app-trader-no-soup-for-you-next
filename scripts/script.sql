--'master list' TOP 10 based on avg rating

SELECT
    a.name,
    ROUND(((a.rating + p.rating) / 2) ,2) AS avg_rating,
    ROUND(((a.price + REPLACE(p.price, '$', '')::NUMERIC) / 2),2) AS avg_price,
    UPPER(CONCAT(primary_genre, '/', category)) AS app_category
FROM app_store_apps AS a
INNER JOIN play_store_apps AS p
    ON a.name = p.name
GROUP BY a.name, avg_rating, avg_price, app_category
HAVING ROUND(((a.price + REPLACE(p.price, '$', '')::NUMERIC) / 2),2) <= 1
ORDER BY avg_rating DESC
LIMIT 12;


SELECT *
   
    --ROUND(((a.rating + p.rating) / 2) ,2) AS avg_rating,
    --ROUND(((a.price + REPLACE(p.price, '$', '')::NUMERIC) / 2),2) AS avg_price,
   -- SUM((CAST(a.review_count AS INT) + p.review_count)) AS total_review_count
FROM app_store_apps AS a
INNER JOIN play_store_apps AS p
    ON a.name = p.name;
    
 
SELECT *
   
FROM play_store_apps
WHERE name LIKE 'ROBLOX';

SELECT
    DISTINCT primary_genre
FROM app_store_apps;
    


