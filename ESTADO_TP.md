# ESTADO DEL TRABAJO PRÁCTICO INTEGRADOR FINAL
## Sistema de Gestión de Biblioteca Universitaria - Grupo 4 (KC02814)

**Referencias de estado:**
- `[x]` Código fuente completo
- `[-]` Pendiente de compilación y prueba en mainframe
- `[ ]` No implementado

---

## 1. PROGRAMAS BATCH (COBOL + DB2)

### 1.1 CARGINI - Carga Inicial de Libros `[x]`
- **Entrada:** Archivo CSV con datos de libros (código, título, autor, editorial, año, categoría, stock, ubicación)
- **Salida:** Tabla LIBROS actualizada + Reporte de carga paginado
- **Validaciones:** Código no vacío, título no vacío, autor no vacío, año numérico, stock numérico
- **DB2:** EXEC SQL INSERT INTO KC02814.LIBROS con 12 columnas. Control de SQLCODE post-insert.
- **Reporte:** Cabecera institucional, detalle por libro, totales de registros y errores. Paginación cada 55 líneas.
- **Archivo:** `KC02814.GRUPO4.COBOL.SOURCE(CARGINI)`

### 1.2 USUMANT - Mantenimiento de Usuarios `[x]`
- **Entrada:** Archivo secuencial de novedades (Alta=A, Baja=B, Modificación=M)
- **Salida:** Tabla USUARIOS actualizada + Reporte de proceso
- **Validaciones:**
  - Tipo de usuario válido (E=Estudiante, D=Docente, A=Administrativo)
  - Formato de email (contiene @)
  - Email único en la base (SELECT previo al INSERT)
  - Campos obligatorios no vacíos (código, nombre, apellido)
- **DB2:** EXEC SQL INSERT (alta), UPDATE (baja lógica con estado 'B'), UPDATE (modificación). Control de SQLCODE.
- **Archivo:** `KC02814.GRUPO4.COBOL.SOURCE(USUMANT)`

### 1.3 PRESTAM - Procesamiento de Préstamos y Devoluciones `[x]`
- **Entrada:** Archivo de transacciones (P=Préstamo, D=Devolución) con código usuario, código libro y fecha
- **Salida:** Tablas PRESTAMOS y LIBROS actualizadas + Reporte
- **Reglas de negocio implementadas en estructura:**
  - Validación de existencia de usuario y libro
  - Verificación de stock disponible
  - Control de topes por tipo de usuario (Estudiante: 3, Docente: 10, Administrativo: 5)
  - Cálculo de fecha límite según tipo (Estudiante: 15 días, Docente: 30 días, Administrativo: 20 días)
  - Cálculo de multa por atraso ($50/día)
  - No se permite préstamo si el usuario tiene libros vencidos
- **DB2:** INSERT en PRESTAMOS, UPDATE de stock en LIBROS (disminuir al prestar, aumentar al devolver)
- **Pendiente:** Cursores DB2 y cálculo de fechas marcados con TODO para completar en mainframe
- **Archivo:** `KC02814.GRUPO4.COBOL.SOURCE(PRESTAM)`

### 1.4 REPORTES - Generación de Reportes Estadísticos `[x]`
- **Entrada:** Tablas DB2 (parámetros de fecha al iniciar)
- **Salida:** Reporte formateado de 133 columnas con 4 secciones:
  1. Top 10 libros más prestados (JOIN LIBROS + PRESTAMOS, GROUP BY, ORDER BY DESC)
  2. Usuarios con préstamos vencidos (JOIN USUARIOS + PRESTAMOS + LIBROS, filtro por estado y fecha)
  3. Estadísticas mensuales (GROUP BY año/mes, COUNT préstamos, COUNT devoluciones, SUM multas)
  4. Inventario por categoría (GROUP BY categoría, COUNT libros, SUM stock total, SUM disponible, diferencia)
