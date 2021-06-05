
--1st deliverable

--Apo tis poleis poy exoun pano apo 500 orders, Na do sygkekrimena gia breakfast posa einai to orders ana city

SELECT city,
       COUNT(order_id) AS Breakfast_Orders
FROM `bi-2019-test.ad_hoc.orders_jan2021`
WHERE cuisine_parent="Breakfast"
GROUP BY city

HAVING   city IN
 (
    SELECT  city
    FROM `bi-2019-test.ad_hoc.orders_jan2021`
    GROUP BY city
    HAVING COUNT(order_id)>500
 )

ORDER BY Breakfast_Orders DESC
LIMIT 10
