-- Usar la base de datos sakila
USE sakila;

-- Crear una vista limpia del catálogo de películas
CREATE OR REPLACE VIEW vista_film_catalog_clean AS
SELECT
    -- ID único de la película
    f.film_id,
    
    -- Normalización de texto: título y descripción en minúsculas y sin espacios extra
    LOWER(TRIM(f.title)) AS title,
    LOWER(TRIM(f.description)) AS description,
    
    -- Duración de la película en minutos
    f.length,
    
    -- Normalización de rating en minúsculas
    LOWER(f.rating) AS rating,
    
    -- Idioma de la película, normalizado
    LOWER(l.name) AS language,
    
    -- Nombre de categoría, normalizado
    LOWER(c.name) AS category,
    
    -- Conteo de copias disponibles por película (Aunque hay 0 en algunas películas, el conteo es correcto 
    -- y no se pierden entradas relevantes para otro tipo de analisis, como cantidad de peliculas por categoria.
    COUNT(i.inventory_id) AS copies_available,
    
    -- Columna derivada: indica si la película es larga (>= 120 min)
    CASE WHEN f.length >= 120 THEN 1 ELSE 0 END AS is_long_film

FROM film f
-- Unimos con tabla de idiomas
JOIN language l ON f.language_id = l.language_id
-- Unimos con la tabla de categorías
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
-- Unimos con inventario para contar copias (LEFT JOIN para incluir films sin inventario)
LEFT JOIN inventory i ON f.film_id = i.film_id

-- Filtrado de calidad de datos
WHERE f.length > 0           -- Eliminar películas con duración <= 0
  AND f.rating IS NOT NULL   -- Eliminar películas sin rating

-- Agrupamos por todas las columnas de film y normalizadas
GROUP BY f.film_id, f.title, f.description, f.length, f.rating, l.name, c.name;

-- SELECT final para mostrar la vista directamente al ejecutar el script
SELECT * FROM vista_film_catalog_clean;