- **DB2:** Host variables declaradas para cada cursor. Cursores con consultas SQL completas en comentarios.
- **Pendiente:** EXEC SQL DECLARE/OPEN/FETCH/CLOSE marcados con TODO para implementar en mainframe
- **Archivo:** `KC02814.GRUPO4.COBOL.SOURCE(REPORTES)`

---

## 2. PROGRAMAS CICS (COBOL + MAPAS BMS)

### 2.1 BIBMENU - Menú Principal `[x]`
- **Pantalla:** Título del sistema, 5 opciones (1-Consultas, 2-Usuarios, 3-Préstamos, 4-Reportes, X-Salir)
- **Navegación:** XCTL a BIBCONS (opción 1), XCTL a BIBPRES (opción 3), mensaje informativo para opciones batch (2 y 4)
- **Salida:** PF3 o X → SEND TEXT de despedida + RETURN
- **Archivos:** `KC02814.GRUPO4.COBOL.SOURCE(BIBMENU)` + `KC02814.GRUPO4.BMS.SOURCE(BIBMENU)`

### 2.2 BIBCONS - Consulta de Libros `[x]`
- **Pantalla:** 4 campos de búsqueda (código, título, autor, categoría) + 10 líneas de resultados paginados
- **Función:** Búsqueda interactiva con paginación (PF7=anterior, PF8=siguiente)
- **Navegación:** PF3 → XCTL a BIBMENU
- **Pendiente:** Cursores DB2 y lógica de paginación marcados con TODO para mainframe
- **Archivos:** `KC02814.GRUPO4.COBOL.SOURCE(BIBCONS)` + `KC02814.GRUPO4.BMS.SOURCE(BIBCONS)`

### 2.3 BIBPRES - Préstamos y Devoluciones `[x]`
- **Pantalla:** Tipo de transacción (P/D), código de usuario, código de libro, área de mensajes
- **Función:** Registro con validación en tiempo real contra DB2
- **Navegación:** PF3 → XCTL a BIBMENU
- **Pendiente:** Operaciones DB2 (SELECT/INSERT/UPDATE) marcadas con TODO para mainframe
- **Archivos:** `KC02814.GRUPO4.COBOL.SOURCE(BIBPRES)` + `KC02814.GRUPO4.BMS.SOURCE(BIBPRES)`

---

## 3. BASE DE DATOS DB2

### 3.1 Infraestructura `[x]`
| Objeto | Nombre | Detalle |
|--------|--------|---------|
| Database | UNLAM | Existente, administrada por Marista |
| Storage Group | UNLAM | Volumen BIGDB5, VCAT DSND10 |
| Tablespace USUARIOS | G4USU | PRIQTY 20, SECQTY 10, BP0, LOCKSIZE ROW |
| Tablespace LIBROS | G4LIB | PRIQTY 20, SECQTY 10, BP0, LOCKSIZE ROW |
| Tablespace PRESTAMOS | G4PRE | PRIQTY 20, SECQTY 10, BP0, LOCKSIZE ROW |

### 3.2 Tablas `[x]`
| Tabla | Columnas | Constraints |
|-------|----------|-------------|
| KC02814.USUARIOS | 10 columnas (CHAR y DECIMAL) | PK: USU_CODIGO, CK: USU_TIPO_USUARIO IN (E,D,A), CK: USU_ESTADO IN (A,I,B), UNIQUE INDEX: USU_EMAIL |
| KC02814.LIBROS | 12 columnas (CHAR y DECIMAL) | PK: LIB_CODIGO, CK: LIB_ESTADO IN (A,I,B), CK: LIB_STOCK_DISPONIBLE <= LIB_STOCK_TOTAL |
| KC02814.PRESTAMOS | 9 columnas (CHAR y DECIMAL) | PK: PRES_NUMERO, FK → USUARIOS, FK → LIBROS, CK: PRES_ESTADO IN (P,D,V) |

