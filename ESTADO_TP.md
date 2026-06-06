# ESTADO DEL TRABAJO PRÁCTICO INTEGRADOR FINAL
## Sistema de Gestión de Biblioteca Universitaria - Grupo 4 (KC02814)

**Leyenda de estado:**
- `[x]` Completado
- `[-]` Parcial (estructura lista, lógica pendiente)
- `[ ]` No implementado

---

## 1. PROGRAMAS BATCH

### 1.1 CARGINI - Carga Inicial de Libros `[-]`
- [x] Estructura COBOL (4 divisiones, SOURCE-COMPUTER, SELECT, FD, WORKING-STORAGE)
- [x] Parseo CSV real con `UNSTRING DELIMITED BY ','` + detección y skip de header
- [x] Lectura secuencial `PERFORM UNTIL WS-FIN-ARCHIVO-SI`
- [x] `EXEC SQL INCLUDE SQLCA` + host variables `COMP-3` para columnas `DECIMAL`
- [x] `EXEC SQL INSERT INTO KC02814.LIBROS` (12 columnas) + control `SQLCODE`
- [x] `EXEC SQL COMMIT` post-INSERT exitoso
- [x] Reporte paginado con `WRITE FROM`, cabecera/detalle/totales, 133 chars, `RECORDING MODE F`
- [x] Flujo de error: registros con `SQLCODE != 0` no se cuentan como procesados ni se escriben al reporte
- [x] Archivo datos: 50 libros en `DATOS_LIBROS.csv` (CSV con header)
- `[ ]` **TODO:** Validar código único con `SELECT` previo al INSERT (`CARGINI.CBL:238`)
- `[ ]` **TODO:** Validar año entre 1900-2100 y stock > 0 (solo se valida `NUMERIC`) (`CARGINI.CBL:236-237`)

### 1.2 USUMANT - Mantenimiento de Usuarios `[-]`
- [x] Estructura COBOL completa con `SOURCE-COMPUTER`
- [x] Parseo CSV real con `UNSTRING DELIMITED BY ','` + detección y skip de header
- [x] `PERFORM UNTIL WS-FIN-ARCHIVO-SI` con lectura secuencial
- [x] `EXEC SQL INCLUDE SQLCA` + host variables
- [x] `PROCESAR-ALTA`: `SELECT` email único previo + `INSERT` + `COMMIT`
- [x] `PROCESAR-BAJA`: `UPDATE` estado='B' + `COMMIT`
- [x] `PROCESAR-MODIFICACION`: `UPDATE` datos + `COMMIT`
- [x] Validación tipo usuario (E/D/A)
- [x] Validación formato email (`INSPECT TALLYING` para `@`)
- [x] Validación campos obligatorios (código, nombre, apellido)
- [x] Reporte paginado con `WRITE FROM` para totales
- [x] Archivo datos: 31 altas + 3 modificaciones + 2 bajas en `DATOS_USUARIOS.csv`
- `[ ]` **TODO:** `PROCESAR-MODIFICACION`: validar que el nuevo email no pertenezca a otro usuario (`USUMANT.CBL:362-369`)
- `[ ]` **TODO:** `ESCRIBIR-DETALLE`: escribir líneas de detalle al reporte, no solo incrementar contador (`USUMANT.CBL:421-425`)

### 1.3 PRESTAM - Procesamiento de Préstamos `[-]`
- [x] Estructura COBOL completa con `SOURCE-COMPUTER`
- [x] Parseo CSV real con `UNSTRING DELIMITED BY ','` + detección y skip de header
- [x] `PERFORM UNTIL` con `EVALUATE TRUE` para tipo transacción (P/D)
- [x] `EXEC SQL INCLUDE SQLCA` + host variables `COMP-3`
- [x] 8 subrutinas de validación definidas con `PERFORM` encadenado
- [x] Constantes de negocio disponibles via `COPY CONSTANT`
- [x] Reporte paginado
- [x] Archivo datos: 118 transacciones en `DATOS_PRESTAMOS.csv`
- `[ ]` **TODO:** `VALIDAR-USUARIO`: SELECT existencia/estado activo + sin préstamos vencidos
- `[ ]` **TODO:** `VALIDAR-LIBRO`: SELECT existencia/estado activo/stock > 0
- `[ ]` **TODO:** `VALIDAR-TOPE-USUARIO`: SELECT COUNT vs `CONST-MAX-LIBROS-*`
- `[ ]` **TODO:** `CALCULAR-FECHAS-PRESTAMO`: sumar 15/20/30 días según tipo con `FUNCTION INTEGER-OF-DATE`
- `[ ]` **TODO:** `BUSCAR-PRESTAMO-PENDIENTE`: SELECT préstamo activo
- `[ ]` **TODO:** `CALCULAR-MULTA`: diferencia fechas × `CONST-MULTA-DIA`
- `[ ]` **TODO:** `REGISTRAR-PRESTAMO-DB2`: `INSERT PRESTAMOS` + `UPDATE LIBROS` stock -1 + `COMMIT`
- `[ ]` **TODO:** `REGISTRAR-DEVOLUCION-DB2`: `UPDATE PRESTAMOS` + `UPDATE LIBROS` stock +1 + `COMMIT`

