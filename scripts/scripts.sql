-- app_store_apps
-- "name"	"size_bytes"	"currency"	"price"	"review_count"	"rating"	"content_rating"	"primary_genre"

-- play_store_apps
-- "name"	"category"	"rating"	"review_count"	"size"	"install_count"	"type"	"price"	"content_rating"	"genres"

SELECT *
FROM app_store_apps

SELECT *
FROM play_store_apps

SELECT name, rating, CAST(review_count as numeric) as numrev
FROM app_store_apps
WHERE numrev > 1000
ORDER BY rating DESC;

--This is the average rating and average price.
SELECT app.name, AVG(app.rating+play.rating) AS AVG_rating,
AVG(app.price + replace(play.price, '$', '')::numeric)AS avg_price
FROM app_store_apps AS app
INNER JOIN play_store_apps AS play
ON app.name = play.name
GROUP BY app.name
ORDER BY AVG_rating DESC;

SELECT a.name, AVG(a.rating+p.rating) as arating
FROM app_store_apps as a
INNER JOIN play_store_apps as p
ON a.name = p.name
ORDER BY a.name, arating
GROUP BY a.name;