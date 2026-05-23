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

Este repositorio mantiene una copia local sincronizada 1 a 1 con los Datasets del Mainframe para desarrollo colaborativo. Al tener exactamente los mismos nombres, se facilita la subida mediante Zowe.

| Carpeta Local (Dataset) | Descripción |
| :--- | :--- |
| `KC02814.GRUPO4.COBOL.SOURCE/` | Código fuente de los programas COBOL (Batch y CICS) |
| `KC02814.GRUPO4.COBOL.COPYLIB/` | Copybooks (estructuras de datos compartidas) |
| `KC02814.GRUPO4.BMS.SOURCE/` | Mapas de pantalla para interfaces CICS |
| `KC02814.GRUPO4.JCL.SOURCE/` | Scripts de control de ejecución y compilación |
| `KC02814.GRUPO4.SQL.SOURCE/` | Scripts DDL/DML de base de datos DB2 |
| `KC02814.GRUPO4.DATA.INPUT/` | Archivos CSV y datos de entrada secuenciales |
| `KC02814.GRUPO4.LOAD.LIBRARY/` | Módulos ejecutables compilados |
| `KC02814.GRUPO4.REPORTES.OUTPUT/`| Reportes de salida generados por procesos Batch |
