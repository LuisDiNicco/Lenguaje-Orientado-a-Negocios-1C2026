       IDENTIFICATION DIVISION.
       PROGRAM-ID. USUMANT.
       AUTHOR. GRUPO 4.
       DATE-WRITTEN. 23/05/2026.
      *****************************************************************
      * PROGRAMA: USUMANT - MANTENIMIENTO DE USUARIOS                 *
      * DESCRIPCION: PROCESA ARCHIVO DE NOVEDADES (ALTA/BAJA/MOD)     *
      *****************************************************************

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
      *    TODO: DECLARAR ARCHIVO DE NOVEDADES Y REPORTE
           SELECT ARCHIVO-NOVEDADES ASSIGN TO NOVEDAD
                  ORGANIZATION IS SEQUENTIAL
                  ACCESS MODE IS SEQUENTIAL
                  FILE STATUS IS WS-STATUS-NOV.

       DATA DIVISION.
       FILE SECTION.
       FD  ARCHIVO-NOVEDADES
           RECORD CONTAINS 100 CHARACTERS
           BLOCK CONTAINS 0 RECORDS
           DATA RECORD IS REG-NOVEDAD.
       01  REG-NOVEDAD.
           05 NOV-TIPO-TRANSACCION    PIC X(1).
              88 ES-ALTA              VALUE 'A'.
              88 ES-BAJA              VALUE 'B'.
              88 ES-MODIFICACION      VALUE 'M'.
           05 NOV-DATOS-USUARIO       PIC X(99).

       WORKING-STORAGE SECTION.
       COPY CONSTANT.
       COPY MENSAJES.
       COPY USUARIO.

       01  WS-STATUS-NOV              PIC X(2) VALUE '00'.
           88 WS-NOV-OK               VALUE '00'.
           88 WS-NOV-EOF              VALUE '10'.

       01  WS-ERRORES-VALIDACION.
           05 WS-ERROR-TIPO           PIC X(1) VALUE 'N'.
           05 WS-ERROR-EMAIL          PIC X(1) VALUE 'N'.
           05 TALLY-1                 PIC 9(2) VALUE 0.

      * TODO: DECLARAR AQUI VARIABLES HOST DB2 Y SQLCA
      * EXEC SQL INCLUDE SQLCA END-EXEC

       PROCEDURE DIVISION.

       MAIN-PROGRAM.
           DISPLAY 'INICIANDO MANTENIMIENTO DE USUARIOS'.
      *    TODO: ABRIR ARCHIVOS
      *    TODO: BUCLE DE LECTURA DE NOVEDADES
           PERFORM VALIDAR-REGLAS-NEGOCIO
      *    TODO: CERRAR ARCHIVOS
           DISPLAY 'FIN PROCESO USUMANT'.
           STOP RUN.

      *--------------------------------------------------------------
      * RUTINAS EXTRAIDAS DEL TP LEAN (ADAPTADAS)
      *--------------------------------------------------------------
       VALIDAR-REGLAS-NEGOCIO.
           DISPLAY 'VALIDANDO DATOS DE USUARIO...'.
           PERFORM VALIDAR-TIPO-USUARIO.
           PERFORM VALIDAR-EMAIL.

       VALIDAR-TIPO-USUARIO.
      *    La consigna exige que existan solo 3 tipos
           IF USU-TIPO = 'E' OR USU-TIPO = 'D' OR USU-TIPO = 'A'
               MOVE 'N' TO WS-ERROR-TIPO
           ELSE
               MOVE 'S' TO WS-ERROR-TIPO
               DISPLAY 'ERROR: TIPO DE USUARIO INVALIDO'
           END-IF.

       VALIDAR-EMAIL.
      *    Validacion basica de @ extraida del TP Lean
           MOVE 'S' TO WS-ERROR-EMAIL
           MOVE 0 TO TALLY-1
           INSPECT USU-EMAIL TALLYING TALLY-1 FOR ALL '@'
           IF TALLY-1 = 1
               MOVE 'N' TO WS-ERROR-EMAIL
           ELSE
               DISPLAY 'ERROR: FORMATO DE EMAIL INVALIDO'
           END-IF.

       PROCESAR-ALTA.
      *    TODO: EXEC SQL INSERT INTO USUARIOS...
           CONTINUE.

       PROCESAR-BAJA.
      *    TODO: EXEC SQL UPDATE USUARIOS SET ESTADO = 'I'...
           CONTINUE.

       PROCESAR-MODIFICACION.
      *    TODO: EXEC SQL UPDATE USUARIOS SET...
           CONTINUE.
