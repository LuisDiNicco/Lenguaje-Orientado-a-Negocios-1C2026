       IDENTIFICATION DIVISION.
       PROGRAM-ID. BIBMENU.
       AUTHOR. GRUPO 4.
       DATE-WRITTEN. 23/05/2026.
      *****************************************************************
      * PROGRAMA: BIBMENU - MENU PRINCIPAL                            *
      * DESCRIPCION: GESTIONA LA NAVEGACION DEL SISTEMA CICS          *
      *****************************************************************

       DATA DIVISION.

       WORKING-STORAGE SECTION.
       COPY DFHAID.
       COPY BIBMENU.

       01  WS-VARIABLES.
           05 WS-OPCION        PIC X(1).
           05 WS-MENSAJE       PIC X(60).
           05 WS-FIRST-TIME    PIC X(1) VALUE 'Y'.
              88 PRIMERA-VEZ   VALUE 'Y'.
           05 WS-MSG-SALIDA    PIC X(28)
                                VALUE 'GRACIAS POR USAR EL SISTEMA'.

       01  WS-RESP             PIC S9(8) COMP VALUE 0.

       PROCEDURE DIVISION.

       MAIN-LOGIC.
           EVALUATE TRUE
               WHEN EIBCALEN = ZERO
                    PERFORM ENVIAR-MAPA-INICIAL
               WHEN EIBAID = DFHCLEAR
                    PERFORM ENVIAR-MAPA-INICIAL
               WHEN EIBAID = DFHPF3
                    PERFORM TERMINAR-TRANSACCION
               WHEN EIBAID = DFHENTER
                    PERFORM PROCESAR-OPCION
               WHEN OTHER
                    MOVE 'TECLA NO VALIDA' TO WS-MENSAJE
                    PERFORM ENVIAR-MAPA-CON-DATOS
           END-EVALUATE

           EXEC CICS RETURN
                TRANSID('BIB0')
                COMMAREA(WS-FIRST-TIME)
                LENGTH(1)
           END-EXEC.

      *--------------------------------------------------------------
      *   MAPA VACIO INICIAL
      *--------------------------------------------------------------
       ENVIAR-MAPA-INICIAL.
           MOVE SPACES TO OPCIONO
           MOVE SPACES TO MENSAJE1O

           EXEC CICS SEND MAP('MENU')
                MAPSET('BIBMENU')
                ERASE
                CURSOR
                RESP(WS-RESP)
           END-EXEC.

      *--------------------------------------------------------------
      *   PROCESAR OPCION DEL MENU
      *--------------------------------------------------------------
       PROCESAR-OPCION.
           EXEC CICS RECEIVE MAP('MENU')
                MAPSET('BIBMENU')
                RESP(WS-RESP)
           END-EXEC.

           IF WS-RESP NOT = DFHRESP(NORMAL)
               MOVE 'ERR REC MAP' TO MENSAJE1O
               PERFORM ENVIAR-MAPA-CON-DATOS
               EXIT PARAGRAPH
           END-IF

           MOVE OPCIONI TO WS-OPCION

           EVALUATE WS-OPCION
               WHEN '1'
                    EXEC CICS XCTL PROGRAM('BIBCONS') END-EXEC
               WHEN '2'
                    MOVE 'MODULO USUARIOS ES BATCH (USUMANT)' TO WS-MENSAJE
               WHEN '3'
                    EXEC CICS XCTL PROGRAM('BIBPRES') END-EXEC
               WHEN '4'
                    MOVE 'MODULO REPORTES ES BATCH (REPORTES)' TO WS-MENSAJE
               WHEN 'X'
               WHEN 'x'
                    PERFORM TERMINAR-TRANSACCION
               WHEN OTHER
                    MOVE 'OPCION INVALIDA (1-4,X)' TO WS-MENSAJE
           END-EVALUATE

           PERFORM ENVIAR-MAPA-CON-DATOS.

      *--------------------------------------------------------------
      *   ENVIAR MAPA CON DATOS O MENSAJE
      *--------------------------------------------------------------
       ENVIAR-MAPA-CON-DATOS.
           IF WS-MENSAJE NOT = SPACES
              MOVE WS-MENSAJE TO MENSAJE1O
           END-IF

           MOVE SPACES TO WS-MENSAJE
           MOVE SPACES TO OPCIONO

           EXEC CICS SEND MAP('MENU')
                MAPSET('BIBMENU')
                CURSOR
                RESP(WS-RESP)
           END-EXEC.

      *--------------------------------------------------------------
      *   SALIDA DEL PROGRAMA
      *--------------------------------------------------------------
       TERMINAR-TRANSACCION.
           EXEC CICS SEND TEXT
                FROM(WS-MSG-SALIDA)
                LENGTH(28)
                ERASE
           END-EXEC.

           EXEC CICS RETURN
           END-EXEC.
