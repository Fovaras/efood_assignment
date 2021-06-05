--I have kept some columns more, in order to be more explanatory

SELECT city,
       COUNT(order_id) AS breakfast_orders,
       COUNT(distinct(user_id)) AS breakfast_users,
       ROUND(SUM(basket),1) AS TTL_breakfast_basket,
       ROUND((SUM(basket)/COUNT(DISTINCT(user_id))),1) AS breakfast_basket_per_user
FROM `bi-2019-test.ad_hoc.orders_jan2021`
WHERE cuisine_parent="Breakfast"
GROUP BY city


HAVING   city IN(
    SELECT  city
    FROM `bi-2019-test.ad_hoc.orders_jan2021`
    GROUP BY city
    HAVING COUNT(order_id)>500)
ORDER BY breakfast_Orders DESC
LIMIT 10
