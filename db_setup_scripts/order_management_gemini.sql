-- Drop tables if they exist (for easy re-execution)
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS payment_methods;
DROP TABLE IF EXISTS shipments;
DROP TABLE IF EXISTS inventory;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS addresses;

-- --------------------------------------------------------------------------------------------------
-- Addresses Table
-- --------------------------------------------------------------------------------------------------
CREATE TABLE addresses (
    address_id SERIAL PRIMARY KEY,
    street_address VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    zip_code VARCHAR(20) NOT NULL,
    country VARCHAR(100) NOT NULL
);

-- --------------------------------------------------------------------------------------------------
-- Customers Table
-- --------------------------------------------------------------------------------------------------
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone_number VARCHAR(20),
    address_id INTEGER REFERENCES addresses(address_id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_customers_email ON customers(email);


-- --------------------------------------------------------------------------------------------------
-- Categories Table
-- --------------------------------------------------------------------------------------------------
CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(100) UNIQUE NOT NULL
);
CREATE INDEX idx_categories_name ON categories(category_name);


-- --------------------------------------------------------------------------------------------------
-- Products Table
-- --------------------------------------------------------------------------------------------------
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    category_id INTEGER REFERENCES categories(category_id) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_products_name ON products(product_name);
CREATE INDEX idx_products_category_id ON products(category_id);

-- --------------------------------------------------------------------------------------------------
-- Orders Table
-- --------------------------------------------------------------------------------------------------
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INTEGER REFERENCES customers(customer_id) NOT NULL,
    order_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(12, 2) NOT NULL,
    shipping_address_id INTEGER REFERENCES addresses(address_id),
    order_status VARCHAR(50) DEFAULT 'Pending'
);
CREATE INDEX idx_orders_customer_id ON orders(customer_id);
CREATE INDEX idx_orders_date ON orders(order_date);

-- --------------------------------------------------------------------------------------------------
-- Order_Items Table
-- --------------------------------------------------------------------------------------------------
CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INTEGER REFERENCES orders(order_id) NOT NULL,
    product_id INTEGER REFERENCES products(product_id) NOT NULL,
    quantity INTEGER NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_order_items_order_id ON order_items(order_id);
CREATE INDEX idx_order_items_product_id ON order_items(product_id);


