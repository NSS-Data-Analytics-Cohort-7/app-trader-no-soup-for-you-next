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

SELECT app.name, 
    ROUND(AVG((app.rating+play.rating))/2,2) AS AVG_rating,
    ROUND(AVG((app.price + replace(play.price, '$', '')::numeric)/2),2)AS           avg_price,
    SUM(cast(app.review_count as int)+play.review_count) as total_review_count
FROM app_store_apps AS app
INNER JOIN play_store_apps AS play
ON app.name = play.name
GROUP BY app.name
HAVING ROUND(AVG((app.price + replace(play.price, '$', '')::numeric)/2),2) <1
    AND SUM(cast(app.review_count as int)+play.review_count) > 1000000
ORDER BY AVG_rating DESC, avg_price
LIMIT 10;















