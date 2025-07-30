-- =====================================================
-- 2. INSERT SAMPLE DATA
-- =====================================================
;
-- Warning: This will delete all existing data!
-- Delete in reverse order due to foreign key constraints

DELETE FROM ORDERS;
DELETE FROM CLIENTS; 
DELETE FROM LEADS;

-- Insert sample leads (covering last 30+ days with various scenarios)
INSERT INTO LEADS (lead_id, lead_name, lead_phone, lead_source, lead_creation_datetime, valid_lead) VALUES
-- Recent leads from various sources
(234574, 'Russ Turk', '206-555-5555', 'Paid Google', '2025-07-25 05:03:10', 1),
(234575, 'Jane Smith', '206-555-0001', 'Facebook', '2025-07-25 08:15:22', 1),
(234576, 'Bob Johnson', '206-555-0002', 'Paid Google', '2025-07-25 14:30:45', 0), -- invalid lead
(234577, 'Mary Davis', '206-555-0003', 'Radio', '2025-07-24 09:20:15', 1),
(234578, 'John Wilson', '206-555-0004', 'Facebook', '2025-07-24 16:45:30', 1),
(234579, 'Lisa Brown', '206-555-0005', 'Paid Google', '2025-07-23 11:10:20', 1),
(234580, 'Mike Miller', '206-555-0006', 'Organic Search', '2025-07-23 13:25:40', 1),
-- Older leads (to show orders/clients from past leads)
(234581, 'Sarah Garcia', '206-555-0007', 'Radio', '2025-07-15 10:30:00', 1),
(234582, 'Tom Anderson', '206-555-0008', 'Facebook', '2025-07-10 14:20:15', 1),
(234583, 'Amy Martinez', '206-555-0009', 'Paid Google', '2025-07-05 09:15:30', 1),
(234584, 'Chris Taylor', '206-555-0010', 'Organic Search', '2025-07-01 16:40:20', 1),
-- Very recent leads
(234585, 'Katie Jones', '206-555-0011', 'Facebook', '2025-07-29 10:15:30', 1),
(234586, 'Dave Wilson', '206-555-0012', 'Paid Google', '2025-07-29 15:22:45', 1),
(234587, 'Emma Davis', '206-555-0013', 'Radio', '2025-07-28 12:30:15', 1);

-- Insert clients (some are free course registrants, others are paying customers)
INSERT INTO CLIENTS (client_id, client_creation_datetime, lead_id) VALUES
-- Clients who made purchases
(54571, '2025-07-25 11:04:15', 234574), -- Russ Turk - same day purchase
(54572, '2025-07-26 09:30:20', 234575), -- Jane Smith - next day purchase
(54573, '2025-07-27 14:15:45', 234577), -- Mary Davis - Radio source, purchased few days later
(54574, '2025-07-25 17:20:30', 234578), -- John Wilson - same day purchase
(54575, '2025-07-24 08:45:15', 234579), -- Lisa Brown - next day purchase
(54576, '2025-07-23 16:30:25', 234580), -- Mike Miller - same day purchase
-- Clients from older leads making recent purchases
(54577, '2025-07-28 10:15:30', 234581), -- Sarah Garcia - Radio, old lead, recent purchase
(54578, '2025-07-29 13:45:20', 234582), -- Tom Anderson - Facebook, old lead, recent purchase
(54579, '2025-07-15 11:20:15', 234583), -- Amy Martinez - older purchase
-- Free course registrants (clients but no orders initially)
(54580, '2025-07-29 14:30:45', 234585), -- Katie Jones - free course registrant
(54581, '2025-07-29 16:45:20', 234586); -- Dave Wilson - free course registrant

-- Insert orders
INSERT INTO ORDERS (order_id, order_amount, order_creation_datetime, client_id) VALUES
-- Recent orders
(3452, 102454, '2025-07-25 11:04:15', 54571), -- Russ Turk first order ($1,024.54)
(3453, 75000, '2025-07-26 09:30:20', 54572),  -- Jane Smith first order ($750.00)
(3454, 150000, '2025-07-27 14:15:45', 54573), -- Mary Davis first order ($1,500.00)
(3455, 85000, '2025-07-25 17:20:30', 54574),  -- John Wilson first order ($850.00)
(3456, 95000, '2025-07-24 08:45:15', 54575),  -- Lisa Brown first order ($950.00)
(3457, 125000, '2025-07-23 16:30:25', 54576), -- Mike Miller first order ($1,250.00)
-- Orders from older clients
(3458, 200000, '2025-07-28 10:15:30', 54577), -- Sarah Garcia first order ($2,000.00)
(3459, 180000, '2025-07-29 13:45:20', 54578), -- Tom Anderson first order ($1,800.00)
(3460, 90000, '2025-07-15 11:20:15', 54579),  -- Amy Martinez first order ($900.00)
-- Repeat orders (same clients)
(3461, 50000, '2025-07-26 15:30:45', 54571),  -- Russ Turk second order ($500.00)
(3462, 75000, '2025-07-28 12:15:30', 54572),  -- Jane Smith second order ($750.00)
(3463, 60000, '2025-07-29 16:20:15', 54573),  -- Mary Davis second order ($600.00)
-- Free course registrant who later purchased
(3464, 110000, '2025-07-30 10:30:15', 54580); -- Katie Jones first purchase ($1,100.00)
