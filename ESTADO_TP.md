# ESTADO DEL TRABAJO PRÁCTICO INTEGRADOR FINAL
## Sistema de Gestión de Biblioteca Universitaria - Grupo 4 (KC02814)

**Leyenda de estado:**
- `[x]` Completado y validado
- `[-]` Parcialmente implementado (estructura lista, lógica incompleta)
- `[ ]` No implementado

---

## 1. PROGRAMAS BATCH

### 1.1 CARGINI - Carga Inicial de Libros `[-]`
- [x] Estructura COBOL (4 divisiones, columnas, SELECT, FD, WORKING-STORAGE)
- [x] Lectura secuencial PERFORM UNTIL (patrón PDF 08)
- [x] EXEC SQL INCLUDE SQLCA + host variables COMP-3
- [x] EXEC SQL INSERT INTO KC02814.LIBROS con 12 columnas
- [x] EXEC SQL COMMIT post-INSERT
- [x] Control SQLCODE con mensajes de error
- [x] Reporte paginado con cabecera/detalle/totales (WRITE FROM, AFTER ADVANCING)
- [x] File status checks en OPEN/READ/CLOSE
- [x] Archivo datos de prueba: 50 libros en DATOS_LIBROS.csv
- `[-]` **TODO:** Validar código único antes del INSERT (SELECT previo)
- `[-]` **TODO:** Validar año entre 1900 y 2100 (solo se valida NUMERIC)
- `[-]` **TODO:** Validar stock > 0 (solo se valida NUMERIC)
- `[-]` **TODO:** El formato de entrada es fixed-width pero DATOS_LIBROS.csv es comma-separated

### 1.2 USUMANT - Mantenimiento de Usuarios `[-]`
- [x] Estructura COBOL completa
- [x] PERFORM UNTIL con lectura secuencial
- [x] EXEC SQL INCLUDE SQLCA + host variables
- [x] PROCESAR-ALTA: SELECT email único previo + INSERT + COMMIT
- [x] PROCESAR-BAJA: UPDATE estado='B' + fecha_baja + COMMIT
- [x] PROCESAR-MODIFICACION: UPDATE datos + COMMIT
- [x] Validación tipo usuario (E/D/A)
- [x] Validación formato email (contiene @)
- [x] Validación campos obligatorios no vacíos
- [x] Reporte paginado
- [x] Archivo datos: 31 altas + 3 modif + 2 bajas
- `[-]` **TODO:** PROCESAR-MODIFICACION no valida que el nuevo email no esté duplicado por otro usuario (SELECT WHERE EMAIL=X AND CODIGO<>Y)

### 1.3 PRESTAM - Procesamiento de Préstamos `[-]`
- [x] Estructura COBOL completa
- [x] PERFORM UNTIL con EVALUATE TRUE para tipo transacción (P/D)
- [x] EXEC SQL INCLUDE SQLCA + host variables COMP-3 declaradas
- [x] Subrutinas definidas con PERFORM encadenado (VALIDAR-USUARIO, VALIDAR-LIBRO, etc.)
- [x] Constantes de negocio disponibles via COPY CONSTANT
- [x] Reporte paginado
- [x] Archivo datos: 118 transacciones (préstamos y devoluciones)
- `[ ]` **TODO:** VALIDAR-USUARIO: SELECT para verificar existencia y estado activo
- `[ ]` **TODO:** VALIDAR-USUARIO: verificar que no tenga préstamos vencidos
- `[ ]` **TODO:** VALIDAR-LIBRO: SELECT para verificar existencia, estado activo y stock > 0
- `[ ]` **TODO:** VALIDAR-TOPE-USUARIO: SELECT COUNT(*) préstamos activos vs CONST-MAX-LIBROS
- `[ ]` **TODO:** CALCULAR-FECHAS-PRESTAMO: sumar días según tipo usuario (15/20/30)
- `[ ]` **TODO:** BUSCAR-PRESTAMO-PENDIENTE: SELECT préstamo activo para devolución
- `[ ]` **TODO:** CALCULAR-MULTA: diferencia de fechas × CONST-MULTA-DIA
- `[ ]` **TODO:** REGISTRAR-PRESTAMO-DB2: INSERT PRESTAMOS + UPDATE LIBROS stock -1 + COMMIT
- `[ ]` **TODO:** REGISTRAR-DEVOLUCION-DB2: UPDATE PRESTAMOS + UPDATE LIBROS stock +1 + COMMIT

