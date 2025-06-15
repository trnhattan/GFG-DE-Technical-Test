-- 1. What was the total revenue to the nearest dollar for customers who have paid by credit card?
-- |Total Revenue|
-- |:-------------:|
-- |   50189329  |

SELECT ROUND(SUM(cs.revenue)) AS "Total Revenue"
FROM customer_snapshot cs
WHERE cs.cc_payments > 0;


-- 2. What percentage of customers who have purchased female items have paid by credit card?
-- | Percentage of female items with CC payment |
-- |--------------------------------------------|
-- |                    65.48                   |

SELECT 
    ROUND(
        (COUNT(CASE WHEN cs.cc_payments > 0 AND cs.female_items > 0 THEN 1 END) * 100.0) / 
        COUNT(CASE WHEN cs.female_items > 0 THEN 1 END), 
        2
    ) AS "Percentage of female items with CC payment"
FROM customer_snapshot cs;

-- 3. What was the average revenue for customers who used either iOS, Android or Desktop?
-- | Average revenue for any of 3 devices |
-- |--------------------------------------|
-- |               1487.09                |
SELECT ROUND(AVG(cs.revenue)::numeric, 2) AS "Average revenue for any of 3 devices"
FROM customer_snapshot cs
WHERE cs.ios_orders > 0
    OR cs.android_orders > 0
    OR cs.desktop_orders > 0;

-- | Device type | Average revenue per device type |
-- |-------------|---------------------------------|
-- | iOS         | 4760.68                         |
-- | Desktop     | 944.94                          |
-- | Android     | 3858.69                         |

SELECT device_type AS "Device type",
       ROUND(AVG(revenue)::numeric, 2) AS "Average revenue per device type"
FROM (
    SELECT cs.customer_id, cs.revenue,
        CASE
            WHEN cs.ios_orders > 0 THEN 'iOS'
            WHEN cs.android_orders > 0 THEN 'Android'
            WHEN cs.desktop_orders > 0 THEN 'Desktop'
        END AS device_type
    FROM customer_snapshot cs
    WHERE cs.ios_orders > 0
        OR cs.android_orders > 0
        OR cs.desktop_orders > 0
)
GROUP BY device_type;

-- 4. We want to run an email campaign promoting a new mens luxury brand. Can you provide a list of customers we should send to?
WITH item_summary AS (
    SELECT
        cs.customer_id,
        cs.days_since_last_order,
        (cs.male_items + cs.mapp_items + cs.macc_items + cs.mftw_items + cs.mspt_items) AS men_items,
        (cs.female_items + cs.wapp_items + cs.wftw_items + cs.wacc_items + cs.wspt_items) AS women_items,
        (cs.unisex_items + cs.curvy_items) AS other_items
    FROM customer_snapshot cs
    WHERE cs.is_newsletter_subscriber
      AND cs.days_since_last_order <= 90
      AND cs.revenue >= (SELECT PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY t_cs.revenue) FROM customer_snapshot t_cs)
)
SELECT customer_id
FROM item_summary
WHERE (men_items + women_items + other_items) > 0
  AND (1.0 * men_items / (men_items + women_items + other_items)) >= 0.5