### 1.4 REPORTES - Generación de Reportes `[-]`
- [x] Estructura COBOL completa con `SOURCE-COMPUTER`
- [x] `EXEC SQL INCLUDE SQLCA` + `COPY USUARIO` + `COPY PRESTAMO`
- [x] Host variables declaradas para los 4 reportes
- [x] 4 subrutinas `PERFORM`: más prestados, morosos, mensuales, inventario
- [x] Consultas SQL completas en comentarios (`SELECT` con `JOIN`, `GROUP BY`, `ORDER BY`)
- [x] Reporte formateado con `WRITE FROM`, cabecera paginada
- `[ ]` **TODO:** `EXEC SQL DECLARE/OPEN/FETCH/CLOSE` para cada cursor
- `[ ]` **TODO:** Escribir líneas de detalle formateadas en cada loop
- `[ ]` **TODO:** Leer parámetros de fecha (`WS-FECHA-DESDE`, `WS-FECHA-HASTA`)
- `[ ]` **TODO:** Los 4 reportes incrementan `WS-CONT-REPORTES-GEN` sin generar salida real

---

## 2. PROGRAMAS CICS

### 2.1 BIBMENU - Menú Principal `[x]`
- [x] `EVALUATE EIBAID` con `DFHENTER`, `DFHCLEAR`, `DFHPF3`
- [x] `EXEC CICS SEND MAP` / `RECEIVE MAP`
- [x] BMS: 5 opciones (1-Consultas, 2-Usuarios, 3-Préstamos, 4-Reportes, X-Salir)
- [x] `XCTL` a `BIBCONS` (opción 1) y `BIBPRES` (opción 3)
- [x] Mensajes informativos para opciones batch (2 y 4)
- [x] `TERMINAR-TRANSACCION` con `SEND TEXT` + `RETURN` (X o PF3)

### 2.2 BIBCONS - Consulta de Libros `[-]`
- [x] `EVALUATE EIBAID` con `DFHENTER`, `DFHCLEAR`, `DFHPF3`, `DFHPF7`, `DFHPF8`
- [x] BMS: 4 campos de búsqueda (`CODIGO`, `TITULO`, `AUTOR`, `CATEG`)
- [x] BMS: 10 líneas de resultados (`MENSAJE1..MENSAJE10`)
- [x] `EXEC SQL INCLUDE SQLCA` + host variables `COMP-3`
- [x] Estructura para paginación (`DCL-PAGINA-ACTUAL`, `DCL-TOTAL-RESULTADOS`)
- `[ ]` **TODO:** `RECEIVE MAP` para leer campos de búsqueda
- `[ ]` **TODO:** Construir `WHERE` dinámico con campos no vacíos
- `[ ]` **TODO:** `EXEC SQL DECLARE CURSOR` + `OPEN` + `FETCH` 10 rows + `CLOSE`
- `[ ]` **TODO:** Poblar `MENSAJE1O..MENSAJE10O` con datos del `FETCH`
- `[ ]` **TODO:** `SELECT COUNT(*)` para total de páginas + lógica real PF7/PF8

### 2.3 BIBPRES - Préstamos y Devoluciones `[-]`
- [x] `EVALUATE EIBAID` con `DFHENTER`, `DFHCLEAR`, `DFHPF3`
- [x] BMS: `TRATIPO` (P/D), `USUCODIGO`, `CODCODIGO`, `MSG`
- [x] `EXEC CICS RECEIVE MAP` con validación `DFHRESP(NORMAL)`
- [x] `EVALUATE TRUE` para préstamo vs devolución
- [x] `EXEC SQL INCLUDE SQLCA` + host variables `COMP-3`
- `[ ]` **TODO:** `PROCESAR-PRESTAMO-CICS`: validar usuario/libro/stock/topes/vencidos → `INSERT` + `UPDATE` stock + `COMMIT`
- `[ ]` **TODO:** `PROCESAR-DEVOLUCION-CICS`: buscar pendiente → calcular multa → `UPDATE` préstamo + `UPDATE` stock + `COMMIT`

---

## 3. BASE DE DATOS DB2 `[x]`

- [x] `CREATE TABLESPACE G4USU, G4LIB, G4PRE IN UNLAM USING STOGROUP UNLAM`
- [x] `CREATE TABLE KC02814.USUARIOS` (10 cols, PK, CK tipo/estado, UNIQUE INDEX email)
- [x] `CREATE TABLE KC02814.LIBROS` (12 cols, PK, CK estado/stock)
- [x] `CREATE TABLE KC02814.PRESTAMOS` (9 cols, PK, 2 FK, CK estado)
- [x] 5 índices adicionales (`ID4_PRES_USU_EST`, `ID4_PRES_LIB_EST`, `ID4_PRES_FECHA`, `ID4_LIB_CATEGORIA`, `ID4_LIB_AUTOR`)
- [x] `CREATE SEQUENCE SEQ_PRESTAMOS`
- [x] `GRANT ALL` + `GRANT USAGE ON SEQUENCE` a integrantes
- `[-]` Triggers de auditoría no implementados (opcionales)

