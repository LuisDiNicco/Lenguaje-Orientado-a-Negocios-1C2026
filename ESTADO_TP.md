# Estado del Trabajo Práctico Integrador (Grupo 4)

Este documento detalla el progreso actual del TP contra los requerimientos de la consigna oficial, basándonos en lo extraído de los apuntes de la materia (Miel).

## 1. Copybooks (Estructuras de Datos) - `[100%]`
- [x] `LIBROS` - Estructura de datos de libros
- [x] `USUARIO` - Estructura de datos de usuarios
- [x] `PRESTAMO` - Estructura de préstamos
- [x] `CONSTANT` - Constantes del sistema
- [x] `MENSAJES` - Mensajes de error e info
- [x] `LINREP` - Layouts de reportes

## 2. Programas Batch (Procesamiento en Lotes) - `[25%]`
- [x] **CARGINI (Carga Inicial de Libros)**: Código COBOL armado (Lectura CSV, Reportes, Validaciones). *Falta implementar inserción SQL DB2*.
- [ ] **USUMANT (Mantenimiento de Usuarios)**: Falta crear (Procesa Altas/Bajas/Modificaciones desde archivo).
- [ ] **PRESTAM (Procesamiento de Préstamos)**: Falta crear (Valida reglas de negocio, stock, actualiza tablas).
- [ ] **REPORTES (Generación de Reportes)**: Falta crear (Estadísticas, libros prestados).

## 3. Programas CICS (Pantallas e Interfaces) - `[0%]`
- [ ] **BIBMENU (Menú Principal)**: Falta crear (Pantalla BMS + Programa CICS para enrutamiento). *Nota: Hay una referencia (CMENU) en el PDF de apuntes, pero requiere adaptación*.
- [ ] **BIBCONS (Consulta de Libros)**: Falta crear (Pantalla BMS + Programa CICS con paginación).
- [ ] **BIBPRES (Préstamos y Devoluciones)**: Falta crear (Pantalla BMS + Programa CICS).

## 4. Base de Datos DB2 - `[0%]`
- [ ] **Scripts DDL**: Falta crear los `CREATE TABLE` para `USUARIOS`, `LIBROS`, `PRESTAMOS`.
- [ ] **Scripts DML**: Falta crear scripts de inserción de datos base (opcional).

## 5. JCL (Ejecución y Compilación) - `[0%]`
- [ ] JCL para compilar programas COBOL+DB2 Batch
- [ ] JCL para compilar programas COBOL+DB2+CICS
- [ ] JCL para ejecutar programas Batch (`CARGINI`, etc.)

---
**Nota:** El programa `CARGINI` tiene marcados los sectores con comentarios `TODO:` indicando dónde deberán inyectarse las sentencias SQL (`EXEC SQL ... END-EXEC`) una vez que se dicte la clase de DB2.
