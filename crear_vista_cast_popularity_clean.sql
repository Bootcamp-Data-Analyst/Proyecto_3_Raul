-- Crear vista de elenco y popularidad de actores por película
CREATE OR REPLACE VIEW vista_cast_popularity_clean AS
SELECT
	-- Seleccionamos el ID del actor
    a.actor_id,
    -- Normalización de nombres de actores a minúsculas
    LOWER(a.first_name) AS first_name,
    LOWER(a.last_name) AS last_name,
    
    -- Columna derivada con nombre completo del actor
    CONCAT(LOWER(a.first_name), ' ', LOWER(a.last_name)) AS actor_full_name,
    
    -- Información de la película
    f.film_id,
    f.title,
    
    -- Número de actores en la misma película
    COUNT(a.actor_id) OVER (PARTITION BY f.film_id) AS actors_per_film,
    
    -- Número de películas en las que participa cada actor
    COUNT(f.film_id) OVER (PARTITION BY a.actor_id) AS films_per_actor

FROM actor a
    -- Join con tabla intermedia para relacionar actores con películas
    JOIN film_actor fa ON a.actor_id = fa.actor_id
    -- Join con tabla film para obtener información de cada película
    JOIN film f ON fa.film_id = f.film_id

-- Eliminar duplicados de la combinación actor + película
-- (por si algún actor aparece más de una vez en film_actor)
GROUP BY
    a.actor_id,
    a.first_name,
    a.last_name,
    f.film_id,
    f.title;

-- Mostrar la vista completa al ejecutarla
SELECT * FROM vista_cast_popularity_clean;
