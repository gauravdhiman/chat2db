CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    phone VARCHAR(20)
);

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    description TEXT,
    price DECIMAL(10, 2),
    stock_quantity INTEGER
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INTEGER REFERENCES customers(customer_id),
    order_date DATE,
    total_amount DECIMAL(10, 2)
);

CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INTEGER REFERENCES orders(order_id),
    product_id INTEGER REFERENCES products(product_id),
    quantity INTEGER,
    unit_price DECIMAL(10, 2)
);

-- Populate tables with sample data
INSERT INTO customers (first_name, last_name, email, phone)
SELECT
    'Customer' || i AS first_name,
    'Lastname' || i AS last_name,
    'customer' || i || '@example.com' AS email,
    '555-' || LPAD(i::text, 4, '0') AS phone
FROM generate_series(1, 1000) i;

INSERT INTO products (product_name, description, price, stock_quantity)
SELECT
    'Product ' || i AS product_name,
    'Description for Product ' || i AS description,
    (random() * 1000 + 1)::numeric(10,2) AS price,
    (random() * 1000 + 1)::int AS stock_quantity
FROM generate_series(1, 500) i;

INSERT INTO orders (customer_id, order_date, total_amount)
SELECT
    (random() * 999 + 1)::int AS customer_id,
    current_date - (random() * 365)::int AS order_date,
    (random() * 10000 + 1)::numeric(10,2) AS total_amount
FROM generate_series(1, 10000) i;

INSERT INTO order_items (order_id, product_id, quantity, unit_price)
SELECT
    (random() * 9999 + 1)::int AS order_id,
    (random() * 499 + 1)::int AS product_id,
    (random() * 10 + 1)::int AS quantity,
    (random() * 1000 + 1)::numeric(10,2) AS unit_price
FROM generate_series(1, 50000) i;

-- Create indexes for better performance
CREATE INDEX idx_orders_customer_id ON orders(customer_id);
CREATE INDEX idx_order_items_order_id ON order_items(order_id);
CREATE INDEX idx_order_items_product_id ON order_items(product_id);

-- Update orders total_amount based on order_items
UPDATE orders o
SET total_amount = (
    SELECT SUM(quantity * unit_price)
    FROM order_items oi
    WHERE oi.order_id = o.order_id
);