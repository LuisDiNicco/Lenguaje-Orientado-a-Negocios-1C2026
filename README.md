# Trabajo Práctico Integrador Final
## Sistema de Gestión de Biblioteca Universitaria

**Universidad Nacional de La Matanza (UNLaM) - DIIT**  
**Asignatura:** Electiva I - Lenguaje Orientado A Negocios (COBOL)  
**Cuatrimestre:** 1C 2026  

### Docentes
- Ing. Adrian Gabriel Gonzalez
- Franco Ruggieri

### Grupo 4 - Integrantes
- Ivan Antonioli
- Luis Di Nicco
- Leonardo Barbaro
- Ailen Padilla

---

## Descripción del Proyecto

Sistema completo de gestión de biblioteca universitaria desarrollado utilizando tecnologías Mainframe (IBM z/OS). El proyecto integra todos los conocimientos adquiridos en el curso, simulando un ambiente real de trabajo.

### Funcionalidades Principales
- **Gestión de Préstamos:** Registro, devoluciones, validaciones de stock y cálculo de multas.
- **Control de Usuarios:** Alta, baja y modificación de estudiantes, docentes y administrativos.
- **Inventario de Libros:** Carga inicial masiva y consultas con paginación interactiva.
- **Reportes Estadísticos:** Generación de métricas de uso y control.

### Tecnologías Utilizadas
- **Lenguaje:** COBOL Enterprise
- **Plataforma:** IBM z/OS Mainframe
- **Base de Datos:** DB2 (SQL)
- **Interfaz:** CICS (Pantallas interactivas BMS)
- **Control de Trabajos:** JCL

---

## Estructura del Repositorio Local

Este repositorio mantiene una copia local sincronizada de los Datasets del Mainframe para desarrollo colaborativo.

| Carpeta Local | Dataset en Mainframe | Descripción |
| :--- | :--- | :--- |
| `COBOL/SOURCE/` | `KC02814.GRUPO4.COBOL.SOURCE` | Código fuente de los programas COBOL (Batch y CICS) |
| `COBOL/COPYLIB/` | `KC02814.GRUPO4.COBOL.COPYLIB` | Copybooks (estructuras de datos compartidas) |
| `BMS/` | `KC02814.GRUPO4.BMS.SOURCE` | Mapas de pantalla para interfaces CICS |
| `JCL/` | `KC02814.GRUPO4.JCL.SOURCE` | Scripts de control de ejecución y compilación |
| `SQL/` | `KC02814.GRUPO4.SQL.SOURCE` | Scripts DDL/DML de base de datos DB2 |
| `DATA/` | `KC02814.GRUPO4.DATA.INPUT` | Archivos CSV y datos de entrada secuenciales |
