# TRABAJO PRÁCTICO INTEGRADOR FINAL
## Sistema de Gestión de Biblioteca Universitaria

**ELECTIVA I - Lenguaje Orientado A Negocios (COBOL)**
**Universidad Nacional de La Matanza - DIIT**

- **Responsable:** Ing. Adrian Gonzalez
- **Año Académico:** 2026

---

## INFORMACIÓN GENERAL

### Descripción del Proyecto

Desarrollarán un sistema completo de gestión de biblioteca universitaria utilizando las tecnologías Mainframe que hemos estudiado durante el curso. Este proyecto integra todos los conocimientos adquiridos en un ambiente real de trabajo.

### ¿Qué van a construir?

- Sistema para gestionar préstamos de libros
- Control de usuarios (estudiantes y docentes)
- Inventario de libros
- Reportes estadísticos
- Interfaces interactivas para usuarios

### Tecnologías a Utilizar

- **Lenguaje:** COBOL
- **Plataforma:** IBM z/OS Mainframe
- **Acceso:** Zowe CLI
- **Base de Datos:** DB2
- **Interfaz:** CICS (pantallas interactivas)
- **Control de trabajos:** JCL

---

## ARQUITECTURA DEL SISTEMA

### Componentes Principales

| PROGRAMAS BATCH | INTERFACES CICS | BASE DE DATOS |
|:---:|:---:|:---:|
| CARGINI | BIBMENU | USUARIOS |
| USUMANT | BIBCONS | LIBROS |
| PRESTAM | BIBPRES | PRESTAMOS |
| REPORTES | | |

### Flujo de Datos

1. Carga inicial → Programas batch cargan datos maestros
2. Operaciones diarias → CICS maneja transacciones de usuarios
3. Reportes → Programas batch generan estadísticas
4. Mantenimiento → CICS permite actualizar datos

---

## ESPECIFICACIONES FUNCIONALES

### 1. Gestión de Usuarios

**Tipos de usuarios:**
- **Estudiantes:** Máximo 3 libros, 15 días de préstamo
- **Docentes:** Máximo 10 libros, 30 días de préstamo
- **Administrativos:** Máximo 5 libros, 20 días de préstamo

**Funciones:**
- Alta, baja y modificación de usuarios
- Validación de límites de préstamos
- Control de usuarios con préstamos vencidos

### 2. Gestión de Libros

**Información del libro:**
- Código único (10 caracteres)
- Título, autor, editorial
- Categoría (Informática, Matemática, etc.)
- Stock total y disponible
- Ubicación física

**Funciones:**
- Carga masiva de libros
- Consulta por código, título, autor o categoría
- Control de stock en tiempo real

### 3. Gestión de Préstamos

**Reglas de negocio:**
- Validar stock disponible
- Verificar límites por tipo de usuario
- No permitir préstamos con libros vencidos
- Calcular fecha de devolución automáticamente
- Registrar multas por retraso

**Funciones:**
- Registro de préstamos
- Proceso de devoluciones
- Consulta de préstamos activos
- Cálculo de multas

### 4. Reportes

- Libros más prestados
- Usuarios con préstamos vencidos
- Estadísticas mensuales
- Inventario por categoría

---

## COMPONENTES TÉCNICOS A DESARROLLAR

### A. PROGRAMAS BATCH (COBOL)

#### 1. CARGINI - Carga Inicial de Libros
- **Función:** Procesar archivo de libros y cargar base de datos
- **Entrada:** Archivo CSV con datos de libros
- **Salida:** Tabla LIBROS actualizada + Reporte de carga
- **Validaciones:** Código único, datos obligatorios, formato

#### 2. USUMANT - Mantenimiento de Usuarios
- **Función:** Procesar transacciones de usuarios (Alta/Baja/Mod)
- **Entrada:** Archivo de transacciones
- **Salida:** Tabla USUARIOS actualizada + Reporte proceso
- **Validaciones:** Email único, tipo usuario válido

#### 3. PRESTAM - Procesamiento de Préstamos
- **Función:** Procesar préstamos y devoluciones
- **Entrada:** Archivo de transacciones de préstamos
- **Salida:** Tablas actualizadas + Control de stock
- **Validaciones:** Reglas de negocio completas

#### 4. REPORTES - Generación de Reportes
- **Función:** Generar reportes estadísticos
- **Entrada:** Parámetros de fechas
- **Salida:** Reportes formateados
- **Contenido:** Estadísticas de uso y control

### B. PROGRAMAS CICS (COBOL + MAPAS BMS)

#### 1. BIBMENU - Menú Principal
- **Pantalla:** Menú con opciones del sistema
- **Opciones:** 1-Consultas, 2-Usuarios, 3-Préstamos, 4-Reportes, X-Salir
- **Navegación:** Control de flujo entre transacciones

#### 2. BIBCONS - Consulta de Libros
- **Pantalla:** Búsqueda de libros por múltiples criterios
- **Función:** Consulta interactiva con paginación
- **Display:** Lista de resultados con datos relevantes

#### 3. BIBPRES - Préstamos y Devoluciones
- **Pantalla:** Registro de préstamos/devoluciones
- **Función:** Validación en tiempo real
- **Proceso:** Integración completa con base de datos

### C. BASE DE DATOS DB2

**Tablas Principales:**
1. **USUARIOS** - Datos de estudiantes, docentes, administrativos
2. **LIBROS** - Catálogo completo de libros
3. **PRESTAMOS** - Registro de todas las transacciones

**Características:**
- Claves primarias y foráneas
- Índices para optimizar consultas
- Constraints para validar datos
- Triggers para auditoría (opcional)

---

## ESTRUCTURA DE ARCHIVOS

### Datasets Requeridos

| Dataset | Descripción |
|---------|-------------|
| `KC03xxx.COBOL.SOURCE` | Programas fuente COBOL |
| `KC03xxx.COBOL.COPYLIB` | Copybooks compartidos |
| `KC03xxx.BMS.SOURCE` | Mapas CICS |
| `KC03xxx.JCL.SOURCE` | Procedimientos JCL |
| `KC03xxx.SQL.SOURCE` | Scripts de base de datos |
| `KC03xxx.DATA.INPUT` | Archivos de entrada |
| `KC03xxx.LOAD.LIBRARY` | Programas compilados |
| `KC03xxx.REPORTES.OUTPUT` | Reportes generados |

### Copybooks Necesarios

- **LIBRO** - Estructura de datos de libros
- **USUARIO** - Estructura de datos de usuarios
- **PRESTAMO** - Estructura de préstamos
- **CONSTANT** - Constantes del sistema
- **MENSAJES** - Mensajes de error
- **LINREP** - Layouts de reportes

---

## ENTREGABLES

### 1. Código Fuente
- 4 programas COBOL batch compilados y funcionando
- 3 programas CICS con mapas BMS
- 6 copybooks documentados
- Scripts SQL para crear/poblar tablas
- JCL para compilación y ejecución

### 2. Testing y Validación
- Casos de prueba documentados
- Screenshots de ejecuciones exitosas
- Manejo de casos de error
- Datos de prueba consistentes

### 3. Presentación
- Demo en vivo de 15-20 minutos
- Demostración del sistema funcionando
- Explicación de decisiones técnicas
- Respuesta a preguntas del profesor
- Dominio técnico del código desarrollado
