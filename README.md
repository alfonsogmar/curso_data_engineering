# Proyecto final del curso de Data Engineering de Cívica Software

Este repositorio contiene el proyecto final del curso de Data Engineering de 172 horas de duración impartido presencialmente por Cívica Software en sus oficinas.

Se trata de un proyecto de **dbt** con todas las transformaciones necesarias implementadas en scripts de SQL para procesar los datos procedentes de diversas tablas en Snowflake, previamente cargados/extraídos/ingestados desde fuentes distintas (una hoja de Google Sheets y una base de datos SQL Server).

Las transformaciones se estructuran desiguiendo una arquitectura Medallion, de forma que:
* La capa Bronze (*sources*, archivos `yaml`) define las fuentes de datos, que son las tablas de origen con los datos "en crudo" almacenados en Snowflake
* La capa Silver (*staging*, scripts `SQL`) implementa la limpieza, filtrado y demás transformaciones básicas preliminares como cambios de nombres de columnas, cálculos sencillos para cambios de divisa, etc.
* La capa Gold (*marts*, scripts `SQL`) implementa las transformaciones finales que implican *joins* y agregaciones, con el fin de generar las tablas necesarias para cada caso de uso, los *data marts*

Tecnologías usadas:
* dbt
* SQL (scripts de transformaciones)
* yaml (metadatos y definición de sources)
* Snowflake (para el data warehouse subyacente que contiened tanto las tablas de origen como las nuevas tablas con datos transformados en las capas gold y silver)

-------------------------------------

# Cívica Software's Data Engineering course final project

This repository contains the final proyect for the on-site, 172-hours-long Data Engineering course by Cívica Software.

The source code consists of a **dbt** project with all necessary transformations -implemented in SQL scripts- to process data loaded/extracted/ingested from different sources (a Google Sheets spreadsheet and an SQL Server database) and stored in Snowflake tables. 

The transformations have been implemented following a Medallion architecture:
* The Bronze layer (*sources*, `yaml` files) defines the source Snowflake tables that contain the raw data
* The Silver layer (*staging*, `SQL` scripts) implements the data cleansing and filtering, as well as other basic preliminary transformations such as column name changes, currency conversions, etc. 
* The Gold layer (*marts*, `SQL` scripts) implements bigger transformations that involve joins and aggregations to generate the data marts, which are the final curated tables for every use case 

Used technologies:
* dbt
* SQL (transformations scripts)
* yaml (metadata & sources definition)
* Snowflake (underliying cloud data warehouse with all source and output tables)
