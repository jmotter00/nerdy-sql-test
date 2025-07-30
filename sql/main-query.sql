-- =====================================================
-- 3. MAIN QUERY TO GENERATE THE REPORT
-- =====================================================

WITH date_range AS (
    -- Generate last 30 days
    SELECT generate_series(
        CURRENT_DATE - INTERVAL '29 days',
        CURRENT_DATE,
        INTERVAL '1 day'
    )::date AS report_date
),

lead_sources AS (
    -- Get all unique lead sources
    SELECT DISTINCT lead_source
    FROM LEADS
),

date_source_combinations AS (
    -- Create all combinations of dates and lead sources
    SELECT 
        dr.report_date,
        ls.lead_source
    FROM date_range dr
    CROSS JOIN lead_sources ls
),

daily_valid_leads AS (
    -- Count valid leads by date and source
    SELECT 
        DATE(lead_creation_datetime) AS lead_date,
        lead_source,
        COUNT(*) AS valid_leads_count
    FROM LEADS
    WHERE valid_lead = 1
        AND DATE(lead_creation_datetime) >= CURRENT_DATE - INTERVAL '29 days'
        AND DATE(lead_creation_datetime) <= CURRENT_DATE
    GROUP BY DATE(lead_creation_datetime), lead_source
),

daily_new_clients AS (
    -- Count new clients (first purchase) by date and original lead source
    SELECT 
        DATE(first_order.order_creation_datetime) AS order_date,
        l.lead_source,
        COUNT(*) AS new_clients_count
    FROM (
        -- Find first order for each client
        SELECT 
            client_id,
            MIN(order_creation_datetime) AS order_creation_datetime
        FROM ORDERS
        GROUP BY client_id
    ) first_order
    JOIN CLIENTS c ON first_order.client_id = c.client_id
    JOIN LEADS l ON c.lead_id = l.lead_id
    WHERE DATE(first_order.order_creation_datetime) >= CURRENT_DATE - INTERVAL '29 days'
        AND DATE(first_order.order_creation_datetime) <= CURRENT_DATE
    GROUP BY DATE(first_order.order_creation_datetime), l.lead_source
),

daily_orders AS (
    -- Count all orders and sum amounts by date and original lead source
    SELECT 
        DATE(o.order_creation_datetime) AS order_date,
        l.lead_source,
        COUNT(*) AS orders_count,
        SUM(o.order_amount) AS order_dollars_cents
    FROM ORDERS o
    JOIN CLIENTS c ON o.client_id = c.client_id
    JOIN LEADS l ON c.lead_id = l.lead_id
    WHERE DATE(o.order_creation_datetime) >= CURRENT_DATE - INTERVAL '29 days'
        AND DATE(o.order_creation_datetime) <= CURRENT_DATE
    GROUP BY DATE(o.order_creation_datetime), l.lead_source
)

-- Final report query
SELECT 
    dsc.report_date AS "Date",
    dsc.lead_source AS "Lead Source",
    COALESCE(dvl.valid_leads_count, 0) AS "Valid Leads",
    COALESCE(dnc.new_clients_count, 0) AS "New Clients", 
    COALESCE(dao.orders_count, 0) AS "Orders",
    ROUND(COALESCE(dao.order_dollars_cents, 0) / 100.0, 2) AS "Order Dollars"
FROM date_source_combinations dsc
LEFT JOIN daily_valid_leads dvl 
    ON dsc.report_date = dvl.lead_date 
    AND dsc.lead_source = dvl.lead_source
LEFT JOIN daily_new_clients dnc 
    ON dsc.report_date = dnc.order_date 
    AND dsc.lead_source = dnc.lead_source
LEFT JOIN daily_orders dao 
    ON dsc.report_date = dao.order_date 
    AND dsc.lead_source = dao.lead_source
WHERE (dvl.valid_leads_count > 0 
    OR dnc.new_clients_count > 0 
    OR dao.orders_count > 0)
ORDER BY dsc.report_date DESC, dsc.lead_source;