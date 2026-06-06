       IDENTIFICATION DIVISION.
       PROGRAM-ID. BIBPRES.
       AUTHOR. GRUPO 4.
       DATE-WRITTEN. 06/06/2026.
      *****************************************************************
      * PROGRAMA: BIBPRES - PRESTAMOS Y DEVOLUCIONES (CICS)          *
      * DESCRIPCION: REGISTRO EN PANTALLA CON VALIDACION EN TIEMPO    *
      *              REAL CONTRA DB2.                                 *
      *****************************************************************

       DATA DIVISION.

       WORKING-STORAGE SECTION.
       COPY DFHAID.
       COPY BIBPRES.

       01  WS-VARIABLES.
           05 WS-MENSAJE             PIC X(60).
           05 WS-FIRST-TIME          PIC X(1) VALUE 'Y'.
              88 PRIMERA-VEZ         VALUE 'Y'.
           05 WS-TRANSACCION         PIC X(1).
              88 ES-PRESTAMO         VALUE 'P'.
              88 ES-DEVOLUCION       VALUE 'D'.

       01  WS-RESP                   PIC S9(8) COMP VALUE 0.

        01  WS-COD-USER              PIC X(10).
        01  WS-COD-LIB               PIC X(10).

      *
      * DECLARACIONES DB2
      *
           EXEC SQL INCLUDE SQLCA END-EXEC.
      *
      * VARIABLES HOST DB2
      *
       01  DCL-USUARIO-PRES.
           05 DCL-UP-CODIGO              PIC X(10).
           05 DCL-UP-TIPO                PIC X(1).
           05 DCL-UP-ESTADO              PIC X(1).
       01  DCL-LIBRO-PRES.
           05 DCL-LP-CODIGO              PIC X(10).
           05 DCL-LP-STOCK-DISP          PIC S9(3) USAGE COMP-3.
           05 DCL-LP-ESTADO              PIC X(1).
       01  DCL-PRESTAMO-PRES.
           05 DCL-PP-NUMERO              PIC S9(8) USAGE COMP-3.
           05 DCL-PP-FECHA-PRESTAMO      PIC X(10).
           05 DCL-PP-FECHA-LIMITE        PIC X(10).
           05 DCL-PP-ESTADO              PIC X(1).
           05 DCL-PP-MULTA               PIC S9(5)V99 USAGE COMP-3.
       01  DCL-CONTADOR-PRESTAMOS-PRES   PIC S9(2) USAGE COMP-3.
      *
      * TODO: COMPLETAR LOGICA DE VALIDACION DB2 EN TIEMPO REAL
      *

       PROCEDURE DIVISION.

       MAIN-LOGIC.
           EVALUATE TRUE
               WHEN EIBCALEN = ZERO
                    PERFORM ENVIAR-MAPA-INICIAL
               WHEN EIBAID = DFHCLEAR
                    PERFORM ENVIAR-MAPA-INICIAL
               WHEN EIBAID = DFHPF3
                    PERFORM VOLVER-AL-MENU
               WHEN EIBAID = DFHENTER
                    PERFORM PROCESAR-TRANSACCION
               WHEN OTHER
                    MOVE 'TECLA NO VALIDA' TO WS-MENSAJE
                    PERFORM ENVIAR-MAPA-CON-DATOS
           END-EVALUATE

           EXEC CICS RETURN
                TRANSID('BIB4')
                COMMAREA(WS-FIRST-TIME)
                LENGTH(1)
           END-EXEC.

      *--------------------------------------------------------------
      *   ENVIAR MAPA INICIAL VACIO
      *--------------------------------------------------------------
       ENVIAR-MAPA-INICIAL.
           MOVE SPACES TO TRATIPOO
           MOVE SPACES TO USUCODIGOO
           MOVE SPACES TO CODCODIGOO
           MOVE SPACES TO MSGO

           EXEC CICS SEND MAP('PRES')
                MAPSET('BIBPRES')
                ERASE
                CURSOR
                RESP(WS-RESP)
           END-EXEC.

      *--------------------------------------------------------------
      *   PROCESAR TRANSACCION (PRESTAMO O DEVOLUCION)
      *--------------------------------------------------------------
       PROCESAR-TRANSACCION.
           EXEC CICS RECEIVE MAP('PRES')
                MAPSET('BIBPRES')
                RESP(WS-RESP)
           END-EXEC.

           IF WS-RESP NOT = DFHRESP(NORMAL)
               MOVE 'ERROR AL RECIBIR MAPA' TO MSGO
               PERFORM ENVIAR-MAPA-CON-DATOS
               EXIT PARAGRAPH
           END-IF

           MOVE TRATIPOI TO WS-TRANSACCION
           MOVE USUCODIGOI TO WS-COD-USER
           MOVE CODCODIGOI TO WS-COD-LIB

           EVALUATE TRUE
               WHEN ES-PRESTAMO
                    PERFORM PROCESAR-PRESTAMO-CICS
               WHEN ES-DEVOLUCION
                    PERFORM PROCESAR-DEVOLUCION-CICS
               WHEN OTHER
                    MOVE 'TIPO INVALIDO (P/D)' TO WS-MENSAJE
           END-EVALUATE

           PERFORM ENVIAR-MAPA-CON-DATOS.

      *--------------------------------------------------------------
      *   PROCESAR PRESTAMO
      *--------------------------------------------------------------
       PROCESAR-PRESTAMO-CICS.
      *    TODO: EXEC SQL PARA VALIDAR USUARIO EXISTE Y ESTA ACTIVO
      *    TODO: EXEC SQL PARA VALIDAR LIBRO EXISTE Y TIENE STOCK
      *    TODO: EXEC SQL PARA VALIDAR TOPE PRESTAMOS USUARIO
      *    TODO: EXEC SQL INSERT INTO PRESTAMOS
      *    TODO: EXEC SQL UPDATE LIBROS SET STOCK DISPONIBLE - 1
           MOVE 'PRESTAMO REGISTRADO OK' TO WS-MENSAJE.

      *--------------------------------------------------------------
      *   PROCESAR DEVOLUCION
      *--------------------------------------------------------------
       PROCESAR-DEVOLUCION-CICS.
      *    TODO: EXEC SQL PARA BUSCAR PRESTAMO PENDIENTE
      *    TODO: EXEC SQL PARA CALCULAR MULTA SI CORRESPONDE
      *    TODO: EXEC SQL UPDATE PRESTAMOS SET ESTADO = 'D'
      *    TODO: EXEC SQL UPDATE LIBROS SET STOCK DISPONIBLE + 1
           MOVE 'DEVOLUCION REGISTRADA OK' TO WS-MENSAJE.

      *--------------------------------------------------------------
      *   ENVIAR MAPA CON DATOS Y MENSAJE
      *--------------------------------------------------------------
       ENVIAR-MAPA-CON-DATOS.
           IF WS-MENSAJE NOT = SPACES
               MOVE WS-MENSAJE TO MSGO
           END-IF

           MOVE SPACES TO WS-MENSAJE
           MOVE SPACES TO TRATIPOO
           MOVE SPACES TO USUCODIGOO
           MOVE SPACES TO CODCODIGOO

           EXEC CICS SEND MAP('PRES')
                MAPSET('BIBPRES')
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
