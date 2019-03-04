-- Question 1(+) (Select all columns from the first 10 rows of each table. (What columns does the table have?)
SELECT *
FROM survey
LIMIT 10;
SELECT *
FROM quiz
LIMIT 10;
SELECT *
FROM purchase
LIMIT 10;
SELECT *
FROM home_try_on
LIMIT 10;



-- Question 2 (What is the number of responses for each question?)
SELECT question, COUNT(*) AS 'Total answered'
FROM survey
GROUP BY question;
-- Question 3 
-- 3a) Which question(s) of the quiz have a lower completion rates?
-- 3b) What do you think is the reason?
-- This was completed in google sheets

-- Question 4 Examine the first five rows of each table. What are the column names?
SELECT *
FROM quiz
LIMIT 5;
SELECT *
FROM home_try_on
LIMIT 5;
SELECT *
FROM purchase
LIMIT 5;

-- Question 5 joining tables
SELECT DISTINCT q.user_id, 
    hto.user_id IS NOT NULL AS 'is_home_try_on', 
    hto.number_of_pairs AS 'number_of_pairs', 
	p.user_id IS NOT NULL AS 'is_purchase'
 FROM quiz AS 'q'
 LEFT JOIN home_try_on AS 'hto'
 ON hto.user_id = q.user_id
 LEFT JOIN purchase AS 'p'
 ON p.user_id = q.user_id
 LIMIT 10;
 
 -- Question 6.1 Overall conversion rates for 
 WITH 'try_on_funnel' AS (
  SELECT DISTINCT q.user_id, 
    hto.user_id IS NOT NULL AS 'is_home_try_on', 
    hto.number_of_pairs AS 'number_of_pairs', 
	p.user_id IS NOT NULL AS 'is_purchase'
 FROM quiz AS 'q'
 LEFT JOIN home_try_on AS 'hto'
 ON hto.user_id = q.user_id
 LEFT JOIN purchase AS 'p'
 ON p.user_id = q.user_id)
 SELECT COUNT(*) AS 'Total_quiz_takers', SUM(is_home_try_on) AS 'total_tried_at_home', SUM(is_purchase) AS 'total_made_purchase',
   	100.0*SUM(is_purchase) / COUNT(user_id) AS 'Avg CR %'
FROM try_on_funnel;
 
 -- Question 6.2 Purchase rates for 3 pairs vs. 5 pairs
WITH 'try_on_funnel' AS (
  SELECT DISTINCT q.user_id, 
    hto.user_id IS NOT NULL AS 'is_home_try_on', 
    hto.number_of_pairs AS 'number_of_pairs', 
	p.user_id IS NOT NULL AS 'is_purchase'
 FROM quiz AS 'q'
 LEFT JOIN home_try_on AS 'hto'
 ON hto.user_id = q.user_id
 LEFT JOIN purchase AS 'p'
 ON p.user_id = q.user_id)
 SELECT number_of_pairs,
   	SUM(is_home_try_on) AS 'num_try_on',
    SUM(is_purchase) AS 'num_purchase',
   ROUND(1.0 * SUM(is_purchase) / SUM(is_home_try_on), 2) AS 'try-on_to_purchase'
FROM try_on_funnel
GROUP BY number_of_pairs
ORDER BY number_of_pairs;

-- Question 6.3 Conversions from quiz to try on and try on to purchase
WITH 'try_on_funnel' AS (
  SELECT DISTINCT q.user_id, 
    hto.user_id IS NOT NULL AS 'is_home_try_on', 
    hto.number_of_pairs AS 'number_of_pairs', 
	p.user_id IS NOT NULL AS 'is_purchase'
 FROM quiz AS 'q'
 LEFT JOIN home_try_on AS 'hto'
 ON hto.user_id = q.user_id
 LEFT JOIN purchase AS 'p'
 ON p.user_id = q.user_id)
 SELECT COUNT(*) AS 'Total_quiz_num',
   	ROUND(100.0*SUM(is_home_try_on) / COUNT(user_id), 2) AS 'quiz-to-try_on %',
    ROUND(100.0*SUM(is_purchase) / SUM(is_home_try_on), 2) AS 'try-on to purchase %'
FROM try_on_funnel;

-- Question 6.4 Quiz questions people were most unsure of
SELECT COUNT(style)
FROM quiz
WHERE style LIKE '%skip it%';

SELECT COUNT(fit)
FROM quiz
WHERE fit LIKE '%skip it%';

SELECT COUNT(shape)
FROM quiz
WHERE shape LIKE '%skip it%';

SELECT COUNT(color)
FROM quiz
WHERE color LIKE '%skip it%';