
--Calcuation of 5 Customer Segments per user
WITH cust_segm AS
(
--Calculation of the formula "Total Score=0.6*Value_Ranking+ 0.4* Orders_Ranking"
WITH ttl_score_base AS
(
-- Group by User_Id the base
        WITH orders AS
        (
              SELECT user_id,
                     COUNT(order_id) AS order_frequency,
                     ROUND(SUM(basket),1) AS order_value
              FROM `bi-2019-test.ad_hoc.orders_jan2021`
              GROUP BY user_id
        )
    --I breakdown the base into 5 segments, based on the order_Frequency #
        SELECT fact.*,
            CASE
                 WHEN order_frequency=1 THEN 1
                 WHEN order_frequency=2 THEN 2
                 WHEN order_frequency=3 THEN 3
                 WHEN (order_frequency=4 OR order_frequency=5)  THEN 4
                 ELSE 5
            END AS Order_Frequency_Segment,
            cluster.Value_Segment AS Order_Value_Segment

        FROM orders AS fact
    --I breakdown the base into 5 segments of the same population each, based on the order_value €
        INNER JOIN
             (
                SELECT portion.user_id, portion.Order_Value,
                       NTILE(5) OVER (ORDER BY portion.Order_Value ASC) AS Value_Segment
                FROM (
                SELECT user_id,
                       SUM(basket) AS Order_Value
                FROM `bi-2019-test.ad_hoc.orders_jan2021`
                GROUP BY user_id) AS portion
             )
        AS cluster ON fact.user_id=cluster.user_id

)
--More weight at the value factor with 0.6

SELECT *,
       ROUND((Order_Frequency_Segment*0.4+Order_Value_Segment*0.6),1) AS total_score
FROM ttl_score_base

)
SELECT *,
       CASE
          WHEN total_score=5 THEN "1_Champions"
          WHEN total_score>=4 THEN "2_Loyal"
          WHEN total_score>2.8 THEN "3_Potential Loyalist"
          WHEN total_score>=2 THEN "4_Promising"
          WHEN  total_score>=1 THEN"5_Need Attention"
          ELSE "error"
          END AS customer_segment
FROM cust_segm