### 1.4 REPORTES - Generación de Reportes `[-]`
- [x] Estructura COBOL completa
- [x] EXEC SQL INCLUDE SQLCA
- [x] Host variables declaradas para los 4 reportes
- [x] 4 subrutinas de reporte definidas (PERFORM)
- [x] Consultas SQL completas en comentarios (SELECT con JOIN, GROUP BY, ORDER BY)
- [x] Reporte formateado con WRITE FROM
- `[ ]` **TODO:** Implementar EXEC SQL DECLARE/OPEN/FETCH/CLOSE para cada cursor
- `[ ]` **TODO:** Escribir líneas de detalle formateadas en cada FETCH loop
- `[ ]` **TODO:** Leer parámetros de fecha (WS-FECHA-DESDE, WS-FECHA-HASTA) - la consigna pide "parámetros de fechas" como entrada
- `[ ]` **TODO:** Los 4 reportes incrementan WS-CONT-REPORTES-GEN sin generar salida real

---

## 2. PROGRAMAS CICS

### 2.1 BIBMENU - Menú Principal `[-]`
- [x] Programa CICS con EVALUATE EIBAID (ENTER, CLEAR, PF3)
- [x] EXEC CICS SEND MAP / RECEIVE MAP
- [x] BMS con 5 opciones visibles: 1-Consultas, 2-Usuarios, 3-Préstamos, 4-Reportes, X-Salir
- [x] XCTL a BIBCONS (opción 1) y BIBPRES (opción 3)
- [x] Mensajes informativos para opciones batch (2 y 4)
- [x] TERMINAR-TRANSACCION con SEND TEXT + RETURN
- `[-]` **TODO:** Las opciones 2 y 4 no llaman a ningún programa (es correcto: son batch)
- `[ ]` **TODO:** No se valida que la opción ingresada no esté vacía antes del EVALUATE

### 2.2 BIBCONS - Consulta de Libros `[-]`
- [x] Programa CICS con EVALUATE EIBAID
- [x] BMS con 4 campos de búsqueda (CODIGO, TITULO, AUTOR, CATEG)
- [x] BMS con 10 líneas de resultados (MENSAJE1..MENSAJE10)
- [x] PF7/PF8 para paginación (anterior/siguiente)
- [x] EXEC SQL INCLUDE SQLCA + host variables
- [x] Estructura para paginación (DCL-PAGINA-ACTUAL, DCL-TOTAL-RESULTADOS)
- `[ ]` **TODO:** RECEIVE MAP para leer los campos de búsqueda ingresados
- `[ ]` **TODO:** Construir WHERE dinámico con los campos no vacíos
- `[ ]` **TODO:** EXEC SQL DECLARE CURSOR con la consulta construida
- `[ ]` **TODO:** EXEC SQL OPEN / FETCH 10 rows / CLOSE
- `[ ]` **TODO:** Poblar MENSAJE1O..MENSAJE10O con los datos del FETCH
- `[ ]` **TODO:** EXEC SQL SELECT COUNT(*) para calcular total de páginas
- `[ ]` **TODO:** Lógica real de paginación (calcular offset, límites de página)

### 2.3 BIBPRES - Préstamos y Devoluciones `[-]`
- [x] Programa CICS con EVALUATE EIBAID
- [x] BMS con campos: TRATIPO (P/D), USUCODIGO, CODCODIGO, MSG
- [x] EXEC CICS RECEIVE MAP con validación DFHRESP(NORMAL)
- [x] EVALUATE TRUE para préstamo vs devolución
- [x] EXEC SQL INCLUDE SQLCA + host variables
- `[ ]` **TODO:** PROCESAR-PRESTAMO-CICS: validar usuario existe y activo
- `[ ]` **TODO:** PROCESAR-PRESTAMO-CICS: validar libro existe, activo y con stock
- `[ ]` **TODO:** PROCESAR-PRESTAMO-CICS: validar tope préstamos por tipo usuario
- `[ ]` **TODO:** PROCESAR-PRESTAMO-CICS: verificar no tenga libros vencidos
- `[ ]` **TODO:** PROCESAR-PRESTAMO-CICS: INSERT PRESTAMOS + UPDATE stock -1 + COMMIT
- `[ ]` **TODO:** PROCESAR-DEVOLUCION-CICS: buscar préstamo pendiente
- `[ ]` **TODO:** PROCESAR-DEVOLUCION-CICS: calcular multa si aplica
- `[ ]` **TODO:** PROCESAR-DEVOLUCION-CICS: UPDATE PRESTAMOS + UPDATE stock +1 + COMMIT

---

## 3. BASE DE DATOS DB2 `[-]`