-- --------------------------------------------------------------------------------------------------
-- Inventory Table
-- --------------------------------------------------------------------------------------------------
CREATE TABLE inventory (
    inventory_id SERIAL PRIMARY KEY,
    product_id INTEGER REFERENCES products(product_id) UNIQUE NOT NULL,
    quantity_in_stock INTEGER NOT NULL,
    last_updated TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- --------------------------------------------------------------------------------------------------
-- Shipments Table
-- --------------------------------------------------------------------------------------------------
CREATE TABLE shipments (
    shipment_id SERIAL PRIMARY KEY,
    order_id INTEGER REFERENCES orders(order_id) NOT NULL,
    shipping_address_id INTEGER REFERENCES addresses(address_id),
    tracking_number VARCHAR(255),
    shipping_date TIMESTAMP WITH TIME ZONE,
    estimated_delivery_date TIMESTAMP WITH TIME ZONE,
    shipment_status VARCHAR(50) DEFAULT 'Pending'
);
CREATE INDEX idx_shipments_order_id ON shipments(order_id);
CREATE INDEX idx_shipments_shipping_date ON shipments(shipping_date);


-- --------------------------------------------------------------------------------------------------
-- Payment Methods Table
-- --------------------------------------------------------------------------------------------------
CREATE TABLE payment_methods (
    payment_method_id SERIAL PRIMARY KEY,
    method_name VARCHAR(100) UNIQUE NOT NULL
);

-- --------------------------------------------------------------------------------------------------
-- Payments Table
-- --------------------------------------------------------------------------------------------------
CREATE TABLE payments (
    payment_id SERIAL PRIMARY KEY,
    order_id INTEGER REFERENCES orders(order_id) NOT NULL,
    payment_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    amount DECIMAL(12, 2) NOT NULL,
    payment_method_id INTEGER REFERENCES payment_methods(payment_method_id) NOT NULL,
    transaction_id VARCHAR(255) NOT NULL
);
CREATE INDEX idx_payments_order_id ON payments(order_id);
CREATE INDEX idx_payments_date ON payments(payment_date);


-- Insert sample addresses
INSERT INTO addresses (street_address, city, state, zip_code, country) VALUES
    ('123 Main St', 'Anytown', 'CA', '91234', 'USA'),
    ('456 Oak Ave', 'Someville', 'NY', '10001', 'USA'),
    ('789 Pine Ln', 'Othercity', 'TX', '75001', 'USA'),
    ('1011 Willow Rd', 'New Town', 'FL', '33001', 'USA'),
    ('1213 Cherry Ln', 'Old Town', 'GA', '30001', 'USA'),
    ('1415 Birch St', 'Greenville', 'NC', '27001', 'USA'),
    ('1617 Maple Rd', 'Lakeview', 'IL', '60001', 'USA'),
    ('1819 Rose Ave', 'Hillside', 'WA', '98001', 'USA'),
    ('2021 Daisy Ln', 'Riverton', 'AZ', '85001', 'USA'),
    ('2223 Tulip Rd', 'Desertview', 'NV', '89001', 'USA');

-- Insert sample customers
INSERT INTO customers (first_name, last_name, email, phone_number, address_id, created_at) VALUES
    ('John', 'Doe', 'john.doe@example.com', '555-123-4567', 1, '2024-01-01 10:00:00'),
    ('Jane', 'Smith', 'jane.smith@example.com', '555-987-6543', 2, '2024-01-05 12:00:00'),
    ('Robert', 'Jones', 'robert.jones@example.com', '555-234-5678', 3, '2024-01-10 14:00:00'),
    ('Emily', 'Brown', 'emily.brown@example.com', '555-789-0123', 4, '2024-01-15 16:00:00'),
    ('Michael', 'Davis', 'michael.davis@example.com', '555-345-6789', 5, '2024-01-20 18:00:00'),
    ('Jessica', 'Wilson', 'jessica.wilson@example.com', '555-456-7890', 6, '2024-01-25 20:00:00'),
    ('David', 'Garcia', 'david.garcia@example.com', '555-567-8901', 7, '2024-01-30 22:00:00'),
    ('Ashley', 'Rodriguez', 'ashley.rodriguez@example.com', '555-678-9012', 8, '2024-02-01 08:00:00'),
    ('Christopher', 'Lee', 'christopher.lee@example.com', '555-789-0123', 9, '2024-02-05 10:00:00'),
    ('Amanda', 'Perez', 'amanda.perez@example.com', '555-890-1234', 10, '2024-02-10 12:00:00');


-- Insert sample categories
INSERT INTO categories (category_name) VALUES
    ('Electronics'),
    ('Books'),
    ('Clothing'),
    ('Home Goods'),
    ('Toys');

-- Insert sample products
INSERT INTO products (product_name, description, price, category_id, created_at) VALUES
    ('Laptop', 'High performance laptop', 1200.00, 1, '2024-01-01 10:00:00'),
    ('Smartphone', 'Latest model smartphone', 800.00, 1, '2024-01-03 12:00:00'),
    ('Novel', 'A thrilling novel', 15.00, 2, '2024-01-05 14:00:00'),
    ('T-Shirt', 'Comfortable cotton t-shirt', 25.00, 3, '2024-01-07 16:00:00'),
    ('Sofa', 'Comfortable sofa for your living room', 500.00, 4, '2024-01-09 18:00:00'),
	('Puzzle', 'Brain teaser puzzle', 12.00, 5, '2024-01-11 20:00:00'),
    ('Tablet', '10 inch tablet', 300.00, 1, '2024-01-13 22:00:00'),
    ('Cookbook', 'Delicious recipes book', 22.00, 2, '2024-01-15 08:00:00'),
    ('Jeans', 'Classic fit jeans', 60.00, 3, '2024-01-17 10:00:00'),
    ('Lamp', 'Stylish table lamp', 40.00, 4, '2024-01-19 12:00:00'),
	('Action Figure', 'Super hero action figure', 18.00, 5, '2024-01-21 14:00:00'),
	('Headphones', 'Noise canceling headphones', 150.00, 1, '2024-01-23 16:00:00'),
    ('Biography', 'An insightful biography', 18.00, 2, '2024-01-25 18:00:00'),
    ('Dress', 'Elegant party dress', 80.00, 3, '2024-01-27 20:00:00'),
    ('Bed', 'Comfortable queen bed', 600.00, 4, '2024-01-29 22:00:00');


-- Insert sample inventory
INSERT INTO inventory (product_id, quantity_in_stock) VALUES
    (1, 100), (2, 150), (3, 200), (4, 300), (5, 50), (6, 400), (7, 120), (8, 250),
    (9, 180), (10, 70), (11, 220), (12, 90), (13, 280), (14, 110), (15, 60);


-- Insert sample orders
INSERT INTO orders (customer_id, order_date, total_amount, shipping_address_id, order_status) VALUES
    (1, '2024-01-02 10:00:00', 1225.00, 1, 'Shipped'),
    (2, '2024-01-06 12:00:00', 830.00, 2, 'Delivered'),
    (3, '2024-01-11 14:00:00', 525.00, 3, 'Pending'),
    (4, '2024-01-16 16:00:00', 625.00, 4, 'Processing'),
    (5, '2024-01-21 18:00:00', 120.00, 5, 'Cancelled'),
    (6, '2024-01-26 20:00:00', 1650.00, 6, 'Shipped'),
    (7, '2024-01-31 22:00:00', 250.00, 7, 'Delivered'),
    (8, '2024-02-02 08:00:00', 560.00, 8, 'Pending'),
    (9, '2024-02-06 10:00:00', 130.00, 9, 'Processing'),
    (10, '2024-02-11 12:00:00', 90.00, 10, 'Cancelled');


-- Insert sample order items
INSERT INTO order_items (order_id, product_id, quantity, price, created_at) VALUES
    (1, 1, 1, 1200.00, '2024-01-02 10:00:00'), (1, 4, 1, 25.00, '2024-01-02 10:05:00'),
    (2, 2, 1, 800.00, '2024-01-06 12:00:00'), (2, 3, 2, 15.00, '2024-01-06 12:05:00'),
    (3, 5, 1, 500.00, '2024-01-11 14:00:00'), (3, 3, 1, 15.00, '2024-01-11 14:05:00'),
    (4, 4, 1, 25.00, '2024-01-16 16:00:00'), (4, 10, 1, 40.00, '2024-01-16 16:05:00'), (4, 7, 1, 300.00, '2024-01-16 16:10:00'), (4, 6, 1, 12.00, '2024-01-16 16:15:00'), (4, 9, 3, 60.00, '2024-01-16 16:20:00'),
    (5, 6, 10, 12.00, '2024-01-21 18:00:00'),
    (6, 1, 1, 1200.00, '2024-01-26 20:00:00'), (6, 2, 1, 800.00, '2024-01-26 20:05:00'), (6, 15, 1, 600.00, '2024-01-26 20:10:00'),
    (7, 8, 1, 22.00, '2024-01-31 22:00:00'), (7, 12, 1, 150.00, '2024-01-31 22:05:00'), (7, 13, 1, 18.00, '2024-01-31 22:10:00'), (7, 14, 1, 80.00, '2024-01-31 22:15:00'),
    (8, 7, 1, 300.00, '2024-02-02 08:00:00'), (8, 4, 1, 25.00, '2024-02-02 08:05:00'), (8, 9, 1, 60.00, '2024-02-02 08:10:00'), (8, 10, 1, 40.00, '2024-02-02 08:15:00'), (8, 6, 1, 12.00, '2024-02-02 08:20:00'), (8, 11, 1, 18.00, '2024-02-02 08:25:00'),
	(9, 11, 1, 18.00, '2024-02-06 10:00:00'), (9, 4, 1, 25.00, '2024-02-06 10:05:00'), (9, 6, 1, 12.00, '2024-02-06 10:10:00'), (9, 8, 1, 22.00, '2024-02-06 10:15:00'),
    (10, 4, 1, 25.00, '2024-02-11 12:00:00'), (10, 6, 1, 12.00, '2024-02-11 12:05:00'), (10, 8, 1, 22.00, '2024-02-11 12:10:00');


-- Insert sample payment methods
INSERT INTO payment_methods (method_name) VALUES
    ('Credit Card'),
    ('Debit Card'),
    ('PayPal'),
    ('Cash'),
	('Gift Card');


-- Insert sample payments
INSERT INTO payments (order_id, payment_date, amount, payment_method_id, transaction_id) VALUES
    (1, '2024-01-02 11:00:00', 1225.00, 1, 'TXN123456'),
    (2, '2024-01-06 13:00:00', 830.00, 2, 'TXN789012'),
    (3, '2024-01-11 15:00:00', 525.00, 3, 'TXN345678'),
    (4, '2024-01-16 17:00:00', 625.00, 1, 'TXN901234'),
    (5, '2024-01-21 19:00:00', 120.00, 4, 'TXN567890'),
    (6, '2024-01-26 21:00:00', 1650.00, 3, 'TXN123457'),
	(7, '2024-01-31 23:00:00', 270.00, 5, 'TXN678902'),
    (8, '2024-02-02 09:00:00', 560.00, 2, 'TXN901235'),
    (9, '2024-02-06 11:00:00', 130.00, 1, 'TXN567891'),
    (10, '2024-02-11 13:00:00', 90.00, 4, 'TXN123458');


-- Insert sample shipments
INSERT INTO shipments (order_id, shipping_address_id, tracking_number, shipping_date, estimated_delivery_date, shipment_status) VALUES
    (1, 1, 'TRACK12345', '2024-01-03 10:00:00', '2024-01-07 10:00:00', 'Delivered'),
    (2, 2, 'TRACK67890', '2024-01-07 12:00:00', '2024-01-11 12:00:00', 'Delivered'),
    (3, 3, 'TRACK23456', '2024-01-12 14:00:00', '2024-01-16 14:00:00', 'Pending'),
    (4, 4, 'TRACK78901', '2024-01-17 16:00:00', '2024-01-21 16:00:00', 'Shipped'),
    (5, 5, 'TRACK34567', '2024-01-22 18:00:00', '2024-01-26 18:00:00', 'Cancelled'),
    (6, 6, 'TRACK89012', '2024-01-27 20:00:00', '2024-01-31 20:00:00', 'Shipped'),
    (7, 7, 'TRACK45678', '2024-02-01 22:00:00', '2024-02-05 22:00:00', 'Delivered'),
    (8, 8, 'TRACK90123', '2024-02-03 08:00:00', '2024-02-07 08:00:00', 'Pending'),
	(9, 9, 'TRACK56789', '2024-02-07 11:00:00', '2024-02-11 11:00:00', 'Processing'),
	(10, 10, 'TRACK01234', '2024-02-12 13:00:00', '2024-02-16 13:00:00', 'Cancelled');

-- Add more data to ensure decent distribution

-- Additional Addresses
INSERT INTO addresses (street_address, city, state, zip_code, country) VALUES
  ('2425 Maple St', 'Westville', 'NJ', '08093', 'USA'),
  ('2627 Oak Ln', 'Northport', 'NY', '11768', 'USA'),
  ('2829 Pine Ave', 'East Haven', 'CT', '06512', 'USA'),
  ('3031 Birch Rd', 'South Bend', 'IN', '46601', 'USA'),
  ('3233 Cedar Ln', 'Fayetteville', 'AR', '72701', 'USA'),
  ('3435 Willow St', 'Santa Fe', 'NM', '87501', 'USA'),
  ('3637 Elm Ave', 'Boulder', 'CO', '80301', 'USA'),
  ('3839 Rose Rd', 'Portland', 'OR', '97201', 'USA'),
  ('4041 Tulip Ln', 'Seattle', 'WA', '98101', 'USA'),
  ('4243 Daisy St', 'Austin', 'TX', '73301', 'USA');

-- Additional Customers
INSERT INTO customers (first_name, last_name, email, phone_number, address_id, created_at) VALUES
  ('Sarah', 'Miller', 'sarah.miller@example.com', '555-234-6789', 11, '2024-01-05 09:00:00'),
  ('Thomas', 'Anderson', 'thomas.anderson@example.com', '555-789-0123', 12, '2024-01-10 13:00:00'),
  ('Olivia', 'Thomas', 'olivia.thomas@example.com', '555-345-6789', 13, '2024-01-15 15:00:00'),
  ('James', 'Jackson', 'james.jackson@example.com', '555-456-7890', 14, '2024-01-20 17:00:00'),
  ('Ava', 'White', 'ava.white@example.com', '555-567-8901', 15, '2024-01-25 19:00:00'),
  ('William', 'Harris', 'william.harris@example.com', '555-678-9012', 16, '2024-01-30 21:00:00'),
  ('Isabella', 'Martin', 'isabella.martin@example.com', '555-789-0123', 17, '2024-02-01 07:00:00'),
  ('Ethan', 'Thompson', 'ethan.thompson@example.com', '555-890-1234', 18, '2024-02-05 11:00:00'),
  ('Mia', 'Garcia', 'mia.garcia@example.com', '555-901-2345', 19, '2024-02-10 13:00:00'),
  ('Alexander', 'Martinez', 'alexander.martinez@example.com', '555-012-3456', 20, '2024-02-15 16:00:00');

-- Additional Products
INSERT INTO products (product_name, description, price, category_id, created_at) VALUES
    ('Monitor', '27-inch curved monitor', 350.00, 1, '2024-01-03 11:00:00'),
    ('Mystery Book', 'Intriguing mystery novel', 16.00, 2, '2024-01-07 13:00:00'),
    ('Hoodie', 'Warm and cozy hoodie', 45.00, 3, '2024-01-11 15:00:00'),
    ('Dining Table', 'Elegant dining table for six', 700.00, 4, '2024-01-15 17:00:00'),
	('Robot Toy', 'Remote controlled robot', 50.00, 5, '2024-01-19 19:00:00'),
    ('Keyboard', 'Mechanical gaming keyboard', 120.00, 1, '2024-01-23 21:00:00'),
    ('Science Book', 'Fascinating science book', 24.00, 2, '2024-01-27 23:00:00'),
    ('Jacket', 'Stylish winter jacket', 120.00, 3, '2024-01-31 09:00:00'),
    ('Chair', 'Comfortable office chair', 180.00, 4, '2024-02-02 11:00:00'),
	('Car Toy', 'Miniature car set', 35.00, 5, '2024-02-06 13:00:00'),
    ('Mouse', 'Wireless gaming mouse', 60.00, 1, '2024-02-10 15:00:00'),
    ('History Book', 'Engaging history book', 28.00, 2, '2024-02-14 17:00:00'),
	('Sweater', 'Warm winter sweater', 55.00, 3, '2024-02-18 19:00:00'),
    ('Desk', 'Modern office desk', 250.00, 4, '2024-02-20 21:00:00'),
    ('Teddy Bear', 'Soft and cuddly teddy bear', 20.00, 5, '2024-02-22 23:00:00');
	
-- Additional Inventory
INSERT INTO inventory (product_id, quantity_in_stock) VALUES
  (16, 90), (17, 210), (18, 190), (19, 270), (20, 55), (21, 110), (22, 230),
  (23, 170), (24, 65), (25, 215), (26, 80), (27, 160), (28, 290), (29, 45),
  (30, 130);

-- Additional Orders
INSERT INTO orders (customer_id, order_date, total_amount, shipping_address_id, order_status) VALUES
  (11, '2024-01-07 10:00:00', 750.00, 11, 'Shipped'),
  (12, '2024-01-12 12:00:00', 155.00, 12, 'Delivered'),
  (13, '2024-01-17 14:00:00', 220.00, 13, 'Pending'),
  (14, '2024-01-22 16:00:00', 90.00, 14, 'Processing'),
  (15, '2024-01-27 18:00:00', 1200.00, 15, 'Cancelled'),
  (16, '2024-02-01 20:00:00', 325.00, 16, 'Shipped'),
  (17, '2024-02-06 22:00:00', 880.00, 17, 'Delivered'),
  (18, '2024-02-11 08:00:00', 180.00, 18, 'Pending'),
  (19, '2024-02-15 10:00:00', 75.00, 19, 'Processing'),
  (20, '2024-02-18 12:00:00', 285.00, 20, 'Cancelled');

-- Additional Order Items
INSERT INTO order_items (order_id, product_id, quantity, price, created_at) VALUES
  (11, 17, 1, 350.00, '2024-01-07 10:05:00'), (11, 21, 1, 120.00, '2024-01-07 10:10:00'), (11, 24, 1, 180.00, '2024-01-07 10:15:00'),
  (12, 16, 1, 16.00, '2024-01-12 12:05:00'), (12, 28, 1, 55.00, '2024-01-12 12:10:00'), (12, 30, 1, 20.00, '2024-01-12 12:15:00'),
  (13, 18, 1, 45.00, '2024-01-17 14:05:00'), (13, 26, 2, 28.00, '2024-01-17 14:10:00'),
  (14, 20, 2, 35.00, '2024-01-22 16:05:00'), (14, 29, 1, 250.00, '2024-01-22 16:10:00'),
  (15, 1, 1, 1200.00, '2024-01-27 18:05:00'),
  (16, 25, 1, 60.00, '2024-02-01 20:05:00'), (16, 27, 1, 120.00, '2024-02-01 20:10:00'), (16, 23, 1, 40.00, '2024-02-01 20:15:00'), (16, 19, 1, 50.00, '2024-02-01 20:20:00'), (16, 16, 1, 16.00, '2024-02-01 20:25:00'),
  (17, 22, 2, 24.00, '2024-02-06 22:05:00'), (17, 18, 1, 45.00, '2024-02-06 22:10:00'), (17, 24, 1, 180.00, '2024-02-06 22:15:00'), (17, 17, 1, 350.00, '2024-02-06 22:20:00'), (17, 30, 1, 20.00, '2024-02-06 22:25:00'), (17, 28, 1, 55.00, '2024-02-06 22:30:00'), (17, 19, 1, 50.00, '2024-02-06 22:35:00'),
  (18, 23, 1, 40.00, '2024-02-11 08:05:00'), (18, 26, 1, 28.00, '2024-02-11 08:10:00'), (18, 20, 1, 35.00, '2024-02-11 08:15:00'), (18, 28, 1, 55.00, '2024-02-11 08:20:00'),
  (19, 25, 1, 60.00, '2024-02-15 10:05:00'), (19, 16, 1, 16.00, '2024-02-15 10:10:00'),
  (20, 17, 1, 350.00, '2024-02-18 12:05:00'), (20, 29, 1, 250.00, '2024-02-18 12:10:00');



-- Additional Addresses
INSERT INTO addresses (street_address, city, state, zip_code, country) VALUES
    ('4445 Redwood Ln', 'Sunnyvale', 'CA', '94087', 'USA'),
    ('4647 Aspen Rd', 'Mountain View', 'CA', '94043', 'USA'),
    ('4849 Olive Ave', 'Palo Alto', 'CA', '94301', 'USA'),
    ('5051 Peach St', 'Cupertino', 'CA', '95014', 'USA'),
    ('5253 Lime Ln', 'Santa Clara', 'CA', '95050', 'USA'),
    ('5455 Walnut Rd', 'Los Gatos', 'CA', '95032', 'USA'),
    ('5657 Juniper Ave', 'Saratoga', 'CA', '95070', 'USA'),
    ('5859 Bay St', 'Alameda', 'CA', '94501', 'USA'),
    ('6061 Ocean Ln', 'Berkeley', 'CA', '94701', 'USA'),
    ('6263 Hill Rd', 'Oakland', 'CA', '94601', 'USA'),
    ('1301 Market St', 'Philadelphia', 'PA', '19107', 'USA'),
    ('250 E 87th St', 'New York', 'NY', '10128', 'USA'),
    ('111 W Monroe St', 'Chicago', 'IL', '60603', 'USA'),
    ('100 Congress Ave', 'Austin', 'TX', '78701', 'USA'),
    ('1600 Amphitheatre Pkwy', 'Mountain View', 'CA', '94043', 'USA'),
    ('1200 Peachtree St', 'Atlanta', 'GA', '30309', 'USA'),
    ('700 W Cesar Chavez St', 'Phoenix', 'AZ', '85007', 'USA'),
     ('800 Boylston St', 'Boston', 'MA', '02199', 'USA'),
    ('1901 W Spokane St', 'Seattle', 'WA', '98106', 'USA'),
    ('1000 SW Broadway', 'Portland', 'OR', '97205', 'USA'),
    ('1300 Pennsylvania Ave NW', 'Washington', 'DC', '20004', 'USA'),
    ('2100 Tulane Ave', 'New Orleans', 'LA', '70112', 'USA'),
    ('200 S Biscayne Blvd', 'Miami', 'FL', '33131', 'USA'),
    ('101 N Tryon St', 'Charlotte', 'NC', '28202', 'USA'),
    ('300 W 6th St', 'Cincinnati', 'OH', '45202', 'USA'),
    ('100 S 5th St', 'Minneapolis', 'MN', '55402', 'USA'),
     ('1500 Market St', 'Denver', 'CO', '80202', 'USA'),
    ('1300 Main St', 'Kansas City', 'MO', '64105', 'USA'),
     ('1100 N Market St', 'Dallas', 'TX', '75202', 'USA'),
    ('2500 Detroit Ave', 'Cleveland', 'OH', '44113', 'USA'),
    ('100 Public Square', 'Indianapolis', 'IN', '46204', 'USA'),
    ('1200 1st Ave S', 'Nashville', 'TN', '37203', 'USA'),
    ('200 S Orange Ave', 'Orlando', 'FL', '32801', 'USA'),
    ('300 N Main St', 'St. Louis', 'MO', '63103', 'USA'),
     ('500 Church St', 'Hartford', 'CT', '06103', 'USA'),
    ('100 S Main St', 'Salt Lake City', 'UT', '84101', 'USA'),
    ('1200 W 7th St', 'Los Angeles', 'CA', '90017', 'USA'),
	('200 E Main St', 'Louisville', 'KY', '40202', 'USA'),
	('1100 E Camelback Rd', 'Scottsdale', 'AZ', '85251', 'USA'),
    ('150 Fayetteville St', 'Raleigh', 'NC', '27601', 'USA');

-- Additional Customers
INSERT INTO customers (first_name, last_name, email, phone_number, address_id, created_at) VALUES
    ('Sophia', 'Wilson', 'sophia.wilson@example.com', '555-111-2222', 21, '2024-03-02 14:00:00'),
    ('Jackson', 'Taylor', 'jackson.taylor@example.com', '555-333-4444', 22, '2024-03-10 10:00:00'),
    ('Emma', 'Anderson', 'emma.anderson@example.com', '555-555-6666', 23, '2024-03-18 16:00:00'),
    ('Aiden', 'Thomas', 'aiden.thomas@example.com', '555-777-8888', 24, '2024-03-25 12:00:00'),
     ('Chloe', 'Hernandez', 'chloe.hernandez@example.com', '555-222-3333', 25, '2024-04-02 11:00:00'),
    ('Liam', 'Moore', 'liam.moore@example.com', '555-444-5555', 26, '2024-04-10 15:00:00'),
    ('Grace', 'Martin', 'grace.martin@example.com', '555-666-7777', 27, '2024-04-18 09:00:00'),
    ('Noah', 'Rodriguez', 'noah.rodriguez@example.com', '555-888-9999', 28, '2024-04-25 13:00:00'),
     ('Lily', 'Young', 'lily.young@example.com', '555-121-2323', 29, '2024-05-02 10:00:00'),
    ('Owen', 'King', 'owen.king@example.com', '555-343-4545', 30, '2024-05-10 14:00:00'),
    ('Zoe', 'Wright', 'zoe.wright@example.com', '555-565-6767', 31, '2024-05-18 12:00:00'),
    ('Carter', 'Lopez', 'carter.lopez@example.com', '555-787-8989', 32, '2024-05-25 16:00:00'),
     ('Scarlett', 'Hill', 'scarlett.hill@example.com', '555-434-5454', 33, '2024-06-02 11:00:00'),
    ('Daniel', 'Scott', 'daniel.scott@example.com', '555-656-7676', 34, '2024-06-10 15:00:00'),
    ('Ella', 'Green', 'ella.green@example.com', '555-878-9898', 35, '2024-06-18 13:00:00'),
    ('Lucas', 'Baker', 'lucas.baker@example.com', '555-232-3434', 36, '2024-06-25 17:00:00'),
    ('Avery', 'Adams', 'avery.adams@example.com', '555-909-1212', 37, '2024-07-02 12:00:00'),
    ('Caleb', 'Nelson', 'caleb.nelson@example.com', '555-454-5656', 38, '2024-07-10 16:00:00'),
    ('Madison', 'Carter', 'madison.carter@example.com', '555-787-9090', 39, '2024-07-18 10:00:00'),
    ('Ryan', 'Torres', 'ryan.torres@example.com', '555-323-4343', 40, '2024-07-25 14:00:00'),
     ('Addison', 'Mitchell', 'addison.mitchell@example.com', '555-989-8787', 41, '2024-08-02 11:00:00'),
    ('Elijah', 'Perez', 'elijah.perez@example.com', '555-434-6565', 42, '2024-08-10 15:00:00'),
     ('Natalie', 'Roberts', 'natalie.roberts@example.com', '555-676-7878', 43, '2024-08-18 13:00:00'),
    ('Samuel', 'Turner', 'samuel.turner@example.com', '555-121-2121', 44, '2024-08-25 17:00:00'),
     ('Leah', 'Phillips', 'leah.phillips@example.com', '555-767-6767', 45, '2024-09-02 10:00:00'),
    ('Gabriel', 'Campbell', 'gabriel.campbell@example.com', '555-212-1212', 46, '2024-09-10 14:00:00'),
     ('Brooklyn', 'Parker', 'brooklyn.parker@example.com', '555-656-5656', 47, '2024-09-18 12:00:00'),
    ('Julian', 'Evans', 'julian.evans@example.com', '555-878-7878', 48, '2024-09-25 16:00:00'),
    ('Audrey', 'Edwards', 'audrey.edwards@example.com', '555-232-2323', 49, '2024-10-02 11:00:00'),
    ('Logan', 'Collins', 'logan.collins@example.com', '555-454-4545', 50, '2024-10-10 15:00:00'),
    ('Savannah', 'Stewart', 'savannah.stewart@example.com', '555-767-7676', 51, '2024-10-18 13:00:00'),
    ('Jack', 'Flores', 'jack.flores@example.com', '555-565-5656', 52, '2024-10-25 17:00:00'),
    ('Claire', 'Morris', 'claire.morris@example.com', '555-232-3232', 53, '2024-11-02 10:00:00'),
    ('Owen', 'Murphy', 'owen.murphy@example.com', '555-787-7878', 54, '2024-11-10 14:00:00'),
     ('Lucy', 'Cook', 'lucy.cook@example.com', '555-656-5656', 55, '2024-11-18 12:00:00'),
    ('Henry', 'Rogers', 'henry.rogers@example.com', '555-878-8787', 56, '2024-11-25 16:00:00'),
    ('Nora', 'Gray', 'nora.gray@example.com', '555-454-4545', 57, '2024-12-02 11:00:00'),
    ('William', 'James', 'william.james@example.com', '555-212-2121', 58, '2024-12-10 15:00:00'),
    ('Eleanor', 'Watson', 'eleanor.watson@example.com', '555-767-7676', 59, '2024-12-18 13:00:00'),
     ('James', 'Brooks', 'james.brooks@example.com', '555-989-9898', 60, '2024-12-25 17:00:00');



-- Additional Products
INSERT INTO products (product_name, description, price, category_id, created_at) VALUES
    ('Smartwatch', 'Advanced smartwatch with fitness tracker', 280.00, 1, '2024-03-05 11:00:00'),
    ('Thriller', 'Suspenseful thriller novel', 17.00, 2, '2024-03-08 13:00:00'),
     ('Blouse', 'Elegant silk blouse', 70.00, 3, '2024-03-12 15:00:00'),
     ('Couch', 'Modern living room couch', 450.00, 4, '2024-03-16 17:00:00'),
    ('Board Game', 'Fun family board game', 30.00, 5, '2024-03-20 19:00:00'),
    ('Speaker', 'Portable Bluetooth speaker', 90.00, 1, '2024-03-24 21:00:00'),
    ('Poetry Book', 'Collection of classic poems', 20.00, 2, '2024-03-28 23:00:00'),
    ('Skirt', 'Stylish A-line skirt', 50.00, 3, '2024-03-30 09:00:00'),
    ('Table', 'Sturdy coffee table', 110.00, 4, '2024-04-04 11:00:00'),
     ('Doll', 'Collectible doll figure', 25.00, 5, '2024-04-08 13:00:00'),
     ('Charger', 'Wireless phone charger', 35.00, 1, '2024-04-12 15:00:00'),
    ('Short Stories', 'Collection of short stories', 21.00, 2, '2024-04-16 17:00:00'),
     ('Trousers', 'Formal business trousers', 90.00, 3, '2024-04-20 19:00:00'),
      ('Rug', 'Soft living room rug', 200.00, 4, '2024-04-24 21:00:00'),
    ('Building Blocks', 'Creative building blocks set', 38.00, 5, '2024-04-28 23:00:00'),
    ('Camera', 'Digital camera with 4K video', 600.00, 1, '2024-05-02 09:00:00'),
    ('Comic Book', 'Popular comic book series', 10.00, 2, '2024-05-06 11:00:00'),
    ('Coat', 'Warm winter coat', 150.00, 3, '2024-05-10 13:00:00'),
    ('Clock', 'Modern wall clock', 60.00, 4, '2024-05-14 15:00:00'),
    ('Stuffed Animal', 'Cute plush stuffed animal', 18.00, 5, '2024-05-18 17:00:00'),
	('Projector', 'Portable video projector', 400.00, 1, '2024-05-22 19:00:00'),
    ('Travel Guide', 'Detailed travel guide', 26.00, 2, '2024-05-26 21:00:00'),
     ('Hat', 'Stylish sun hat', 28.00, 3, '2024-05-30 23:00:00'),
     ('Mirror', 'Elegant wall mirror', 90.00, 4, '2024-06-03 09:00:00'),
    ('Toy Car', 'Remote-controlled toy car', 33.00, 5, '2024-06-07 11:00:00'),
    ('TV', '55-inch smart TV', 900.00, 1, '2024-06-11 13:00:00'),
    ('Art Book', 'Beautiful art book', 35.00, 2, '2024-06-15 15:00:00'),
    ('Socks', 'Comfortable cotton socks', 12.00, 3, '2024-06-19 17:00:00'),
     ('Plant', 'Indoor potted plant', 30.00, 4, '2024-06-23 19:00:00'),
    ('Toy Train', 'Classic toy train set', 70.00, 5, '2024-06-27 21:00:00'),
     ('Console', 'Gaming console', 450.00, 1, '2024-07-01 09:00:00'),
    ('Recipe Book', 'Gourmet recipes book', 32.00, 2, '2024-07-05 11:00:00'),
    ('Shoes', 'Comfortable walking shoes', 75.00, 3, '2024-07-09 13:00:00'),
    ('Vase', 'Decorative glass vase', 45.00, 4, '2024-07-13 15:00:00'),
    ('Action Toys', 'Action figure toy set', 29.00, 5, '2024-07-17 17:00:00'),
    ('Printer', 'Laser printer with scanner', 250.00, 1, '2024-07-21 19:00:00'),
     ('Encyclopedia', 'Comprehensive encyclopedia set', 55.00, 2, '2024-07-25 21:00:00'),
    ('Gloves', 'Warm winter gloves', 20.00, 3, '2024-07-29 23:00:00'),
     ('Cushions', 'Comfortable sofa cushions', 35.00, 4, '2024-08-02 09:00:00'),
    ('Puppets', 'Set of hand puppets', 15.00, 5, '2024-08-06 11:00:00'),
    ('Tablet', '10-inch tablet', 300.00, 1, '2024-08-10 13:00:00'),
    ('Dictionary', 'Detailed dictionary', 25.00, 2, '2024-08-14 15:00:00'),
     ('Scarf', 'Soft wool scarf', 30.00, 3, '2024-08-18 17:00:00'),
    ('Bedding', 'Comfortable bedding set', 120.00, 4, '2024-08-22 19:00:00'),
    ('Puzzles', 'Set of challenging puzzles', 22.00, 5, '2024-08-26 21:00:00'),
    ('VR Headset', 'Immersive VR headset', 350.00, 1, '2024-09-02 10:00:00'),
    ('Autobiography', 'Inspiring autobiography book', 23.00, 2, '2024-09-06 14:00:00'),
    ('Belt', 'Stylish leather belt', 25.00, 3, '2024-09-10 12:00:00'),
    ('Shelves', 'Modular wall shelves', 100.00, 4, '2024-09-14 16:00:00'),
    ('Model Kit', 'Model kit for enthusiasts', 40.00, 5, '2024-09-18 10:00:00'),
    ('Laptop Charger', 'Universal laptop charger', 50.00, 1, '2024-09-22 14:00:00'),
    ('Text Book', 'Comprehensive text book', 42.00, 2, '2024-09-26 12:00:00'),
    ('Sunglasses', 'Fashionable sunglasses', 40.00, 3, '2024-09-30 16:00:00'),
     ('Picture Frame', 'Elegant picture frame', 25.00, 4, '2024-10-04 10:00:00'),
    ('Building Blocks', 'Creative building blocks set', 38.00, 5, '2024-10-08 14:00:00'),
    ('Monitor', 'Curved monitor with high refresh rate', 450.00, 1, '2024-10-12 12:00:00'),
    ('Travel Book', 'Inspiring travel book', 30.00, 2, '2024-10-16 16:00:00'),
    ('Jumpsuit', 'Comfortable jumpsuit', 80.00, 3, '2024-10-20 10:00:00'),
    ('Desk Lamp', 'Modern desk lamp', 35.00, 4, '2024-10-24 14:00:00'),
    ('Musical Toys', 'Fun musical toy set', 55.00, 5, '2024-10-28 12:00:00'),
    ('Wireless Router', 'High speed wifi router', 80.00, 1, '2024-11-02 16:00:00'),
     ('Encyclopedia', 'Comprehensive encyclopedia set', 65.00, 2, '2024-11-06 10:00:00'),
    ('Underwear', 'Comfortable cotton underwear', 18.00, 3, '2024-11-10 14:00:00'),
    ('Blankets', 'Soft cozy blankets', 75.00, 4, '2024-11-14 12:00:00'),
    ('Doll House', 'Doll house set', 50.00, 5, '2024-11-18 16:00:00'),
    ('USB Drive', 'High-capacity USB drive', 20.00, 1, '2024-11-22 10:00:00'),
    ('Dictionary', 'Language dictionary', 30.00, 2, '2024-11-26 14:00:00'),
    ('Swimwear', 'Stylish summer swimwear', 45.00, 3, '2024-11-30 12:00:00'),
    ('Pillow', 'Comfortable sleeping pillow', 30.00, 4, '2024-12-04 16:00:00'),
    ('Toy Truck', 'Durable toy truck', 40.00, 5, '2024-12-08 10:00:00'),
    ('Smart Home Device', 'Smart home control device', 100.00, 1, '2024-12-12 14:00:00'),
    ('Novel', 'Intriguing mystery novel', 20.00, 2, '2024-12-16 12:00:00'),
    ('Winter Hat', 'Warm winter hat', 30.00, 3, '2024-12-20 16:00:00'),
    ('Lampshade', 'Stylish lampshade', 25.00, 4, '2024-12-24 10:00:00'),
     ('Toy Kit', 'Educational toy kit', 60.00, 5, '2024-12-28 14:00:00');


-- Additional Inventory
INSERT INTO inventory (product_id, quantity_in_stock) VALUES
  (31, 80), (32, 160), (33, 240), (34, 70), (35, 310), (36, 140), (37, 260), (38, 90), (39, 190), (40, 280),
  (41, 60), (42, 220), (43, 110), (44, 290), (45, 40), (46, 130), (47, 230), (48, 100), (49, 150), (50, 250),
  (51, 70), (52, 180), (53, 210), (54, 80), (55, 270), (56, 120), (57, 200), (58, 50), (59, 300), (60, 110),
    (61, 60), (62, 200), (63, 250), (64, 100), (65, 220), (66, 130), (67, 160), (68, 240), (69, 50), (70, 210),
    (71, 150), (72, 110), (73, 280), (74, 90), (75, 70), (76, 290), (77, 270), (78, 190), (79, 40), (80, 230),
    (81, 140), (82, 120), (83, 80), (84, 260), (85, 100), (86, 250), (87, 200), (88, 130), (89, 170), (90, 240);


-- Additional Orders (March-December 2024)
INSERT INTO orders (customer_id, order_date, total_amount, shipping_address_id, order_status) VALUES
    (21, '2024-03-04 14:00:00', 300.00, 21, 'Shipped'),
    (22, '2024-03-11 10:00:00', 500.00, 22, 'Delivered'),
    (23, '2024-03-19 16:00:00', 250.00, 23, 'Pending'),
    (24, '2024-03-26 12:00:00', 400.00, 24, 'Processing'),
    (25, '2024-04-03 11:00:00', 150.00, 25, 'Cancelled'),
    (26, '2024-04-11 15:00:00', 600.00, 26, 'Shipped'),
    (27, '2024-04-19 09:00:00', 180.00, 27, 'Delivered'),
    (28, '2024-04-26 13:00:00', 350.00, 28, 'Pending'),
    (29, '2024-05-03 10:00:00', 200.00, 29, 'Processing'),
    (30, '2024-05-11 14:00:00', 550.00, 30, 'Cancelled'),
    (31, '2024-05-19 12:00:00', 280.00, 31, 'Shipped'),
    (32, '2024-05-26 16:00:00', 480.00, 32, 'Delivered'),
    (33, '2024-06-03 11:00:00', 170.00, 33, 'Pending'),
     (34, '2024-06-11 15:00:00', 650.00, 34, 'Processing'),
     (35, '2024-06-19 13:00:00', 290.00, 35, 'Cancelled'),
    (36, '2024-06-26 17:00:00', 700.00, 36, 'Shipped'),
    (37, '2024-07-03 12:00:00', 300.00, 37, 'Delivered'),
    (38, '2024-07-11 16:00:00', 190.00, 38, 'Pending'),
    (39, '2024-07-19 10:00:00', 520.00, 39, 'Processing'),
    (40, '2024-07-26 14:00:00', 220.00, 40, 'Cancelled'),
     (41, '2024-08-03 11:00:00', 350.00, 41, 'Shipped'),
    (42, '2024-08-11 15:00:00', 580.00, 42, 'Delivered'),
    (43, '2024-08-19 13:00:00', 230.00, 43, 'Pending'),
     (44, '2024-08-26 17:00:00', 420.00, 44, 'Processing'),
     (45, '2024-09-03 10:00:00', 160.00, 45, 'Cancelled'),
    (46, '2024-09-11 14:00:00', 620.00, 46, 'Shipped'),
    (47, '2024-09-19 12:00:00', 260.00, 47, 'Delivered'),
     (48, '2024-09-26 16:00:00', 410.00, 48, 'Pending'),
     (49, '2024-10-03 11:00:00', 320.00, 49, 'Processing'),
    (50, '2024-10-11 15:00:00', 490.00, 50, 'Cancelled'),
     (51, '2024-10-19 13:00:00', 200.00, 51, 'Shipped'),
    (52, '2024-10-26 17:00:00', 570.00, 52, 'Delivered'),
    (53, '2024-11-03 10:00:00', 270.00, 53, 'Pending'),
    (54, '2024-11-11 14:00:00', 430.00, 54, 'Processing'),
    (55, '2024-11-19 12:00:00', 150.00, 55, 'Cancelled'),
    (56, '2024-11-26 16:00:00', 670.00, 56, 'Shipped'),
     (57, '2024-12-03 11:00:00', 280.00, 57, 'Delivered'),
    (58, '2024-12-11 15:00:00', 540.00, 58, 'Pending'),
    (59, '2024-12-19 13:00:00', 310.00, 59, 'Processing'),
    (60, '2024-12-26 17:00:00', 190.00, 60, 'Cancelled');

-- Additional Order Items (March-December 2024)
INSERT INTO order_items (order_id, product_id, quantity, price, created_at) VALUES
    (21, 31, 1, 280.00, '2024-03-04 14:05:00'), (21, 35, 1, 30.00, '2024-03-04 14:10:00'),
    (22, 32, 1, 17.00, '2024-03-11 10:05:00'), (22, 36, 1, 90.00, '2024-03-11 10:10:00'),(22, 38, 1, 50.00, '2024-03-11 10:15:00'),
    (23, 33, 1, 70.00, '2024-03-19 16:05:00'), (23, 39, 1, 110.00, '2024-03-19 16:10:00'),(23, 40, 1, 30.00, '2024-03-19 16:15:00'),
    (24, 34, 1, 450.00, '2024-03-26 12:05:00'), (24, 37, 1, 20.00, '2024-03-26 12:10:00'),
    (25, 41, 2, 35.00, '2024-04-03 11:05:00'), (25, 43, 1, 90.00, '2024-04-03 11:10:00'),
    (26, 42, 1, 21.00, '2024-04-11 15:05:00'),(26, 44, 1, 200.00, '2024-04-11 15:10:00'), (26, 45, 3, 38.00, '2024-04-11 15:15:00'),
    (27, 46, 1, 600.00, '2024-04-19 09:05:00'), (27, 47, 1, 10.00, '2024-04-19 09:10:00'), (27, 48, 1, 150.00, '2024-04-19 09:15:00'),
	(28, 49, 1, 60.00, '2024-04-26 13:05:00'), (28, 50, 1, 18.00, '2024-04-26 13:10:00'),(28, 51, 2, 400.00, '2024-04-26 13:15:00'),
    (29, 52, 1, 26.00, '2024-05-03 10:05:00'), (29, 53, 1, 28.00, '2024-05-03 10:10:00'),(29, 54, 1, 90.00, '2024-05-03 10:15:00'),
    (30, 55, 1, 33.00, '2024-05-11 14:05:00'), (30, 56, 1, 900.00, '2024-05-11 14:10:00'),(30, 57, 1, 35.00, '2024-05-11 14:15:00'),
    (31, 58, 1, 12.00, '2024-05-19 12:05:00'), (31, 59, 1, 30.00, '2024-05-19 12:10:00'),(31, 60, 1, 70.00, '2024-05-19 12:15:00'),
    (32, 61, 1, 450.00, '2024-05-26 16:05:00'), (32, 62, 1, 32.00, '2024-05-26 16:10:00'),
	(33, 63, 1, 75.00, '2024-06-03 11:05:00'), (33, 64, 1, 45.00, '2024-06-03 11:10:00'),
    (34, 65, 1, 29.00, '2024-06-11 15:05:00'), (34, 66, 2, 250.00, '2024-06-11 15:10:00'),
    (35, 67, 1, 55.00, '2024-06-19 13:05:00'), (35, 68, 1, 20.00, '2024-06-19 13:10:00'),
    (36, 69, 1, 350.00, '2024-06-26 17:05:00'), (36, 70, 1, 23.00, '2024-06-26 17:10:00'),(36, 71, 1, 25.00, '2024-06-26 17:15:00'),
	(37, 72, 1, 50.00, '2024-07-03 12:05:00'),(37, 73, 1, 100.00, '2024-07-03 12:10:00'), (37, 74, 1, 50.00, '2024-07-03 12:15:00'),
    (38, 75, 1, 50.00, '2024-07-11 16:05:00'),(38, 76, 1, 80.00, '2024-07-11 16:10:00'),
	(39, 77, 1, 400.00, '2024-07-19 10:05:00'),(39, 78, 1, 18.00, '2024-07-19 10:10:00'), (39, 79, 1, 40.00, '2024-07-19 10:15:00'),
    (40, 80, 1, 55.00, '2024-07-26 14:05:00'), (40, 81, 1, 40.00, '2024-07-26 14:10:00'),
     (41, 82, 1, 65.00, '2024-08-03 11:05:00'),(41, 83, 1, 40.00, '2024-08-03 11:10:00'),(41, 84, 1, 18.00, '2024-08-03 11:15:00'),
    (42, 85, 1, 300.00, '2024-08-11 15:05:00'), (42, 86, 1, 25.00, '2024-08-11 15:10:00'),(42, 87, 1, 30.00, '2024-08-11 15:15:00'),
    (43, 88, 1, 120.00, '2024-08-19 13:05:00'), (43, 89, 1, 22.00, '2024-08-19 13:10:00'),
     (44, 90, 1, 350.00, '2024-08-26 17:05:00'),(44, 44, 1, 200.00, '2024-08-26 17:10:00'),
     (45, 43, 1, 90.00, '2024-09-03 10:05:00'),(45, 45, 1, 38.00, '2024-09-03 10:10:00'),
    (46, 48, 1, 150.00, '2024-09-11 14:05:00'), (46, 47, 1, 10.00, '2024-09-11 14:10:00'),(46, 49, 1, 60.00, '2024-09-11 14:15:00'),
	(47, 50, 1, 18.00, '2024-09-19 12:05:00'),(47, 51, 1, 400.00, '2024-09-19 12:10:00'),
     (48, 52, 1, 26.00, '2024-09-26 16:05:00'), (48, 53, 1, 28.00, '2024-09-26 16:10:00'),
     (49, 54, 1, 90.00, '2024-10-03 11:05:00'),(49, 55, 1, 33.00, '2024-10-03 11:10:00'),
    (50, 56, 1, 900.00, '2024-10-11 15:05:00'),(50, 57, 1, 35.00, '2024-10-11 15:10:00'),
    (51, 58, 1, 12.00, '2024-10-19 13:05:00'), (51, 59, 1, 30.00, '2024-10-19 13:10:00'),(51, 60, 1, 70.00, '2024-10-19 13:15:00'),
	(52, 61, 1, 450.00, '2024-10-26 17:05:00'), (52, 62, 1, 32.00, '2024-10-26 17:10:00'),
    (53, 63, 1, 75.00, '2024-11-03 10:05:00'),(53, 64, 1, 45.00, '2024-11-03 10:10:00'),
	(54, 65, 1, 29.00, '2024-11-11 14:05:00'),(54, 66, 2, 250.00, '2024-11-11 14:10:00'),
    (55, 67, 1, 55.00, '2024-11-19 12:05:00'), (55, 68, 1, 20.00, '2024-11-19 12:10:00'),
    (56, 69, 1, 350.00, '2024-11-26 16:05:00'), (56, 70, 1, 23.00, '2024-11-26 16:10:00'),
    (57, 71, 1, 25.00, '2024-12-03 11:05:00'), (57, 72, 1, 50.00, '2024-12-03 11:10:00'),
	(58, 73, 1, 100.00, '2024-12-11 15:05:00'),(58, 74, 1, 50.00, '2024-12-11 15:10:00'),
	(59, 75, 1, 50.00, '2024-12-19 13:05:00'),(59, 76, 1, 80.00, '2024-12-19 13:10:00'),
    (60, 77, 1, 400.00, '2024-12-26 17:05:00'),(60, 78, 1, 18.00, '2024-12-26 17:10:00'),(60, 79, 1, 40.00, '2024-12-26 17:15:00');

-- Additional Payments (March-December 2024)
INSERT INTO payments (order_id, payment_date, amount, payment_method_id, transaction_id) VALUES
    (21, '2024-03-04 15:00:00', 300.00, 1, 'TXN234567'),
    (22, '2024-03-11 11:00:00', 500.00, 2, 'TXN345678'),
    (23, '2024-03-19 17:00:00', 250.00, 3, 'TXN456789'),
    (24, '2024-03-26 13:00:00', 400.00, 4, 'TXN567890'),
    (25, '2024-04-03 12:00:00', 150.00, 5, 'TXN678901'),
    (26, '2024-04-11 16:00:00', 600.00, 1, 'TXN789012'),
    (27, '2024-04-19 10:00:00', 180.00, 2, 'TXN890123'),
    (28, '2024-04-26 14:00:00', 350.00, 3, 'TXN901234'),
    (29, '2024-05-03 11:00:00', 200.00, 4, 'TXN012345'),
    (30, '2024-05-11 15:00:00', 550.00, 5, 'TXN123456'),
    (31, '2024-05-19 13:00:00', 280.00, 1, 'TXN234567'),
    (32, '2024-05-26 17:00:00', 480.00, 2, 'TXN345678'),
    (33, '2024-06-03 12:00:00', 170.00, 3, 'TXN456789'),
    (34, '2024-06-11 16:00:00', 650.00, 4, 'TXN567890'),
    (35, '2024-06-19 14:00:00', 290.00, 5, 'TXN678901'),
    (36, '2024-06-26 18:00:00', 700.00, 1, 'TXN789012'),
    (37, '2024-07-03 13:00:00', 300.00, 2, 'TXN890123'),
    (38, '2024-07-11 17:00:00', 190.00, 3, 'TXN901234'),
    (39, '2024-07-19 11:00:00', 520.00, 4, 'TXN012345'),
    (40, '2024-07-26 15:00:00', 220.00, 5, 'TXN123456'),
    (41, '2024-08-03 12:00:00', 350.00, 1, 'TXN234567'),
    (42, '2024-08-11 16:00:00', 580.00, 2, 'TXN345678'),
    (43, '2024-08-19 14:00:00', 230.00, 3, 'TXN456789'),
    (44, '2024-08-26 18:00:00', 420.00, 4, 'TXN567890'),
     (45, '2024-09-03 11:00:00', 160.00, 5, 'TXN678901'),
    (46, '2024-09-11 15:00:00', 620.00, 1, 'TXN789012'),
    (47, '2024-09-19 13:00:00', 260.00, 2, 'TXN890123'),
    (48, '2024-09-26 17:00:00', 410.00, 3, 'TXN901234'),
    (49, '2024-10-03 12:00:00', 320.00, 4, 'TXN012345'),
    (50, '2024-10-11 16:00:00', 490.00, 5, 'TXN123456'),
    (51, '2024-10-19 14:00:00', 200.00, 1, 'TXN234567'),
    (52, '2024-10-26 18:00:00', 570.00, 2, 'TXN345678'),
    (53, '2024-11-03 11:00:00', 270.00, 3, 'TXN456789'),
    (54, '2024-11-11 15:00:00', 430.00, 4, 'TXN567890'),
    (55, '2024-11-19 13:00:00', 150.00, 5, 'TXN678901'),
    (56, '2024-11-26 17:00:00', 670.00, 1, 'TXN789012'),
    (57, '2024-12-03 12:00:00', 280.00, 2, 'TXN890123'),
    (58, '2024-12-11 16:00:00', 540.00, 3, 'TXN901234'),
    (59, '2024-12-19 14:00:00', 310.00, 4, 'TXN012345'),
    (60, '2024-12-26 18:00:00', 190.00, 5, 'TXN123456');

-- Additional Shipments (March-December 2024)
INSERT INTO shipments (order_id, shipping_address_id, tracking_number, shipping_date, estimated_delivery_date, shipment_status) VALUES
    (21, 21, 'TRACK23456', '2024-03-05 14:00:00', '2024-03-09 14:00:00', 'Delivered'),
    (22, 22, 'TRACK34567', '2024-03-12 10:00:00', '2024-03-16 10:00:00', 'Delivered'),
    (23, 23, 'TRACK45678', '2024-03-20 16:00:00', '2024-03-24 16:00:00', 'Pending'),
    (24, 24, 'TRACK56789', '2024-03-27 12:00:00', '2024-03-31 12:00:00', 'Shipped'),
    (25, 25, 'TRACK67890', '2024-04-04 11:00:00', '2024-04-08 11:00:00', 'Cancelled'),
    (26, 26, 'TRACK78901', '2024-04-12 15:00:00', '2024-04-16 15:00:00', 'Shipped'),
    (27, 27, 'TRACK89012', '2024-04-20 09:00:00', '2024-04-24 09:00:00', 'Delivered'),
    (28, 28, 'TRACK90123', '2024-04-27 13:00:00', '2024-05-01 13:00:00', 'Pending'),
    (29, 29, 'TRACK01234', '2024-05-04 10:00:00', '2024-05-08 10:00:00', 'Processing'),
    (30, 30, 'TRACK12345', '2024-05-12 14:00:00', '2024-05-16 14:00:00', 'Cancelled'),
    (31, 31, 'TRACK23456', '2024-05-20 12:00:00', '2024-05-24 12:00:00', 'Shipped'),
    (32, 32, 'TRACK34567', '2024-05-27 16:00:00', '2024-05-31 16:00:00', 'Delivered'),
    (33, 33, 'TRACK45678', '2024-06-04 11:00:00', '2024-06-08 11:00:00', 'Pending'),
    (34, 34, 'TRACK56789', '2024-06-12 15:00:00', '2024-06-16 15:00:00', 'Processing'),
    (35, 35, 'TRACK67890', '2024-06-20 13:00:00', '2024-06-24 13:00:00', 'Cancelled'),
    (36, 36, 'TRACK78901', '2024-06-27 17:00:00', '2024-07-01 17:00:00', 'Shipped'),
    (37, 37, 'TRACK89012', '2024-07-04 12:00:00', '2024-07-08 12:00:00', 'Delivered'),
    (38, 38, 'TRACK90123', '2024-07-12 16:00:00', '2024-07-16 16:00:00', 'Pending'),
    (39, 39, 'TRACK01234', '2024-07-20 10:00:00', '2024-07-24 10:00:00', 'Processing'),
     (40, 40, 'TRACK12345', '2024-07-27 14:00:00', '2024-07-31 14:00:00', 'Cancelled'),
    (41, 41, 'TRACK23456', '2024-08-04 11:00:00', '2024-08-08 11:00:00', 'Shipped'),
    (42, 42, 'TRACK34567', '2024-08-12 15:00:00', '2024-08-16 15:00:00', 'Delivered'),
    (43, 43, 'TRACK45678', '2024-08-20 13:00:00', '2024-08-24 13:00:00', 'Pending'),
    (44, 44, 'TRACK56789', '2024-08-27 17:00:00', '2024-08-31 17:00:00', 'Processing'),
    (45, 45, 'TRACK67890', '2024-09-04 10:00:00', '2024-09-08 10:00:00', 'Cancelled'),
    (46, 46, 'TRACK78901', '2024-09-12 14:00:00', '2024-09-16 14:00:00', 'Shipped'),
    (47, 47, 'TRACK89012', '2024-09-20 12:00:00', '2024-09-24 12:00:00', 'Delivered'),
    (48, 48, 'TRACK90123', '2024-09-27 16:00:00', '2024-10-01 16:00:00', 'Pending'),
    (49, 49, 'TRACK01234', '2024-10-04 11:00:00', '2024-10-08 11:00:00', 'Processing'),
    (50, 50, 'TRACK12345', '2024-10-12 15:00:00', '2024-10-16 15:00:00', 'Cancelled'),
    (51, 51, 'TRACK23456', '2024-10-20 13:00:00', '2024-10-24 13:00:00', 'Shipped'),
    (52, 52, 'TRACK34567', '2024-10-27 17:00:00', '2024-10-31 17:00:00', 'Delivered'),
	(53, 53, 'TRACK45678', '2024-11-04 10:00:00', '2024-11-08 10:00:00', 'Pending'),
    (54, 54, 'TRACK56789', '2024-11-12 14:00:00', '2024-11-16 14:00:00', 'Processing'),
    (55, 55, 'TRACK67890', '2024-11-20 12:00:00', '2024-11-24 12:00:00', 'Cancelled'),
    (56, 56, 'TRACK78901', '2024-11-27 16:00:00', '2024-12-01 16:00:00', 'Shipped'),
    (57, 57, 'TRACK89012', '2024-12-04 11:00:00', '2024-12-08 11:00:00', 'Delivered'),
    (58, 58, 'TRACK90123', '2024-12-12 15:00:00', '2024-12-16 15:00:00', 'Pending'),
    (59, 59, 'TRACK01234', '2024-12-20 13:00:00', '2024-12-24 13:00:00', 'Processing'),
    (60, 60, 'TRACK12345', '2024-12-27 17:00:00', '2024-12-31 17:00:00', 'Cancelled');