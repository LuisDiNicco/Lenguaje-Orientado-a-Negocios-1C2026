# ESTADO DEL TRABAJO PRÁCTICO INTEGRADOR FINAL
## Sistema de Gestión de Biblioteca Universitaria

A continuación se detalla la consigna completa oficial y el estado de implementación de cada punto.
**Referencias:**
- `[ ]` No empezado
- `[-]` Incompleto / En proceso (Falta adaptar a DB2 u otros detalles)
- `[x]` Finalizado

---

## 1. COMPONENTES PRINCIPALES (ARQUITECTURA)
El flujo de datos del sistema está compuesto por programas Batch, Interfaces CICS y Base de Datos DB2.

### A. PROGRAMAS BATCH (COBOL)
- `[-]` **1. CARGINI - Carga Inicial de Libros**
  - **Función:** Procesar archivo CSV de libros y cargar base de datos.
  - **Falta:** Reemplazar bloque de guardado por `EXEC SQL INSERT DB2`. (Hay un TODO en el código).
  - **Estado:** Estructura COBOL, lecturas y reportes armados.
- `[-]` **2. USUMANT - Mantenimiento de Usuarios**
  - **Función:** Procesar transacciones de usuarios (Alta/Baja/Mod) desde archivo.
  - **Falta:** Declarar lectura del archivo secuencial e implementar los INSERT/UPDATE a DB2.
  - **Estado:** Creado programa base con la lógica de validación extraída (tipo de usuario, email).
- `[ ]` **3. PRESTAM - Procesamiento de Préstamos**
  - **Función:** Procesar préstamos y devoluciones desde archivo, aplicar reglas de negocio.
  - **Falta:** Todo.
  - **Estado:** No empezado.
- `[ ]` **4. REPORTES - Generación de Reportes**
  - **Función:** Generar reportes estadísticos (libros más prestados, etc.).
  - **Falta:** Todo.
  - **Estado:** No empezado.

### B. PROGRAMAS CICS (COBOL + MAPAS BMS)
- `[-]` **1. BIBMENU - Menú Principal**
  - **Función:** Menú con opciones del sistema (1-Consultas, 2-Usuarios, 3-Préstamos, 4-Reportes, X-Salir).
  - **Falta:** Descomentar y completar los `EXEC CICS XCTL` para navegar a los módulos cuando existan.
  - **Estado:** Pantalla (BMS) y programa CICS (CBL) creados y adaptados.
- `[-]` **2. BIBCONS - Consulta de Libros**
  - **Función:** Búsqueda interactiva con paginación de múltiples criterios.
  - **Falta:** Agregar campos de búsqueda al BMS y declarar la lógica de paginación DB2 (Cursores) en el CBL.
  - **Estado:** Pantalla base y estructura de programa creadas.
- `[ ]` **3. BIBPRES - Préstamos y Devoluciones**
  - **Función:** Registro en pantalla, validación en tiempo real.
  - **Falta:** Todo.
  - **Estado:** No empezado.

### C. BASE DE DATOS DB2
- `[ ]` **Tabla USUARIOS:** Datos de estudiantes, docentes, administrativos.
- `[ ]` **Tabla LIBROS:** Catálogo completo de libros.
- `[ ]` **Tabla PRESTAMOS:** Registro de transacciones.
- `[ ]` **Estructuras SQL:** Claves primarias/foráneas, índices.
  - **Falta:** Todo.
  - **Estado general:** Pendiente de ver en clase.

### D. COPYBOOKS NECESARIOS (100% COMPLETADOS)
- `[x]` **LIBRO** - Estructura de datos de libros
- `[x]` **USUARIO** - Estructura de datos de usuarios
- `[x]` **PRESTAMO** - Estructura de préstamos
- `[x]` **CONSTANT** - Constantes del sistema
- `[x]` **MENSAJES** - Mensajes de error
- `[x]` **LINREP** - Layouts de reportes

---

## 2. ESPECIFICACIONES FUNCIONALES A IMPLEMENTAR

### Gestión de Usuarios
- `[ ]` Estudiantes: Máximo 3 libros, 15 días de préstamo.
- `[ ]` Docentes: Máximo 10 libros, 30 días de préstamo.
- `[ ]` Administrativos: Máximo 5 libros, 20 días de préstamo.
- `[-]` Lógica: Validaciones base extraídas. Alta, baja, modificación pendientes de DB2.

### Gestión de Libros
- `[ ]` Datos: Código (10), Título, Autor, Editorial, Categoría, Stock, Ubicación.
- `[-]` Funciones: Carga masiva en progreso (`CARGINI`). Consulta en progreso (`BIBCONS`).

### Gestión de Préstamos
- `[ ]` Reglas: Validar stock, verificar límites, no permitir préstamo a deudores.
- `[ ]` Fechas: Calcular devolución automática.
- `[ ]` Funciones: Registro, devoluciones, cálculo de multas.

### Reportes
- `[ ]` Libros más prestados.
- `[ ]` Usuarios con préstamos vencidos.
- `[ ]` Estadísticas mensuales e Inventario por categoría.

---

## 3. ENTREGABLES EXIGIDOS
- `[-]` **Código Fuente:** 4 programas COBOL batch (2 iniciados), 3 CICS (2 iniciados), 6 copybooks (Listos), Scripts SQL (Faltan), JCL (Faltan).
- `[ ]` **Testing y Validación:** Casos de prueba, screenshots.
- `[ ]` **Presentación:** Demo en vivo de 15-20 minutos.
