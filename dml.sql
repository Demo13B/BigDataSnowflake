BEGIN TRANSACTION;

-- Страны 
INSERT INTO countries (name)
SELECT DISTINCT customer_country as name
FROM mock_data
UNION
SELECT DISTINCT seller_country as name
FROM mock_data
UNION
SELECT DISTINCT store_country as name
FROM mock_data
UNION
SELECT DISTINCT supplier_country as name
FROM mock_data;


-- Типы питомцев
INSERT INTO pet_types (name)
SELECT DISTINCT customer_pet_type
FROM mock_data;


-- Породы питомцев
INSERT INTO pet_breeds (name)
SELECT DISTINCT customer_pet_breed
FROM mock_data;


-- Питомцы
INSERT INTO pets (type_id, name, breed_id)
SELECT DISTINCT
    pt.id,
    md.customer_pet_name,
    pb.id
FROM mock_data md
JOIN pet_types pt ON md.customer_pet_type = pt.name
JOIN pet_breeds pb ON md.customer_pet_breed = pb.name;


-- Покупатели
WITH pets_full as (
    SELECT
        p.id,
        pt.name as type,
        p.name,
        pb.name as breed
    FROM pets p
    JOIN pet_types pt ON p.type_id = pt.id
    JOIN pet_breeds pb ON p.breed_id = pb.id
),
customers_to_insert as (
    SELECT DISTINCT
        md.customer_first_name as first_name,
        md.customer_last_name as last_name,
        md.customer_age as age,
        md.customer_email as email, 
        c.id as country_id,
        md.customer_postal_code as postal_code,
        pf.id as pet_id
    FROM mock_data md
    JOIN countries c ON md.customer_country = c.name
    JOIN pets_full pf ON md.customer_pet_name = pf.name AND
                         md.customer_pet_type = pf.type AND
                         md.customer_pet_breed = pf.breed
)
INSERT INTO customers (
    first_name,
    last_name,
    age,
    email,
    country_id,
    postal_code,
    pet_id
)
SELECT
    first_name,
    last_name,
    age,
    email,
    country_id,
    postal_code,
    pet_id
FROM customers_to_insert;


-- Продвавцы
INSERT INTO sellers (
    first_name,
    last_name,
    email,
    country_id,
    postal_code
)
SELECT DISTINCT
    md.seller_first_name,
    md.seller_last_name,
    md.seller_email,
    c.id,
    md.seller_postal_code
FROM mock_data md
JOIN countries c ON md.seller_country = c.name;


-- Цвета
INSERT INTO product_colors (name)
SELECT DISTINCT product_color
FROM mock_data;


-- Размеры
INSERT INTO product_sizes (name)
SELECT DISTINCT product_size
FROM mock_data;


-- Материалы
INSERT INTO product_materials (name)
SELECT DISTINCT product_material
FROM mock_data;


-- Физические аттрибуты
INSERT INTO product_physical_attributes (
    weight,
    color_id,
    size_id,
    material_id
)
SELECT DISTINCT
    md.product_weight,
    pc.id as color_id,
    ps.id as size_id,
    pm.id as material_id
FROM mock_data md
JOIN product_colors pc ON md.product_color = pc.name
JOIN product_sizes ps ON md.product_size = ps.name
JOIN product_materials pm ON md.product_material = pm.name;


-- Категории товаров
INSERT INTO product_categories (name)
SELECT DISTINCT product_category
FROM mock_data;


-- Даты товаров
INSERT INTO product_dates (release_date, expiry_date)
SELECT DISTINCT product_release_date, product_expiry_date
FROM mock_data;


-- Категории питомцев товара
INSERT INTO product_pet_categories (name)
SELECT DISTINCT pet_category
FROM mock_data;


-- Отзывы
INSERT INTO product_reviews (rating, reviews)
SELECT DISTINCT product_rating, product_reviews
FROM mock_data;


-- Товары
WITH physical_attributes_full as (
    SELECT
        ppa.id as physical_attributes_id,
        ppa.weight,
        pc.name as color,
        ps.name as size,
        pm.name as material
    FROM product_physical_attributes ppa
    JOIN product_colors pc ON ppa.color_id = pc.id
    JOIN product_sizes ps ON ppa.size_id = ps.id
    JOIN product_materials pm ON ppa.material_id = pm.id
), products_to_insert as (
    SELECT DISTINCT
        md.product_name as name,
        pc.id as category_id,
        ppc.id as pet_category_id,
        paf.physical_attributes_id,
        pr.id as review_id,
        pd.id as dates_id,
        md.product_price as price,
        md.product_quantity as quantity,
        md.product_brand as brand,
        md.product_description as description
    FROM mock_data md
    JOIN product_categories pc ON md.product_category = pc.name
    JOIN product_pet_categories ppc ON md.pet_category = ppc.name
    JOIN physical_attributes_full paf ON md.product_weight = paf.weight AND
                                         md.product_color = paf.color AND
                                         md.product_size = paf.size AND
                                         md.product_material = paf.material
    JOIN product_reviews pr ON md.product_rating = pr.rating AND
                               md.product_reviews = pr.reviews
    JOIN product_dates pd ON md.product_release_date = pd.release_date AND
                             md.product_expiry_date = pd.expiry_date
)
INSERT INTO products (
    name,
    category_id,
    pet_category_id,
    physical_attributes_id,
    review_id,
    dates_id,
    price,
    quantity,
    brand,
    description
)
SELECT
    name,
    category_id,
    pet_category_id,
    physical_attributes_id,
    review_id,
    dates_id,
    price,
    quantity,
    brand,
    description
FROM products_to_insert;


-- Контакты
INSERT INTO contacts (phone, email)
SELECT store_phone, store_email
FROM mock_data
UNION
SELECT supplier_phone, supplier_email
FROM mock_data;


-- Локации
INSERT INTO locations (
    address,
    city,
    state,
    country_id
)
SELECT
    md.store_location,
    md.store_city,
    md.store_state,
    c.id as country_id
FROM mock_data md
JOIN countries c ON md.store_country = c.name
UNION
SELECT
    md.supplier_address,
    md.supplier_city,
    '' as supplier_state,
    c.id as country_id
FROM mock_data md
JOIN countries c ON md.supplier_country = c.name;


-- Магазины
WITH locations_full as (
    SELECT
        l.id,
        l.address,
        l.city,
        l.state,
        c.name as country
    FROM locations l
    JOIN countries c ON l.country_id = c.id
)
INSERT INTO stores (name, location_id, contacts_id)
SELECT DISTINCT
    md.store_name as name,
    lf.id as location_id,
    c.id as contacts_id
FROM mock_data md
JOIN locations_full lf ON md.store_location = lf.address AND
                          md.store_city = lf.city AND
                          md.store_state = lf.state AND
                          md.store_country = lf.country
JOIN contacts c ON md.store_phone = c.phone AND
                   md.store_email = c.email;



COMMIT;