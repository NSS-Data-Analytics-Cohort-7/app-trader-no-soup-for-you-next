-- app_store_apps
-- "name"	"size_bytes"	"currency"	"price"	"review_count"	"rating"	"content_rating"	"primary_genre"

-- play_store_apps
-- "name"	"category"	"rating"	"review_count"	"size"	"install_count"	"type"	"price"	"content_rating"	"genres"

-- a. App Trader will purchase apps for 10,000 times the price of the app. For apps that are priced from free up to $1.00, the purchase price is $10,000.  

SELECT *
FROM app_store_apps

SELECT *
FROM play_store_apps

-- FINAL

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

--  Highest rating with over 2 million reviews

SELECT a.name,
       ROUND(((a.rating + p.rating) / 2) ,2) AS avg_rating,
       ROUND(((a.price + REPLACE(p.price, '$', '')::NUMERIC) / 2),2) AS avg_price,
       TO_CHAR(SUM(CAST(a.review_count AS INT)+p.review_count),'FM9,999,999,999')  AS total_review_count
FROM app_store_apps AS a  TO_CHAR(,'FM9,999,999,999')
INNER JOIN play_store_apps AS p
    ON a.name = p.name
GROUP BY a.name, avg_rating, avg_price
HAVING ROUND(((a.price + REPLACE(p.price, '$', '')::NUMERIC) / 2),2) <= 1 AND SUM(CAST(a.review_count AS INT)+p.review_count) > 2000000
ORDER BY avg_rating DESC
LIMIT 12;

-- D version

select a.name, 
round((a.rating+p.rating)/2,2) as avg_rating,
round(AVG(a.price + replace(p.price, '$', '')::numeric),2) AS avg_price,
sum(cast(a.review_count as int)+p.review_count) as total_review_count
from app_store_apps as a
inner join play_store_apps as p
on a.name = p.name
group by a.name, a.rating, p.rating
having round(AVG(a.price + replace(p.price, '$', '')::numeric),2) <= 1 
and sum(cast(a.review_count as int)+p.review_count) > 2000000
order by avg_rating desc
limit 10;

-- Group colab - J
SELECT a.name, p.genres,
     CONCAT(p.content_rating, '/', a.content_rating) AS content_rating,
     ROUND(AVG((a.rating+p.rating))/2,2) AS AVG_rating,
     ROUND(AVG((a.price + replace(p.price, '$', '')::numeric)/2),2)AS                avg_price
FROM app_store_apps AS a
INNER JOIN play_store_apps AS p
ON a.name = p.name
GROUP BY a.name, p.genres, p.content_rating, a.content_rating
HAVING ROUND(AVG((a.price + replace(p.price, '$', '')::numeric)/2),2) <=1
    AND ROUND(AVG((a.rating+p.rating))/2,2) >= 4.5
ORDER BY avg_rating DESC
LIMIT 15;

-- Group colab v.2 - D
select a.name,
CONCAT(p.content_rating, '/', a.content_rating) AS content_rating,
case when round(((a.rating+p.rating)/2),2) >= 4.75 then 5
when round(((a.rating+p.rating)/2),2) >= 4.25 then 4.5
end as avg_rating_rounded,
round(((a.rating+p.rating)/2),2) as avg_rating,
round(((a.price + replace(p.price, '$', '')::numeric)/2),2) AS avg_price,
(cast(a.review_count as int)) + round(avg(p.review_count),2) as total_review_count,
a.primary_genre
from app_store_apps as a
inner join play_store_apps as p
on a.name = p.name
group by a.name, avg_rating, avg_price, primary_genre, p.content_rating, a.content_rating, a.review_count
having round(((a.price + replace(p.price, '$', '')::numeric)/2),2) <= 1
order by avg_rating desc
LIMIT 10;

--

SELECT genres,category
FROM play_store_apps;

--

SELECT *
FROM play_store_apps
WHERE rating>=4.5 AND price='0'
ORDER BY review_count DESC;

-- a. App Trader will purchase apps for 10,000 times the price of the app. For apps that are priced from free up to $1.00, the purchase price is $10,000.  

-- 0 - 1 = $10,000, 1.01 and up = x

--  "Cost of app"
--  0-1.00 = $10,000
--  1.01 and up = price(10000)

-- Total cost of app to buy for app buyer person - Apple

SELECT name,price,review_count,rating,
CASE
    WHEN price<= 1 THEN '10000'
    WHEN price> 1 THEN TO_CHAR((price * 10000), 'FM9,999,999,999')
    END AS total_price
FROM app_store_apps
ORDER BY total_price DESC;

-- Total cost of app to buy for app buyer person - Google
-- Need to fix commas.

SELECT 
name,
price,
install_count,
rating,
CASE
    WHEN CAST(REPLACE(price, '$', '') AS NUMERIC)<=1 THEN 10000
    WHEN CAST(REPLACE(price, '$', '') AS NUMERIC)>1 THEN TO_CHAR(CAST(REPLACE((price, '$', '') AS NUMERIC) * 10000), 'FM9,999,999,999')
    END AS total_price
FROM play_store_apps
ORDER BY total_price DESC;

--TO_CHAR(,'FM9,999,999,999')
--TO_CHAR(SUM(CAST(a.review_count AS INT)+p.review_count),'FM9,999,999,999')  AS total_review_count
-- ROUND

SELECT
    ROUND(10.817, 1);
    
SELECT 
    ROUND((4.4%1), 0);

--b. Apps earn $5000 per month on average from in-app advertising and in-app purchases _regardless_ of the price of the app.

-- "Profit of app"
-- Total est. lifespan * 12(5000)

-- c. App Trader will spend an average of $1000 per month to market an app _regardless_ of the price of the app. If App Trader owns rights to the app in both stores, it can market the app for both stores for a single cost of $1000 per month.  

-- "Total cost of advertising"
-- Total est. lifespan * 12(1000) IF on one list
-- Total est. lifespan * 6(1000) IF on both lists

-- d. For every half point that an app gains in rating, its projected lifespan increases by one year, in other words, an app with a rating of 0 can be expected to be in use for 1 year, an app with a rating of 1.0 can be expected to last 3 years, and an app with a rating of 4.0 can be expected to last 9 years. Ratings should be rounded to the nearest 0.5 to evaluate an app's likely longevity.  

-- "Longevity"
-- Longevity = ((Rating * 2) + 1)
-- 0 - 1 year
-- .5 - 2 years
-- 1 - 3 years
-- 1.5 - 4 years
-- 2 - 5 years
-- 2.5 - 6 years
-- 3 - 7 years
-- 3.5 - 8 years
-- 4 - 9 years
-- 4.5 - 10 years
-- 5 - 11 years

SELECT 

-- e. App Trader would prefer to work with apps that are available in both the App Store and the Play Store since they can market both for the same $1000 per month.
-- Group colab
SELECT a.name, p.genres,
     CONCAT(p.content_rating, '/', a.content_rating) AS content_rating,
     ROUND(AVG((a.rating+p.rating))/2,2) AS AVG_rating,
     ROUND(AVG((a.price + replace(p.price, '$', '')::numeric)/2),2)AS                avg_price
FROM app_store_apps AS a
INNER JOIN play_store_apps AS p
ON a.name = p.name
GROUP BY a.name, p.genres, p.content_rating, a.content_rating
HAVING ROUND(AVG((a.price + replace(p.price, '$', '')::numeric)/2),2) <=1
    AND ROUND(AVG((a.rating+p.rating))/2,2) >= 4.5
ORDER BY avg_rating DESC
LIMIT 15;

-- DELETE


