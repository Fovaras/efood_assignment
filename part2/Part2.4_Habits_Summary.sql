WITH habit_summary AS
(
        WITH habit_per_user AS
         (
                SELECT *,
                        (Breakfast+Ethnic+Italian+Meat+Traditional+Creperie+Sweets+street_Food+Healthy_Other) AS total_order
                FROM
                        (
                            SELECT cuisine_parent,user_id
                            FROM `bi-2019-test.ad_hoc.orders_jan2021`
                        )   AS intl_table
                PIVOT
                        (
                            COUNT (cuisine_parent)
                            for cuisine_parent IN ("Breakfast","Italian","Meat","Traditional","Creperie","Ethnic","Sweets","Street food" AS street_Food,"Healthy / Other" AS Healthy_Other)
                        )   AS pivot_table
             )

            SELECT *,
                    ROUND((Breakfast / total_order)*100,1) AS breakfast_orders_over_TTL
            FROM habit_per_user

 )


 SELECT habt.cust_type,
        SUM(habt.no_users) as no_users
 FROM(
         SELECT breakfast_orders_over_TTL,
                COUNT(breakfast_orders_over_TTL) AS no_users,
                CASE
                     WHEN breakfast_orders_over_TTL=0 THEN "Never order Breakfast"
                     WHEN breakfast_orders_over_TTL=100 THEN "Only order Breakfast"
                     ELSE "Hybrid Orders"
                END AS cust_type
         FROM habit_summary
         GROUP BY breakfast_orders_over_TTL
     ) AS habt
 GROUP BY habt.cust_type
