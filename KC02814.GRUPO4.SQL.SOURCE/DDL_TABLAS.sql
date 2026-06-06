-- ***************************************************************
-- SCRIPT: DDL_TABLAS - CREACION DE OBJETOS DB2 PARA BIBLIOTECA
-- GRUPO: 4 - KC02814
-- CONVENCIONES:
--   Tablespaces: G4USU, G4LIB, G4PRE (G# donde #=grupo)
--   Database: UNLAM
--   Storage Group: UNLAM
-- ***************************************************************

-- --------------------------------------------------------------
-- PASO 1: CREAR TABLESPACES
--         Orden: USU, LIB, PRE
-- --------------------------------------------------------------

CREATE TABLESPACE G4USU
  IN UNLAM
  USING STOGROUP UNLAM
  PRIQTY 20
  SECQTY 10
  ERASE NO
  BUFFERPOOL BP0
  LOCKSIZE ROW
  CLOSE NO;
COMMIT;

CREATE TABLESPACE G4LIB
  IN UNLAM
  USING STOGROUP UNLAM
  PRIQTY 20
  SECQTY 10
  ERASE NO
  BUFFERPOOL BP0
  LOCKSIZE ROW
  CLOSE NO;
COMMIT;

CREATE TABLESPACE G4PRE
  IN UNLAM
  USING STOGROUP UNLAM
  PRIQTY 20
  SECQTY 10
  ERASE NO
  BUFFERPOOL BP0
  LOCKSIZE ROW
  CLOSE NO;
COMMIT;

-- --------------------------------------------------------------
-- PASO 2: CREAR TABLA USUARIOS
--          Columnas segun copybook USUARIO.CBL
-- --------------------------------------------------------------

CREATE TABLE KC02814.USUARIOS (
    USU_CODIGO           CHAR(10)      NOT NULL,
    USU_NOMBRE           CHAR(30)      NOT NULL,
    USU_APELLIDO         CHAR(30)      NOT NULL,
    USU_TIPO_USUARIO     CHAR(1)       NOT NULL,
    USU_EMAIL            CHAR(50)      NOT NULL,
    USU_TELEFONO         CHAR(20)      NOT NULL,
    USU_DIRECCION        CHAR(60)      NOT NULL,
    USU_FECHA_ALTA       CHAR(10)      NOT NULL,
    USU_FECHA_BAJA       CHAR(10)      NOT NULL,
    USU_ESTADO           CHAR(1)       NOT NULL,
    CONSTRAINT PK_USUARIOS PRIMARY KEY (USU_CODIGO),
    CONSTRAINT CK_USU_TIPO CHECK (USU_TIPO_USUARIO IN ('E','D','A')),
    CONSTRAINT CK_USU_ESTADO CHECK (USU_ESTADO IN ('A','I','B'))
)
IN UNLAM.G4USU;
COMMIT;

-- Indice de clave primaria (ya creado implicitamente por PK)

-- Indice para busqueda por email (para validar unicidad)
CREATE UNIQUE INDEX KC02814.ID4_USU_EMAIL
    ON KC02814.USUARIOS (USU_EMAIL);
COMMIT;

-- --------------------------------------------------------------
-- PASO 3: CREAR TABLA LIBROS
--          Columnas segun copybook LIBROS.CBL
-- --------------------------------------------------------------

CREATE TABLE KC02814.LIBROS (
    LIB_CODIGO            CHAR(10)      NOT NULL,
    LIB_TITULO            CHAR(60)      NOT NULL,
    LIB_AUTOR             CHAR(40)      NOT NULL,
    LIB_EDITORIAL         CHAR(30)      NOT NULL,
    LIB_ANIO_PUBLICACION  DECIMAL(4)   NOT NULL,
    LIB_CATEGORIA         CHAR(20)      NOT NULL,
    LIB_STOCK_TOTAL       DECIMAL(3)   NOT NULL,
    LIB_STOCK_DISPONIBLE  DECIMAL(3)   NOT NULL,
    LIB_UBICACION         CHAR(10)      NOT NULL,
    LIB_FECHA_ALTA        CHAR(10)      NOT NULL,
    LIB_USUARIO_ALTA      CHAR(8)       NOT NULL,
    LIB_ESTADO            CHAR(1)       NOT NULL,
    CONSTRAINT PK_LIBROS PRIMARY KEY (LIB_CODIGO),
    CONSTRAINT CK_LIB_ESTADO CHECK (LIB_ESTADO IN ('A','I','B')),
    CONSTRAINT CK_LIB_STOCK CHECK (LIB_STOCK_DISPONIBLE <= LIB_STOCK_TOTAL)
)
IN UNLAM.G4LIB;
COMMIT;

-- --------------------------------------------------------------
-- PASO 4: CREAR TABLA PRESTAMOS
--          Con FK a USUARIOS y LIBROS
-- --------------------------------------------------------------

CREATE TABLE KC02814.PRESTAMOS (
    PRES_NUMERO           DECIMAL(8)    NOT NULL,
    PRES_CODIGO_LIBRO     CHAR(10)      NOT NULL,
    PRES_CODIGO_USUARIO   CHAR(10)      NOT NULL,
    PRES_FECHA_PRESTAMO   CHAR(10)      NOT NULL,
    PRES_FECHA_DEVOLUCION CHAR(10)      NOT NULL,
    PRES_FECHA_LIMITE     CHAR(10)      NOT NULL,
    PRES_ESTADO           CHAR(1)       NOT NULL,
    PRES_MULTA            DECIMAL(7,2)  NOT NULL,
    PRES_OBSERVACIONES    CHAR(100)     NOT NULL,
    CONSTRAINT PK_PRESTAMOS PRIMARY KEY (PRES_NUMERO),
    CONSTRAINT FK_PRES_LIBRO FOREIGN KEY (PRES_CODIGO_LIBRO)
        REFERENCES KC02814.LIBROS(LIB_CODIGO),
    CONSTRAINT FK_PRES_USUARIO FOREIGN KEY (PRES_CODIGO_USUARIO)
        REFERENCES KC02814.USUARIOS(USU_CODIGO),
    CONSTRAINT CK_PRES_ESTADO CHECK (PRES_ESTADO IN ('P','D','V'))
)
IN UNLAM.G4PRE;
COMMIT;

-- --------------------------------------------------------------
-- PASO 5: CREAR INDICES DE BUSQUEDA ADICIONALES
-- --------------------------------------------------------------

CREATE INDEX KC02814.ID4_PRES_USU_EST
    ON KC02814.PRESTAMOS (PRES_CODIGO_USUARIO, PRES_ESTADO);
COMMIT;

CREATE INDEX KC02814.ID4_PRES_LIB_EST
    ON KC02814.PRESTAMOS (PRES_CODIGO_LIBRO, PRES_ESTADO);
COMMIT;

CREATE INDEX KC02814.ID4_PRES_FECHA
    ON KC02814.PRESTAMOS (PRES_FECHA_LIMITE, PRES_ESTADO);
COMMIT;

CREATE INDEX KC02814.ID4_LIB_CATEGORIA
    ON KC02814.LIBROS (LIB_CATEGORIA, LIB_ESTADO);
COMMIT;

CREATE INDEX KC02814.ID4_LIB_AUTOR
    ON KC02814.LIBROS (LIB_AUTOR);
COMMIT;

-- --------------------------------------------------------------
-- PASO 6: CREAR SECUENCIA PARA NUMERO DE PRESTAMO
-- --------------------------------------------------------------

CREATE SEQUENCE KC02814.SEQ_PRESTAMOS
    START WITH 1
    INCREMENT BY 1
    NOMAXVALUE
    NOCYCLE
    CACHE 20;
COMMIT;

-- --------------------------------------------------------------
-- PASO 7: GRANT PERMISOS A INTEGRANTES DEL GRUPO
-- --------------------------------------------------------------
-- Nota: Reemplazar KC03AAA/BBB/CCC por los IDs reales del grupo
-- --------------------------------------------------------------

GRANT ALL ON TABLE KC02814.USUARIOS  TO KC03AAA, KC03BBB, KC03CCC;
GRANT ALL ON TABLE KC02814.LIBROS    TO KC03AAA, KC03BBB, KC03CCC;
GRANT ALL ON TABLE KC02814.PRESTAMOS TO KC03AAA, KC03BBB, KC03CCC;
GRANT USAGE ON SEQUENCE KC02814.SEQ_PRESTAMOS TO KC03AAA, KC03BBB, KC03CCC;
COMMIT;
