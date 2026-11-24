-- Implements the data contract sku_sales_per_year.odcs.yaml on top of orders_v2.
-- One row per SKU and year (UTC).

CREATE SCHEMA IF NOT EXISTS analytics;

CREATE OR REPLACE VIEW analytics.sku_sales_per_year AS
SELECT
    li.sku                                                        AS sku,
    EXTRACT(YEAR FROM o.order_timestamp AT TIME ZONE 'UTC')::INTEGER AS year,
    COUNT(DISTINCT o.order_id)::BIGINT                            AS order_count,
    SUM(li.quantity)::BIGINT                                      AS total_quantity
FROM orders_v2.line_items li
JOIN orders_v2.orders o ON o.order_id = li.order_id
GROUP BY li.sku, EXTRACT(YEAR FROM o.order_timestamp AT TIME ZONE 'UTC');