- [x] DDL_TABLAS.sql: CREATE TABLESPACE G4USU, G4LIB, G4PRE IN UNLAM
- [x] DDL_TABLAS.sql: CREATE TABLE USUARIOS (10 cols, PK, CK, UNIQUE INDEX)
- [x] DDL_TABLAS.sql: CREATE TABLE LIBROS (12 cols, PK, CK)
- [x] DDL_TABLAS.sql: CREATE TABLE PRESTAMOS (9 cols, PK, 2 FK, CK)
- [x] DDL_TABLAS.sql: 5 índices adicionales para búsquedas
- [x] DDL_TABLAS.sql: CREATE SEQUENCE SEQ_PRESTAMOS
- [x] DDL_TABLAS.sql: GRANT permissions
- `[-]` **TODO:** Triggers de auditoría no implementados (opcionales según consigna)
- `[-]` **TODO:** No hay script DML con datos de prueba para insertar directamente

---

## 4. JCL `[-]`

- [x] COMPCOB.jcl: IGYWCLG para COBOL puro (CICS)
- [x] COMPDB2.jcl: DSNHPC + IGYCRCTL + IEWL para COBOL+DB2
- [x] RUNBATCH.jcl: ejecución batch genérica con ENTRADA/NOVEDAD/TRANSAC/REPORTE
- [x] BINDRUN.jcl: BIND PLAN (DSN SYSTEM DBDG) + ejecución
- [x] RUNSQL.jcl: IKJEFT01 + DSNTEP2 con STEPLIB correcto (DSND10.*) y PLAN(DSNTEP13)
- [x] DROPALL.jcl: eliminación en orden FK→PK→SEQ
- `[-]` **TODO:** DDs en RUNBATCH.jcl y BINDRUN.jcl están comentados (//*). Deben descomentarse según programa.
- `[-]` **TODO:** COMPCOB.jcl usa IGYWCLG (compile+link+go). Para CICS debería usarse IGYWCL sin GO step.

---

## 5. COPYBOOKS `[x]`

- [x] LIBROS: 01 LIBRO-RECORD con 12 campos + 3 88-levels (A/I/B)
- [x] USUARIO: 01 USUARIO-RECORD con 10 campos + 5 88-levels (E/D/A, A/I/B)
- [x] PRESTAMO: 01 PRESTAMO-RECORD con 9 campos + 3 88-levels (P/D/V)
- [x] CONSTANT: reglas negocio (3/15, 10/30, 5/20, $50/día) + parámetros reportes
- [x] MENSAJES: 8 errores + 4 informativos
- [x] LINREP: cabeceras, separador, títulos, detalle libros, totales (133 chars)

---

## 6. MAPAS BMS `[x]`

- [x] BIBMENU: 5 opciones (1-4, X), campo OPCION, área mensajes, PF3/ENTER
- [x] BIBCONS: 4 campos búsqueda, cabecera resultados, 10 líneas, PF3/PF7/PF8
- [x] BIBPRES: tipo (P/D), código usuario, código libro, área mensajes, PF3/ENTER

---

## 7. DATOS DE PRUEBA `[x]`

- [x] DATOS_LIBROS.csv: 50 libros, 14 categorías distintas
- [x] DATOS_USUARIOS.csv: 31 altas + 3 modificaciones + 2 bajas (E/D/A)
- [x] DATOS_PRESTAMOS.csv: 118 transacciones (préstamos P + devoluciones D) en junio 2026

---

## 8. RESUMEN DE PENDIENTES (TODOs en código)

| # | Archivo | Descripción | Prioridad |
|---|---------|-------------|-----------|
| 1 | PRESTAM.CBL | Implementar 8 subrutinas de validación y DB2 | ALTA |
| 2 | REPORTES.CBL | Implementar 4 cursores DB2 con OPEN/FETCH/CLOSE | ALTA |
| 3 | BIBCONS.CBL | Implementar búsqueda DB2 con WHERE dinámico y paginación | ALTA |
| 4 | BIBPRES.CBL | Implementar validación DB2 en tiempo real | ALTA |
| 5 | CARGINI.CBL | Agregar validación código único, año, stock > 0 | MEDIA |
| 6 | USUMANT.CBL | Validar email único en modificación | MEDIA |
| 7 | JCLs | Descomentar DDs en RUNBATCH y BINDRUN | MEDIA |
| 8 | REPORTES.CBL | Agregar entrada de parámetros de fecha | MEDIA |
| 9 | DATOS_LIBROS.csv | Convertir CSV a fixed-width o modificar parsing COBOL | BAJA |
| 10 | DDL_TABLAS.sql | Agregar triggers de auditoría (opcional) | BAJA |