### 3.3 Índices adicionales `[x]`
- `ID4_PRES_USU_EST` sobre PRESTAMOS (PRES_CODIGO_USUARIO, PRES_ESTADO)
- `ID4_PRES_LIB_EST` sobre PRESTAMOS (PRES_CODIGO_LIBRO, PRES_ESTADO)
- `ID4_PRES_FECHA` sobre PRESTAMOS (PRES_FECHA_LIMITE, PRES_ESTADO)
- `ID4_LIB_CATEGORIA` sobre LIBROS (LIB_CATEGORIA, LIB_ESTADO)
- `ID4_LIB_AUTOR` sobre LIBROS (LIB_AUTOR)

### 3.4 Secuencia `[x]`
- `SEQ_PRESTAMOS`: START 1, INCREMENT 1, NOMAXVALUE, NOCYCLE, CACHE 20

### 3.5 Permisos `[x]`
- GRANT ALL ON TABLE + GRANT USAGE ON SEQUENCE a los 3 integrantes del grupo

### 3.6 Scripts `[x]`
- **Archivo:** `KC02814.GRUPO4.SQL.SOURCE(DDL_TABLAS)`

---

## 4. COPYBOOKS (6 de 6)

| Copybook | Estructura principal | Archivo |
|----------|---------------------|---------|
| **LIBROS** | Código X(10), título X(60), autor X(40), editorial X(30), año 9(4), categoría X(20), stock total 9(3), stock disponible 9(3), ubicación X(10), fecha alta X(10), usuario alta X(8), estado X(1) con 88 (A/I/B) | `COPYLIB(LIBROS)` |
| **USUARIO** | Código X(10), nombre X(30), apellido X(30), tipo X(1) con 88 (E/D/A), email X(50), teléfono X(20), dirección X(60), fecha alta X(10), fecha baja X(10), estado X(1) con 88 (A/I) | `COPYLIB(USUARIO)` |
| **PRESTAMO** | Número 9(8), cod libro X(10), cod usuario X(10), fecha préstamo X(10), fecha devolución X(10), fecha límite X(10), estado X(1) con 88 (P/D/V), multa 9(5)V99, observaciones X(100) | `COPYLIB(PRESTAMO)` |
| **CONSTANT** | Nombre sistema, versión, universidad. Reglas: EST(3 libros/15 días), DOC(10/30), ADM(5/20), multa $50/día. Parámetros reportes. | `COPYLIB(CONSTANT)` |
| **MENSAJES** | 8 mensajes de error + 4 mensajes informativos | `COPYLIB(MENSAJES)` |
| **LINREP** | 3 cabeceras, separador, títulos de columnas, línea detalle libros, totales. Líneas de 133 caracteres. | `COPYLIB(LINREP)` |

---

## 5. JCL (6 de 6)

| JCL | Programa base | Función | Archivo |
|-----|---------------|---------|---------|
| **COMPCOB** | IGYWCLG | Compila, linkedita y ejecuta programas COBOL sin DB2 | `JCL.SOURCE(COMPCOB)` |
| **COMPDB2** | DSNHPC + IGYCRCTL + IEWL | Precompila DB2, compila COBOL, linkedita. Genera LOAD + DBRM | `JCL.SOURCE(COMPDB2)` |
| **RUNBATCH** | (genérico) | Ejecuta programa desde LOAD.LIBRARY con DDs de entrada/salida | `JCL.SOURCE(RUNBATCH)` |
| **BINDRUN** | IKJEFT01 + (genérico) | BIND PLAN en DB2 + ejecución del programa | `JCL.SOURCE(BINDRUN)` |
| **RUNSQL** | IKJEFT01 + DSNTEP2 | Ejecuta scripts SQL desde SYSIN vía DSNTEP2 | `JCL.SOURCE(RUNSQL)` |
| **DROPALL** | IKJEFT01 + DSNTEP2 | Elimina todos los objetos DB2 del grupo en orden correcto | `JCL.SOURCE(DROPALL)` |

