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

--added rating and genre, rounded star average
SELECT a.name, a.primary_genre, 
     CONCAT(p.content_rating, '/', a.content_rating) AS content_rating,
     ROUND(AVG((a.price + replace(p.price, '$', '')::numeric)/2),2)AS                avg_price,
     CASE WHEN ROUND(AVG((a.rating+p.rating))/2,2) >=4.75 THEN '5.0'
     WHEN ROUND(AVG((a.rating+p.rating))/2,2) >=4.25 THEN '4.5'
     END AS avg_rating_rounded
FROM app_store_apps AS a
INNER JOIN play_store_apps AS p
ON a.name = p.name
GROUP BY a.name, a.primary_genre, p.content_rating, a.content_rating
HAVING ROUND(AVG((a.price + replace(p.price, '$', '')::numeric)/2),2) <=1
    AND ROUND(AVG((a.rating+p.rating))/2,2) >= 4.5
ORDER BY avg_rating_rounded DESC
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

--addition way to round

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


--profit
WITH first_cost AS
    (SELECT a.name,
        CASE WHEN ROUND(AVG((a.price + replace(p.price, '$',                                '')::numeric)/2),2)<=1 THEN 10000
       WHEN ROUND(AVG((a.price + replace(p.price, '$',                                      '')::numeric)/2),2)>1 THEN ROUND(AVG((a.price + replace(p.price, '$',                                      '')::numeric)/2),2)*10000
       END AS initial_cost 
     FROM app_store_apps AS a
     INNER JOIN play_store_apps AS p
     ON a.name = p.name
     GROUP BY a.name)
SELECT a.name, a.primary_genre,
      (ROUND(AVG((a.rating+p.rating))/2,2)*2)+1 AS longevity,
      (((ROUND(AVG((a.rating+p.rating))/2,2))*2)+1)*60000 AS total_revenue,
      ((((ROUND(AVG((a.rating+p.rating))/2,2))*2)+1)*108000) - fc.initial_cost AS               total_profit,
     CONCAT(p.content_rating, '/', a.content_rating) AS content_rating,
     ROUND(AVG((a.price + replace(p.price, '$', '')::numeric)/2),2)AS                   avg_price,
     CASE WHEN ROUND(AVG((a.rating+p.rating))/2,2) >=4.75 THEN '5.0'
     WHEN ROUND(AVG((a.rating+p.rating))/2,2) >=4.25 THEN '4.5'
     END AS avg_rating_rounded
FROM app_store_apps AS a
INNER JOIN play_store_apps AS p
ON a.name = p.name
FULL JOIN first_cost AS fc
ON a.name = fc.name
GROUP BY 1, 2, p.content_rating, a.content_rating, fc.initial_cost
HAVING ROUND(AVG((a.price + replace(p.price, '$', '')::numeric)/2),2) <=1
    AND ROUND(AVG((a.rating+p.rating))/2,2) >= 4.5
ORDER BY total_profit DESC
LIMIT 15;

--master list

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
    (((ROUND(ROUND(AVG(a.rating+p.rating)) / 2, 1)*2)+1) * 108000) - fc.initial_cost AS total_profit
FROM app_store_apps AS a
INNER JOIN play_store_apps AS p
    ON a.name = p.name
FULL JOIN first_cost AS fc
    ON a.name = fc.name
GROUP BY a.name, avg_price, app_category, content, fc.initial_cost
HAVING ROUND(((a.price + REPLACE(p.price, '$', '')::NUMERIC) / 2),2) <= 1
ORDER BY avg_rating DESC
LIMIT 10;









