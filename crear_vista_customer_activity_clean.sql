-- Usamos la DB de sakila
USE sakila;

-- Creamos una vista que contiene la actividad de los clientes
CREATE OR REPLACE VIEW vista_customer_activity_clean AS

SELECT
    -- Información básica del cliente en minúsculas (LOWER)
    c.customer_id,
    LOWER(c.first_name) AS first_name,
    LOWER(c.last_name) AS last_name,
    LOWER(c.email) AS email,
    c.active,
    
    -- Información de la dirección en minúsculas
    LOWER(a.address) AS address,
    LOWER(a.district) AS district,
    a.postal_code,
    LOWER(ci.city) AS city,
    LOWER(co.country) AS country,
    
    -- Métricas de actividad del cliente
    COUNT(DISTINCT r.rental_id) AS total_rentals,       -- Total de rentals realizados por el cliente
    SUM(p.amount) AS total_payments,                   -- Suma de todos los pagos asociados
    MIN(r.rental_date) AS first_rental,               -- Fecha del primer rental
    MAX(r.rental_date) AS last_rental,                -- Fecha del último rental
    AVG(DATEDIFF(r.return_date, r.rental_date)) AS avg_rental_duration  -- Duración promedio de rentals
    
FROM customer c
-- Unimos con la tabla de direcciones
JOIN address a ON c.address_id = a.address_id
-- Unimos con ciudad y país para obtener ubicación completa
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id
-- Unimos con rentals del cliente (LEFT JOIN para incluir clientes aunque no tengan rentals)
LEFT JOIN rental r ON c.customer_id = r.customer_id
-- Unimos con los pagos asociados a cada rental
LEFT JOIN payment p ON r.rental_id = p.rental_id

-- Filtrado de calidad de datos
WHERE r.rental_date IS NOT NULL                  -- Solo rentals con fecha válida
  AND r.return_date IS NOT NULL                  -- Solo rentals con fecha de devolución válida
  AND r.rental_date < r.return_date             -- Aseguramos que la fecha de rental es menor que la devolución
  AND p.amount > 0                               -- Solo pagos mayores a cero

-- Agrupamos por cliente y sus datos personales
GROUP BY c.customer_id, c.first_name, c.last_name, c.email, c.active,
         a.address, a.district, a.postal_code, ci.city, co.country;
         
-- Seleccionamos la vista creada

SELECT * FROM vista_customer_activity_clean;
