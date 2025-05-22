BEGIN TRANSACTION;

-- Таблицы, свзяанные с покупателями

CREATE TABLE customer_countries (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50)
);

CREATE TABLE pet_types (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50)
);

CREATE TABLE pet_breeds (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50)
);

CREATE TABLE pets (
    id SERIAL PRIMARY KEY,
    type_id BIGINT REFERENCES pet_types(id),
    name VARCHAR(50),
    breed_id BIGINT REFERENCES pet_breeds(id)
);

CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    age INTEGER,
    email VARCHAR(50),
    country_id BIGINT REFERENCES customer_countries(id),
    postal_code VARCHAR(50),
    pet_id BIGINT REFERENCES pets(id)
);


-- Таблицы, связанные с продавцами

CREATE TABLE seller_countries (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50)
);

CREATE TABLE sellers (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(50),
    country_id BIGINT REFERENCES seller_countries(id),
    postal_code VARCHAR(50)
);


-- Таблицы, связанные с продуктами

CREATE TABLE product_categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50)
);

CREATE TABLE product_pet_categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50)
);

CREATE TABLE product_colors (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50)
);

CREATE TABLE product_sizes (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50)
);

CREATE TABLE product_materials (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50)
);

CREATE TABLE product_physical_attributes (
    id SERIAL PRIMARY KEY,
    weight REAL,
    color_id BIGINT REFERENCES product_colors(id),
    size_id BIGINT REFERENCES product_sizes(id),
    material_id BIGINT REFERENCES product_materials(id)
);

CREATE TABLE product_reviews (
    id SERIAL PRIMARY KEY,
    rating REAL,
    reviews INTEGER
);

CREATE TABLE product_dates (
    id SERIAL PRIMARY KEY,
    release_date DATE,
    expiry_date DATE
);

CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    category_id BIGINT REFERENCES product_categories(id),
    pet_category_id BIGINT REFERENCES product_pet_categories(id),
    physical_attributes_id BIGINT REFERENCES product_physical_attributes(id),
    review_id BIGINT REFERENCES product_reviews(id),
    dates_id BIGINT REFERENCES product_dates(id),
    price REAL,
    quantity INTEGER,
    brand VARCHAR(50),
    description VARCHAR(1024)
);


-- Таблицы, связанные с магазинами

CREATE TABLE store_countries (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50)
);

CREATE TABLE store_locations (
    id SERIAL PRIMARY KEY,
    address VARCHAR(50),
    city VARCHAR(50),
    state VARCHAR(50),
    country_id BIGINT REFERENCES store_countries(id)
);

CREATE TABLE store_contacts (
    id SERIAL PRIMARY KEY,
    phone VARCHAR(50),
    email VARCHAR(50)
);

CREATE TABLE stores (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    location_id BIGINT REFERENCES store_locations(id),
    contacts_id BIGINT REFERENCES store_contacts(id)
);


-- Таблицы, связанные с поставщиками
CREATE TABLE supplier_contacts (
    id SERIAL PRIMARY KEY,
    phone VARCHAR(50),
    email VARCHAR(50)
);

CREATE TABLE supplier_countries (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50)
);

CREATE TABLE supplier_locations (
    id SERIAL PRIMARY KEY,
    address VARCHAR(50),
    city VARCHAR(50),
    country_id BIGINT REFERENCES supplier_countries(id)
);

CREATE TABLE suppliers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    contact_name VARCHAR(50),
    contacts_id BIGINT REFERENCES supplier_contacts(id),
    location_id BIGINT REFERENCES supplier_locations(id)
);


-- Финальная таблицы с фактами

CREATE TABLE sales (
    id SERIAL PRIMARY KEY
    customer_id BIGINT REFERENCES customers(id),
    seller_id BIGINT REFERENCES sellers(id),
    product_id BIGINT REFERENCES products(id),
    store_id BIGINT REFERENCES stores(id),
    supplier_id BIGINT REFERENCES suppliers(id),
    date DATE,
    quantity INTEGER,
    total_price REAL
);

COMMIT;