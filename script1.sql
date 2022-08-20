-- SELECT *
-- FROM app_store_apps
--rows 7197

-- SELECT * 
-- FROM play_store_apps
-- rows 10840

--3.Content Rating .--app store

SELECT
name,
content_rating,
review_count,
primary_genre,
SUM(Price)

From app_store_apps
WHERE content_rating BETWEEN '+4' AND '9+'
AND primary_genre = 'games'
GROUP BY 1,2,3,4
ORDER BY content_rating DESC
LIMIT 10


--play_store_apps
-- SELECT
-- name,
--price,
-- category,
-- rating,
-- genres,
-- content_rating

-- FROM play_store_apps
-- WHERE rating >= 4.0
-- ORDER BY rating DESC
-- LIMIT 10








-- SELECT -- Jake's Query
--     a.name,
--     ROUND(ROUND(AVG(a.rating + p.rating)) / 2, 1) AS avg_rating,
--     ROUND(((a.price + REPLACE(p.price, '$', '')::NUMERIC) / 2),2) AS avg_price,
--     UPPER(CONCAT(primary_genre, '/', category)) AS app_category
-- FROM app_store_apps AS a
-- INNER JOIN play_store_apps AS p
--     ON a.name = p.name
-- GROUP BY a.name, avg_price, app_category
-- HAVING ROUND(((a.price + REPLACE(p.price, '$', '')::NUMERIC) / 2),2) <= 1
-- ORDER BY avg_rating DESC;











