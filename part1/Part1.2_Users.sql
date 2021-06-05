SELECT city,
       COUNT(order_id) AS breakfast_orders,
       COUNT(DISTINCT(user_id)) AS breakfast_users
FROM `bi-2019-test.ad_hoc.orders_jan2021`
WHERE cuisine_parent="Breakfast"
GROUP BY city

HAVING   city IN(
    SELECT  city
    FROM `bi-2019-test.ad_hoc.orders_jan2021`
    GROUP BY city
    HAVING COUNT(order_id)>500)
ORDER BY breakfast_orders DESC
LIMIT 10
