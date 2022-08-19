--'master list' TOP 10 based on avg rating round to nearest .5

SELECT
    a.name,
    ROUND(ROUND(AVG(a.rating + p.rating)) / 2, 1) AS avg_rating,
    ROUND(((a.price + REPLACE(p.price, '$', '')::NUMERIC) / 2),2) AS avg_price,
    UPPER(CONCAT(primary_genre, '/', category)) AS app_category
FROM app_store_apps AS a
INNER JOIN play_store_apps AS p
    ON a.name = p.name
GROUP BY a.name, avg_price, app_category
HAVING ROUND(((a.price + REPLACE(p.price, '$', '')::NUMERIC) / 2),2) <= 1
ORDER BY avg_rating DESC;


/*SELECT *
   
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
FROM app_store_apps;*/

SELECT
    a.name,
    ROUND(AVG(a.rating + p.rating) ,2) AS avg_rating,
    ROUND(((a.price + REPLACE(p.price, '$', '')::NUMERIC) / 2),2) AS avg_price
    --primary_genre AS app_category
FROM app_store_apps AS a
INNER JOIN play_store_apps AS p
    ON a.name = p.name
GROUP BY a.name, avg_price
HAVING ROUND(((a.price + REPLACE(p.price, '$', '')::NUMERIC) / 2),2) <= 1
ORDER BY avg_rating DESC
LIMIT 12;


