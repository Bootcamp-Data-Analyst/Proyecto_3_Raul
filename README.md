## Objetivo

Limpiar y analizar la actividad de clientes de Sakila usando SQL y Python. Al final, tener un dataset limpio y visualizaciones que ayuden a entender cómo alquilan y pagan los clientes.

## Qué hay en el repositorio

* `sql_scripts/`: SQL para crear vistas y limpiar datos preliminarmente.
* `notebook/`: Notebook de Python con limpieza final, análisis y gráficos.

## SQL

* Hicimos tres vistas:

  1. **Customer Activity** → info y pagos de clientes
  2. **Film Catalog** → info de películas
  3. **Cast Popularity** → actores y cuántas películas hacen
* Limpieza que aplicamos:

  * Quitar filas con `NULL` en fechas o pagos.
  * Filtrar fechas raras (`rental_date < return_date`) y pagos ≤ 0.
  * Poner todo en minúsculas (nombres, emails, ciudades…).
  * Columnas extras: rentals totales, pagos totales, duración promedio, películas largas, nombre completo de actores, etc.
* JOINs bien hechos, sin duplicar datos importantes.

## Python

* Trabajamos con **Customer Activity**.
* Limpieza: fechas a datetime, chequear duplicados, valores faltantes, tipos correctos, normalizar cadenas, detectar outliers.
* Columnas derivadas: `avg_payment_per_rental`.
* Visualizaciones: boxplots, mapas mundiales (clientes, rentals y pagos) y top 10 países por pagos.

## Cómo usarlo

1. Clonar repo.
2. Ejecutar los SQL para crear vistas.
3. Exportar vista `customer_activity_clean` a CSV para importarlo en Colab.
4. Abrir notebook en Colab y correr las celdas.

## Decisiones importantes

* Prioridad: datos consistentes y completos.
* SQL: limpieza preliminar y columnas derivadas.
* Python: limpieza final, métricas agregadas por país.


