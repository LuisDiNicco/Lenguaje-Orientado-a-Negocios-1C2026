       IDENTIFICATION DIVISION.
       PROGRAM-ID. BIBCONS.
       AUTHOR. GRUPO 4.
       DATE-WRITTEN. 23/05/2026.
      *****************************************************************
      * PROGRAMA: BIBCONS - CONSULTA DE LIBROS                        *
      * DESCRIPCION: LISTADO PAGINADO CON DB2                         *
      *****************************************************************

       DATA DIVISION.

       WORKING-STORAGE SECTION.
       COPY DFHAID.
       COPY BIBCONS.

       01  WS-VARIABLES.
           05 WS-MENSAJE       PIC X(60).
           05 WS-FIRST-TIME    PIC X(1) VALUE 'Y'.
              88 PRIMERA-VEZ   VALUE 'Y'.

        01  WS-RESP             PIC S9(8) COMP VALUE 0.

      *
      * DECLARACIONES DB2
      *
           EXEC SQL INCLUDE SQLCA END-EXEC.
      *
      * VARIABLES HOST DB2
      *
       01  DCL-LIBRO-CONS.
           05 DCL-CONS-CODIGO            PIC X(10).
           05 DCL-CONS-TITULO            PIC X(60).
           05 DCL-CONS-AUTOR             PIC X(40).
           05 DCL-CONS-EDITORIAL         PIC X(30).
           05 DCL-CONS-ANIO              PIC S9(4) USAGE COMP-3.
           05 DCL-CONS-CATEGORIA         PIC X(20).
           05 DCL-CONS-STOCK-TOTAL       PIC S9(3) USAGE COMP-3.
           05 DCL-CONS-STOCK-DISPONIBLE  PIC S9(3) USAGE COMP-3.
           05 DCL-CONS-UBICACION         PIC X(10).
       01  DCL-PAGINA-ACTUAL             PIC S9(4) USAGE COMP-3 VALUE 0.
       01  DCL-TOTAL-RESULTADOS          PIC S9(4) USAGE COMP-3 VALUE 0.
      *
      * TODO: DECLARAR AQUI VARIABLES PARA CAMPOS DE BUSQUEDA
      *

       PROCEDURE DIVISION.

       MAIN-LOGIC.
           EVALUATE TRUE
               WHEN EIBCALEN = ZERO
                    PERFORM OBTENER-DATOS-DB2
                    PERFORM ENVIAR-MAPA-CON-DATOS
               WHEN EIBAID = DFHCLEAR
                    PERFORM ENVIAR-MAPA-CON-DATOS
               WHEN EIBAID = DFHPF3
                    PERFORM VOLVER-AL-MENU
               WHEN EIBAID = DFHENTER
                    PERFORM OBTENER-DATOS-DB2
                    PERFORM ENVIAR-MAPA-CON-DATOS
               WHEN EIBAID = DFHPF7
       *             TODO: DCL-PAGINA-ACTUAL = DCL-PAGINA-ACTUAL - 1
       *                   IF < 0 THEN MOVE 0
       *                   PERFORM OBTENER-DATOS-DB2
                     MOVE 'PAGINACION EN DESARROLLO' TO MENSAJE10O
                     PERFORM ENVIAR-MAPA-CON-DATOS
                WHEN EIBAID = DFHPF8
       *             TODO: Calcular max paginas desde DCL-TOTAL-RESULTADOS
       *                   DCL-PAGINA-ACTUAL = DCL-PAGINA-ACTUAL + 1
       *                   IF > max THEN no avanzar
       *                   PERFORM OBTENER-DATOS-DB2
                     MOVE 'PAGINACION EN DESARROLLO' TO MENSAJE10O
                     PERFORM ENVIAR-MAPA-CON-DATOS
               WHEN OTHER
                    MOVE 'TECLA NO VALIDA' TO MENSAJE10O
                    PERFORM ENVIAR-MAPA-CON-DATOS
           END-EVALUATE

           EXEC CICS RETURN
                TRANSID('BIBC')
                COMMAREA(WS-FIRST-TIME)
                LENGTH(1)
           END-EXEC.

       *--------------------------------------------------------------
       *   OBTENER DATOS DE DB2 Y LLENAR MAPA
       *--------------------------------------------------------------
        OBTENER-DATOS-DB2.
       *    TODO: Leer campos de busqueda del mapa via RECEIVE MAP
       *          MOVE CODIGOI TO DCL-CONS-CODIGO
       *          MOVE TITULOI TO DCL-CONS-TITULO
       *          MOVE AUTORI  TO DCL-CONS-AUTOR
       *          MOVE CATEGI  TO DCL-CONS-CATEGORIA
       *    TODO: Construir WHERE clause dinamico con los campos
       *          no vacios concatenados con AND
       *    TODO: EXEC SQL DECLARE C_CONS CURSOR FOR
       *          SELECT LIB_CODIGO, LIB_TITULO, LIB_AUTOR,
       *                 LIB_ANIO_PUBLICACION, LIB_STOCK_DISPONIBLE,
       *                 LIB_UBICACION
       *          FROM KC02814.LIBROS
       *          WHERE LIB_ESTADO = 'A'
       *            AND (LIB_CODIGO LIKE :host-codigo OR ...)
       *          ORDER BY LIB_CODIGO
       *    TODO: EXEC SQL OPEN C_CONS END-EXEC
       *    TODO: Calcular offset segun DCL-PAGINA-ACTUAL
       *    TODO: FETCH 10 rows y poblar MENSAJE1O..MENSAJE10O
       *    TODO: EXEC SQL SELECT COUNT(*) para DCL-TOTAL-RESULTADOS
       *    TODO: EXEC SQL CLOSE C_CONS END-EXEC
            MOVE SPACES TO MENSAJE1O
            MOVE SPACES TO MENSAJE2O
            MOVE SPACES TO MENSAJE3O
            MOVE SPACES TO MENSAJE4O
            MOVE SPACES TO MENSAJE5O
            MOVE SPACES TO MENSAJE6O
            MOVE SPACES TO MENSAJE7O
            MOVE SPACES TO MENSAJE8O
            MOVE SPACES TO MENSAJE9O
            MOVE SPACES TO MENSAJE10O
            MOVE 'TODO: IMPLEMENTAR BUSQUEDA DB2 + PAGINACION'
                  TO MENSAJE1O.

      *--------------------------------------------------------------
      *   ENVIAR MAPA A PANTALLA
      *--------------------------------------------------------------
       ENVIAR-MAPA-CON-DATOS.
           EXEC CICS SEND MAP('CONS')
                MAPSET('BIBCONS')
                CURSOR
                RESP(WS-RESP)
           END-EXEC.

      *--------------------------------------------------------------
      *   VOLVER AL MENU PRINCIPAL
      *--------------------------------------------------------------
       VOLVER-AL-MENU.
           EXEC CICS XCTL
                PROGRAM('BIBMENU')
           END-EXEC.