---

## 4. JCL `[x]`

- [x] `COMPCOB.jcl`: `IGYWCLG` para COBOL puro (CICS)
- [x] `COMPDB2.jcl`: `DSNHPC` + `IGYCRCTL` + `IEWL` para COBOL+DB2
- [x] `RUNBATCH.jcl`: ejecución batch con `ENTRADA`/`NOVEDAD`/`TRANSAC`/`REPORTE`
- [x] `BINDRUN.jcl`: `BIND PLAN` (`DSN SYSTEM DBDG`) + ejecución
- [x] `RUNSQL.jcl`: `IKJEFT01` + `DSNTEP2` con `STEPLIB DSND10.*` y `PLAN(DSNTEP13)`
- [x] `DROPALL.jcl`: eliminación orden FK→PK→SEQ
- `[-]` DDs comentados en `BINDRUN.jcl` (descomentar según programa al ejecutar)

---

## 5. COPYBOOKS `[x]`

| Copybook | Contenido |
|----------|-----------|
| `LIBRO` | 01 `LIBRO-RECORD`: código X(10), título X(60), autor X(40), editorial X(30), año 9(4), categoría X(20), stock total/disponible 9(3), ubicación X(10), fecha alta X(10), usuario alta X(8), estado X(1) + 88 (A/I/B) |
| `USUARIO` | 01 `USUARIO-RECORD`: código X(10), nombre X(30), apellido X(30), tipo X(1) + 88 (E/D/A), email X(50), teléfono X(20), dirección X(60), fechas X(10), estado X(1) + 88 (A/I/B) |
| `PRESTAMO` | 01 `PRESTAMO-RECORD`: número 9(8), códigos X(10), fechas X(10), estado X(1) + 88 (P/D/V), multa 9(5)V99, observaciones X(100) |
| `CONSTANT` | Reglas: E=3/15, D=10/30, A=5/20, multa $50/día. Parámetros reportes (60 líneas/pág, 133 ancho). |
| `MENSAJES` | 8 errores + 4 informativos |
| `LINREP` | 3 cabeceras, separador, títulos columnas, línea detalle libros, totales (133 chars, `RECORDING MODE F`) |

---

## 6. MAPAS BMS `[x]`

- [x] `BIBMENU`: 5 opciones (1-4, X), campo `OPCION`, área `MENSAJE1`, PF3/ENTER
- [x] `BIBCONS`: 4 campos búsqueda (`CODIGO`, `TITULO`, `AUTOR`, `CATEG`), cabecera, 10 líneas, PF3/PF7/PF8
- [x] `BIBPRES`: `TRATIPO` (P/D), `USUCODIGO`, `CODCODIGO`, `MSG`, PF3/ENTER

---

## 7. DATOS DE PRUEBA `[x]`

| Archivo | Registros | Formato |
|---------|-----------|---------|
| `DATOS_LIBROS.csv` | 50 libros, 16 categorías | CSV con header, parseado por `UNSTRING DELIMITED BY ','` |
| `DATOS_USUARIOS.csv` | 31 altas + 3 modif + 2 bajas | CSV con header, parseado por `UNSTRING DELIMITED BY ','` |
| `DATOS_PRESTAMOS.csv` | 118 transacciones (P/D), junio 2026 | CSV con header, parseado por `UNSTRING DELIMITED BY ','` |

---

## 8. PENDIENTES (TODOs en código)

| # | Archivo | Descripción | Prioridad |
|---|---------|-------------|-----------|
| 1 | `PRESTAM.CBL` | Implementar 8 subrutinas de validación y DB2 | **ALTA** |
| 2 | `REPORTES.CBL` | Implementar 4 cursores DB2 + parámetros de fecha | **ALTA** |
| 3 | `BIBCONS.CBL` | Implementar búsqueda DB2 con `WHERE` dinámico y paginación | **ALTA** |
| 4 | `BIBPRES.CBL` | Implementar validación DB2 en tiempo real | **ALTA** |
| 5 | `CARGINI.CBL` | Validar código único (SELECT previo), año 1900-2100, stock > 0 | **MEDIA** |
| 6 | `USUMANT.CBL` | Validar email único en modificación + escribir detalle al reporte | **MEDIA** |
| 7 | `JCL` | Descomentar DDs en `BINDRUN.jcl` según programa al ejecutar | **BAJA** |
| 8 | `DDL_TABLAS.sql` | Agregar triggers de auditoría (opcional según consigna) | **BAJA** |
