CREATE INDEX idx_leads_creation_date ON leads (lead_creation_datetime);
CREATE INDEX idx_leads_valid_source ON leads (valid_lead, lead_source);

CREATE INDEX idx_clients_lead_id ON clients (lead_id);
CREATE INDEX idx_orders_client_id ON orders (client_id);
CREATE INDEX idx_orders_creation_date ON orders (order_creation_datetime);