-- SELECT *
-- FROM app_store_apps
--rows 7197

-- SELECT * 
-- FROM play_store_apps
-- rows 10840

--3.Content Rating .--app store
-- SELECT 
-- name,
-- price,
-- content_rating,
-- review_count,
-- primary_genre
-- From app_store_apps
-- WHERE content_rating BETWEEN '+4' ANd '9+'
-- ORDER BY content_rating DESC
-- LIMIT 10
--Group By 1,2,3

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



