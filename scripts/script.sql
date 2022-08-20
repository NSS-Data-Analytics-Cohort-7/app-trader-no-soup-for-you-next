--'master list' TOP 10 based on avg rating round to nearest .5
WITH first_cost AS(
                    SELECT a.name,
                        CASE WHEN ROUND(AVG((a.price + replace(p.price, '$','')::numeric)/2),2)<=1 THEN 10000
                        WHEN ROUND(AVG((a.price + replace(p.price, '$', '')::numeric)/2),2)>1 THEN ROUND(AVG((a.price + replace(p.price, '$',                                                                   '')::numeric)/2),2)*10000
                        END AS initial_cost
                    FROM app_store_apps AS a
                    INNER JOIN play_store_apps AS p
                    ON a.name = p.name
                    GROUP BY a.name
                   )

SELECT
    a.name,
    ROUND(ROUND(AVG(a.rating + p.rating)) / 2, 1) AS avg_rating,
    ROUND(((a.price + REPLACE(p.price, '$', '')::NUMERIC) / 2),2) AS avg_price,
    UPPER(CONCAT(primary_genre, '/', category)) AS app_category,
    UPPER(CONCAT(a.content_rating, '/', p.content_rating)) AS content,
    (((ROUND(ROUND(AVG(a.rating+p.rating)) / 2, 1)*2)+1) * 48000) - fc.initial_cost AS total_profit
FROM app_store_apps AS a
INNER JOIN play_store_apps AS p
    ON a.name = p.name
FULL JOIN first_cost AS fc
    ON a.name = fc.name
GROUP BY a.name, avg_price, app_category, content, fc.initial_cost
HAVING ROUND(((a.price + REPLACE(p.price, '$', '')::NUMERIC) / 2),2) <= 1
ORDER BY avg_rating DESC
LIMIT 10;


--

WITH first_cost AS(
                    SELECT a.name,
                        CASE WHEN ROUND(AVG((a.price + replace(p.price, '$','')::numeric)/2),2)<=1 THEN 10000
                        WHEN ROUND(AVG((a.price + replace(p.price, '$', '')::numeric)/2),2)>1 THEN ROUND(AVG((a.price + replace(p.price, '$',                                                                   '')::numeric)/2),2)*10000
                        END AS initial_cost
                    FROM app_store_apps AS a
                    INNER JOIN play_store_apps AS p
                    ON a.name = p.name
                    GROUP BY a.name
                   )

SELECT
    a.name,
    ROUND(ROUND(AVG(a.rating + p.rating)) / 2, 1) AS avg_rating,
    ROUND(((a.price + REPLACE(p.price, '$', '')::NUMERIC) / 2),2) AS avg_price,
    UPPER(CONCAT(primary_genre, '/', category)) AS app_category,
    UPPER(CONCAT(a.content_rating, '/', p.content_rating)) AS content,
    ROUND((((ROUND(ROUND(AVG(a.rating+p.rating)) / 2, 1)*2)+1) * 48000), 2) - fc.initial_cost AS total_profit
FROM app_store_apps AS a
INNER JOIN play_store_apps AS p
    ON a.name = p.name
FULL JOIN first_cost AS fc
    ON a.name = fc.name
GROUP BY a.name, avg_price, app_category, content, fc.initial_cost
ORDER BY avg_rating DESC, total_profit DESC;







