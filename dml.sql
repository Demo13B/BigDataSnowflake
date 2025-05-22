BEGIN TRANSACTION;

-- Страны покупателей
INSERT INTO customer_countries (name)
SELECT DISTINCT customer_country
FROM mock_data
WHERE customer_country is not NULL;


-- Типы питомцев
INSERT INTO pet_types (name)
SELECT DISTINCT customer_pet_type
FROM mock_data
WHERE customer_pet_type is not NULL;


-- Породы питомцев
INSERT INTO pet_breeds (name)
SELECT DISTINCT customer_pet_breed
FROM mock_data
WHERE customer_pet_breed is not NULL;


-- Питомцы
INSERT INTO pets (type_id, name, breed_id)
SELECT DISTINCT
    pt.id,
    md.customer_pet_name,
    pb.id
FROM mock_data md
JOIN pet_types pt ON md.customer_pet_type = pt.name
JOIN pet_breeds pb ON md.customer_pet_breed = pb.name
WHERE customer_pet_name is not NULL;


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
        cc.id as country_id,
        md.customer_postal_code as postal_code,
        pf.id as pet_id
    FROM mock_data md
    JOIN customer_countries cc ON md.customer_country = cc.name
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


-- Страны продавцов
INSERT INTO seller_countries (name)
SELECT DISTINCT seller_country
FROM mock_data
WHERE seller_country is not NULL;


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
    sc.id,
    md.seller_postal_code
FROM mock_data md
JOIN seller_countries sc ON md.seller_country = sc.name;


-- Цвета
INSERT INTO product_colors (name)
SELECT DISTINCT product_color
FROM mock_data
WHERE product_color is not NULL;


-- Размеры
INSERT INTO product_sizes (name)
SELECT DISTINCT product_size
FROM mock_data
WHERE product_color is not NULL;


-- Материалы
INSERT INTO product_materials (name)
SELECT DISTINCT product_material
FROM mock_data;
WHERE product_material is not NULL;


-- Физические аттрибуты


COMMIT;