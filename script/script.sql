--what apps are on both stores.
SELECT app.name
FROM app_store_apps AS app
INNER JOIN play_store_apps AS play
ON app.name = play.name;

--Ratings?

SELECT app.name, ROUND(AVG((app.rating+play.rating)/2),2) AS AVG_rating
FROM app_store_apps AS app
INNER JOIN play_store_apps AS play
ON app.name = play.name
GROUP BY app.name
ORDER BY AVG_rating DESC;

--price?

SELECT app.name, 
    ROUND(AVG((app.rating+play.rating))/2,2) AS AVG_rating,
    ROUND(AVG((app.price + replace(play.price, '$', '')::numeric)/2),2)AS           avg_price
FROM app_store_apps AS app
INNER JOIN play_store_apps AS play
ON app.name = play.name
GROUP BY app.name
HAVING ROUND(AVG((app.price + replace(play.price, '$', '')::numeric)/2),2) <1
ORDER BY AVG_rating DESC, avg_price
LIMIT 11;

--review count?

SELECT a.name, 
    ROUND(AVG((a.rating+p.rating))/2,2) AS AVG_rating,
    ROUND(AVG((a.price + replace(p.price, '$', '')::numeric)/2),2)AS           avg_price,
    SUM(cast(a.review_count as int)+p.review_count) as total_review_count
FROM app_store_apps AS a
INNER JOIN play_store_apps AS p
ON a.name = p.name
GROUP BY a.name
HAVING ROUND(AVG((a.price + replace(p.price, '$', '')::numeric)/2),2) <1
    AND ROUND(AVG((a.rating+p.rating))/2,2) >= 4.5
ORDER BY total_review_count DESC
LIMIT 15;

--added rating and genre
SELECT a.name, p.genres, 
    CONCAT(p.content_rating, '/', a.content_rating) AS content_rating,
    ROUND(AVG((a.rating+p.rating))/2,2) AS AVG_rating,
    ROUND(AVG((a.price + replace(p.price, '$', '')::numeric)/2),2)AS           avg_price,
    cast(a.review_count as int) + Max(p.review_count) as total_review_count
FROM app_store_apps AS a
INNER JOIN play_store_apps AS p
ON a.name = p.name
GROUP BY a.name, p.genres, p.content_rating, a.content_rating, a.review_count
HAVING ROUND(AVG((a.price + replace(p.price, '$', '')::numeric)/2),2) <1
    AND ROUND(AVG((a.rating+p.rating))/2,2) >= 4.5
ORDER BY total_review_count DESC
LIMIT 15;

--just app store
SELECT *
FROM app_store_apps
WHERE price=0 AND rating>=4.5
ORDER BY CAST(review_count AS int) DESC;

--just play store
SELECT *
FROM play_store_apps
WHERE rating>=4.5 AND price='0'
ORDER BY review_count DESC;















