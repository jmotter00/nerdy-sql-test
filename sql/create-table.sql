-- =====================================================
-- 1. CREATE TABLES
-- =====================================================


CREATE TABLE IF NOT EXISTS LEADS (
    lead_id INTEGER PRIMARY KEY,
    lead_name VARCHAR(255),
    lead_phone VARCHAR(20),
    lead_source VARCHAR(100),
    lead_creation_datetime TIMESTAMP,
    valid_lead INTEGER CHECK (valid_lead IN (0, 1))
);

CREATE TABLE IF NOT EXISTS CLIENTS (
    client_id INTEGER PRIMARY KEY,
    client_creation_datetime TIMESTAMP,
    lead_id INTEGER REFERENCES LEADS(lead_id)
);

CREATE TABLE IF NOT EXISTS ORDERS (
    order_id INTEGER PRIMARY KEY,
    order_amount NUMERIC,
    order_creation_datetime TIMESTAMP,
    client_id INTEGER REFERENCES CLIENTS(client_id)
);