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
               WHEN EIBAID = DFHPF7
      *             TODO: LOGICA PAGINACION ANTERIOR
                    MOVE 'PAGINACION EN DESARROLLO' TO MENSAJE10O
                    PERFORM ENVIAR-MAPA-CON-DATOS
               WHEN EIBAID = DFHPF8
      *             TODO: LOGICA PAGINACION SIGUIENTE
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
      *   OBTENER DATOS DE DB2 Y LLENAR MAPA (MOCK)
      *--------------------------------------------------------------
       OBTENER-DATOS-DB2.
           MOVE SPACES TO MENSAJE1O
           MOVE SPACES TO MENSAJE2O
           MOVE SPACES TO MENSAJE3O

      *    TODO: AQUI DEBE IR LA LOGICA DE DB2 PARA TRAER LIBROS
      *    EXEC SQL DECLARE CURSOR...
      *    EXEC SQL OPEN...
      *    EXEC SQL FETCH...

           MOVE 'TODO: IMPLEMENTAR FETCH DB2 AQUI' TO MENSAJE1O
           MOVE 'SIMULANDO LECTURA DE LIBROS...' TO MENSAJE2O.

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