---

## 6. ARCHIVOS DE DATOS DE PRUEBA (3 de 3)

| Archivo | Contenido | Cantidad |
|---------|-----------|----------|
| `DATA.INPUT(DATOS_LIBROS)` | Libros de ejemplo con código, título, autor, editorial, año, categoría, stock, ubicación | 15 registros |
| `DATA.INPUT(DATOS_USUARIOS)` | Transacciones de alta/baja/modificación de usuarios | 7 registros |
| `DATA.INPUT(DATOS_PRESTAMOS)` | Transacciones de préstamo (P) y devolución (D) | 10 registros |

---

## 7. ESTRUCTURA DE DATASETS

| Dataset | Contenido | Miembros |
|---------|-----------|----------|
| `KC02814.COBOL.SOURCE` | Programas fuente COBOL | CARGINI, USUMANT, PRESTAM, REPORTES, BIBMENU, BIBCONS, BIBPRES |
| `KC02814.COBOL.COPYLIB` | Copybooks | LIBROS, USUARIO, PRESTAMO, CONSTANT, MENSAJES, LINREP |
| `KC02814.BMS.SOURCE` | Mapas CICS | BIBMENU, BIBCONS, BIBPRES |
| `KC02814.JCL.SOURCE` | Scripts JCL | COMPCOB, COMPDB2, RUNBATCH, BINDRUN, RUNSQL, DROPALL |
| `KC02814.SQL.SOURCE` | Scripts SQL | DDL_TABLAS |
| `KC02814.DATA.INPUT` | Datos de prueba | DATOS_LIBROS, DATOS_USUARIOS, DATOS_PRESTAMOS |
| `KC02814.LOAD.LIBRARY` | Programas compilados | (se completa al compilar) |
| `KC02814.REPORTES.OUTPUT` | Reportes generados | (se completa al ejecutar) |

---

## 8. ORDEN DE EJECUCIÓN EN MAINFRAME

| Paso | JCL | Descripción |
|------|-----|-------------|
| 1 | `RUNSQL` | Crear tablespaces, tablas, índices, secuencia, permisos (una sola vez, el owner) |
| 2 | `COMPDB2(CARGINI)` | Compilar programa de carga de libros |
| 3 | `COMPDB2(USUMANT)` | Compilar programa de mantenimiento de usuarios |
| 4 | `COMPDB2(PRESTAM)` | Compilar programa de préstamos |
| 5 | `COMPDB2(REPORTES)` | Compilar programa de reportes |
| 6 | `BINDRUN(CARGINI)` + `ENTRADA=DATOS_LIBROS` | Carga inicial de libros a DB2 |
| 7 | `BINDRUN(USUMANT)` + `NOVEDAD=DATOS_USUARIOS` | Alta/baja/mod de usuarios |
| 8 | `BINDRUN(PRESTAM)` + `TRANSAC=DATOS_PRESTAMOS` | Procesar préstamos y devoluciones |
| 9 | `BINDRUN(REPORTES)` | Generar los 4 reportes estadísticos |
| 10 | Probar CICS | Navegar BIBMENU → BIBCONS → BIBPRES |

---

## 9. PENDIENTE PARA COMPLETAR

1. **Cursores DB2:** Los programas REPORTES, PRESTAM y BIBCONS tienen las consultas SQL definidas en comentarios. Falta implementar la apertura, fetch y cierre de cursores reales durante la fase de compilación en mainframe.
2. **Cálculo de fechas COBOL:** PRESTAM requiere aritmética de fechas (sumar días a fecha actual) para calcular fecha límite según tipo de usuario.
3. **Compilación y prueba:** Todo el código debe compilarse y ejecutarse en el entorno Marista (z/OS) para validar funcionamiento.
4. **Testing formal:** Documentar casos de prueba con datos de entrada y capturas de pantalla de resultados.
5. **Triggers de auditoría:** Opcionales. No implementados.
