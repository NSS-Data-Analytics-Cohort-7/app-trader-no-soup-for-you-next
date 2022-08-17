-- app_store_apps
-- "name"	"size_bytes"	"currency"	"price"	"review_count"	"rating"	"content_rating"	"primary_genre"

-- play_store_apps
-- "name"	"category"	"rating"	"review_count"	"size"	"install_count"	"type"	"price"	"content_rating"	"genres"

SELECT *
FROM app_store_apps

SELECT *
FROM play_store_apps

--


SELECT name, rating, CAST(review_count as numeric) as numrev
FROM app_store_apps
ORDER BY rating DESC
WHERE numrev > 1000;

--


SELECT a.name,
       ROUND(((a.rating + p.rating) / 2) ,2) AS avg_rating,
       ROUND(((a.price + REPLACE(p.price, '$', '')::NUMERIC) / 2),2) AS avg_price,
       TO_CHAR(SUM(CAST(a.review_count AS INT)+p.review_count),'FM9,999,999,999')  AS total_review_count
FROM app_store_apps AS a
INNER JOIN play_store_apps AS p
    ON a.name = p.name
GROUP BY a.name, avg_rating, avg_price
HAVING ROUND(((a.price + REPLACE(p.price, '$', '')::NUMERIC) / 2),2) <= 1 AND SUM(CAST(a.review_count AS INT)+p.review_count) > 2000000
ORDER BY avg_rating DESC
LIMIT 10;




