       IDENTIFICATION DIVISION.
       PROGRAM-ID. CARGINI.
       AUTHOR. GRUPO 4.
       DATE-WRITTEN. 23/05/2026.
       DATE-COMPILED.
      *****************************************************************
      * PROGRAMA: CARGINI - CARGA INICIAL DE LIBROS                   *
      * DESCRIPCION: PROCESA ARCHIVO ENTRADA Y CARGA A BASE DB2       *
      *****************************************************************

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT ARCHIVO-ENTRADA ASSIGN TO ENTRADA
                  ORGANIZATION IS SEQUENTIAL
                  ACCESS MODE IS SEQUENTIAL
                  FILE STATUS IS WS-STATUS-ENTRADA.
           SELECT ARCHIVO-REPORTE ASSIGN TO REPORTE
                  ORGANIZATION IS SEQUENTIAL
                  ACCESS MODE IS SEQUENTIAL
                  FILE STATUS IS WS-STATUS-REPORTE.

       DATA DIVISION.
       FILE SECTION.
       FD  ARCHIVO-ENTRADA
           RECORD CONTAINS 200 CHARACTERS
           BLOCK CONTAINS 0 RECORDS
           DATA RECORD IS REG-ENTRADA.
       01  REG-ENTRADA                PIC X(200).

       FD  ARCHIVO-REPORTE
           RECORDING MODE IS F
           RECORD CONTAINS 133 CHARACTERS
           BLOCK CONTAINS 0 RECORDS
           DATA RECORD IS REG-REPORTE.
       01  REG-REPORTE                PIC X(133).

       WORKING-STORAGE SECTION.
      *
      * CONSTANTES Y VARIABLES DEL SISTEMA
      *
           COPY CONSTANT.
           COPY MENSAJES.
      *
      * CONTADORES Y CONTROL
      *
       01  WS-CONTADORES.
           05 WS-CONT-LEIDOS          PIC 9(7) VALUE ZERO.
           05 WS-CONT-PROCESADOS      PIC 9(7) VALUE ZERO.
           05 WS-CONT-ERRORES         PIC 9(7) VALUE ZERO.
      *
      * VARIABLES DE CONTROL
      *
       01  WS-CONTROL.
           05 WS-FIN-ARCHIVO          PIC X(1) VALUE 'N'.
              88 WS-FIN-ARCHIVO-SI    VALUE 'S'.
           05 WS-RESULTADO            PIC X(1) VALUE 'N'.
              88 WS-RESULTADO-OK      VALUE 'S'.
      *
      * FILE STATUS
      *
       01  WS-FILE-STATUS.
           05 WS-STATUS-ENTRADA       PIC X(2) VALUE '00'.
              88 WS-ENTRADA-OK        VALUE '00'.
              88 WS-ENTRADA-EOF       VALUE '10'.
           05 WS-STATUS-REPORTE       PIC X(2) VALUE '00'.
              88 WS-REPORTE-OK        VALUE '00'.
      *
      * ESTRUCTURA LIBROS
      *
       01  WS-LIBRO-TRABAJO.
           COPY LIBROS.
      *
      * AREAS DE TRABAJO
      *
       01  WS-REGISTRO-ENTRADA.
           05 WS-ENT-CODIGO           PIC X(10).
           05 FILLER                  PIC X(1).
           05 WS-ENT-TITULO           PIC X(60).
           05 FILLER                  PIC X(1).
           05 WS-ENT-AUTOR            PIC X(40).
           05 FILLER                  PIC X(1).
           05 WS-ENT-EDITORIAL        PIC X(30).
           05 FILLER                  PIC X(1).
           05 WS-ENT-ANIO             PIC X(4).
           05 FILLER                  PIC X(1).
           05 WS-ENT-CATEGORIA        PIC X(20).
           05 FILLER                  PIC X(1).
           05 WS-ENT-STOCK            PIC X(3).
           05 FILLER                  PIC X(1).
           05 WS-ENT-UBICACION        PIC X(10).
           05 FILLER                  PIC X(16).
      *
      * LINEAS DE REPORTE
      *
           COPY LINREP.
      *
       01  WS-FECHA-PROCESO           PIC X(10).
       01  WS-NUMERO-PAGINA           PIC 9(3) VALUE 1.
       01  WS-CONTADOR-LINEAS         PIC 9(2) VALUE 99.

      * TODO: AGREGAR DECLARACIONES DE DB2 (EXEC SQL INCLUDE SQLCA) AQUI

       PROCEDURE DIVISION.
      *
      * PROGRAMA PRINCIPAL
      *
       MAIN-PROGRAM.
           PERFORM INICIALIZAR
           PERFORM PROCESAR-ARCHIVO
           PERFORM FINALIZAR
           STOP RUN.
      *
      * RUTINAS PRINCIPALES
      *
       INICIALIZAR.
           DISPLAY 'INICIANDO PROGRAMA CARGINI'
           PERFORM OBTENER-FECHA-PROCESO
           PERFORM ABRIR-ARCHIVOS
           PERFORM ESCRIBIR-CABECERA-REPORTE.

       PROCESAR-ARCHIVO.
           PERFORM LEER-ENTRADA
           PERFORM UNTIL WS-FIN-ARCHIVO-SI
               PERFORM VALIDAR-REGISTRO
               IF WS-RESULTADO-OK
                   PERFORM PROCESAR-REGISTRO
               ELSE
                   PERFORM ESCRIBIR-ERROR
               END-IF
               PERFORM LEER-ENTRADA
           END-PERFORM.
      *
       FINALIZAR.
           PERFORM ESCRIBIR-TOTALES
           PERFORM CERRAR-ARCHIVOS
           DISPLAY 'REGISTROS LEIDOS: ' WS-CONT-LEIDOS
           DISPLAY 'REGISTROS PROCESADOS: ' WS-CONT-PROCESADOS
           DISPLAY 'REGISTROS CON ERROR: ' WS-CONT-ERRORES
           DISPLAY 'PROGRAMA TERMINADO NORMALMENTE'.
      *
      * RUTINAS DE ARCHIVO
      *
       ABRIR-ARCHIVOS.
           OPEN INPUT  ARCHIVO-ENTRADA
           IF NOT WS-ENTRADA-OK
               DISPLAY 'ERROR AL ABRIR ARCHIVO ENTRADA: '
                       WS-STATUS-ENTRADA
               STOP RUN
           END-IF

           OPEN OUTPUT ARCHIVO-REPORTE
           IF NOT WS-REPORTE-OK
               DISPLAY 'ERROR AL ABRIR ARCHIVO REPORTE: '
                       WS-STATUS-REPORTE
               STOP RUN
           END-IF.
      *
       LEER-ENTRADA.
           READ ARCHIVO-ENTRADA INTO WS-REGISTRO-ENTRADA
               AT END MOVE 'S' TO WS-FIN-ARCHIVO
               NOT AT END ADD 1 TO WS-CONT-LEIDOS
           END-READ.
      *
       CERRAR-ARCHIVOS.
           CLOSE ARCHIVO-ENTRADA
           CLOSE ARCHIVO-REPORTE.
      *
      * RUTINAS DE PROCESO
      *
       VALIDAR-REGISTRO.
           MOVE 'S' TO WS-RESULTADO

           IF WS-ENT-CODIGO = SPACES
               MOVE 'N' TO WS-RESULTADO
           END-IF

           IF WS-ENT-TITULO = SPACES
               MOVE 'N' TO WS-RESULTADO
           END-IF

           IF WS-ENT-AUTOR = SPACES
               MOVE 'N' TO WS-RESULTADO
           END-IF

           IF WS-ENT-ANIO NOT NUMERIC
               MOVE 'N' TO WS-RESULTADO
           END-IF

           IF WS-ENT-STOCK NOT NUMERIC
               MOVE 'N' TO WS-RESULTADO
           END-IF.
      *
       PROCESAR-REGISTRO.
           PERFORM MOVER-DATOS-MAESTRO
           PERFORM GUARDAR-EN-DB2
           PERFORM ESCRIBIR-DETALLE-REPORTE
           ADD 1 TO WS-CONT-PROCESADOS.
      *
       MOVER-DATOS-MAESTRO.
           MOVE WS-ENT-CODIGO          TO LIB-CODIGO
           MOVE WS-ENT-TITULO          TO LIB-TITULO
           MOVE WS-ENT-AUTOR           TO LIB-AUTOR
           MOVE WS-ENT-EDITORIAL       TO LIB-EDITORIAL
           MOVE WS-ENT-ANIO            TO LIB-ANIO-PUBLICACION
           MOVE WS-ENT-CATEGORIA       TO LIB-CATEGORIA
           MOVE WS-ENT-STOCK           TO LIB-STOCK-TOTAL
           MOVE WS-ENT-STOCK           TO LIB-STOCK-DISPONIBLE
           MOVE WS-ENT-UBICACION       TO LIB-UBICACION
           MOVE WS-FECHA-PROCESO       TO LIB-FECHA-ALTA
           MOVE 'GRUPO 4'              TO LIB-USUARIO-ALTA
           MOVE 'A'                    TO LIB-ESTADO.
      *
       GUARDAR-EN-DB2.
      *    TODO: Reemplazar este bloque por un EXEC SQL INSERT
      *    cuando aprendan DB2 en clase. Por ahora solo mostramos.
           DISPLAY 'SIMULANDO INSERT EN DB2 PARA: ' LIB-CODIGO.
      *
      * RUTINAS DE REPORTE
      *
       ESCRIBIR-CABECERA-REPORTE.
           IF WS-CONTADOR-LINEAS > 55
               PERFORM SALTO-PAGINA
           END-IF.
      *
       SALTO-PAGINA.
           WRITE REG-REPORTE FROM LINEA-CABECERA-1 AFTER ADVANCING PAGE
           WRITE REG-REPORTE FROM LINEA-CABECERA-2
                 AFTER ADVANCING 1 LINE
           MOVE WS-FECHA-PROCESO TO LIN-FECHA
           MOVE 'REPORTE DE CARGA DE LIBROS' TO LIN-TITULO-REPORTE
           MOVE WS-NUMERO-PAGINA TO LIN-NUMERO-PAGINA
           WRITE REG-REPORTE FROM LINEA-CABECERA-3
                 AFTER ADVANCING 2 LINES
           WRITE REG-REPORTE FROM LINEA-SEPARADOR
                 AFTER ADVANCING 1 LINE
           WRITE REG-REPORTE FROM LINEA-TITULO-LIBROS
                 AFTER ADVANCING 2 LINES
           WRITE REG-REPORTE FROM LINEA-SEPARADOR
                 AFTER ADVANCING 1 LINE
           MOVE 1 TO WS-CONTADOR-LINEAS
           ADD 1 TO WS-NUMERO-PAGINA.
      *
       ESCRIBIR-DETALLE-REPORTE.
           IF WS-CONTADOR-LINEAS > 55
               PERFORM SALTO-PAGINA
           END-IF

           MOVE LIB-CODIGO TO LIN-LIB-CODIGO
           MOVE LIB-TITULO TO LIN-LIB-TITULO
           MOVE LIB-AUTOR TO LIN-LIB-AUTOR
           MOVE LIB-EDITORIAL TO LIN-LIB-EDITORIAL
           MOVE LIB-ANIO-PUBLICACION TO LIN-LIB-ANIO
           MOVE LIB-STOCK-TOTAL TO LIN-LIB-STOCK
           MOVE LIB-UBICACION TO LIN-LIB-UBICACION

           WRITE REG-REPORTE FROM LINEA-DETALLE-LIBRO
                 AFTER ADVANCING 1 LINE
           ADD 1 TO WS-CONTADOR-LINEAS.
      *
       ESCRIBIR-ERROR.
           DISPLAY 'REGISTRO CON ERROR - LINEA: ' WS-CONT-LEIDOS
           DISPLAY 'CODIGO: ' WS-ENT-CODIGO
           ADD 1 TO WS-CONT-ERRORES.
      *
       ESCRIBIR-TOTALES.
           MOVE WS-CONT-LEIDOS TO LIN-TOTAL-REGISTROS
           WRITE REG-REPORTE FROM LINEA-TOTAL-REGISTROS
                 AFTER ADVANCING 3 LINES
           MOVE WS-CONT-ERRORES TO LIN-TOTAL-ERRORES
           WRITE REG-REPORTE FROM LINEA-TOTAL-ERRORES
                 AFTER ADVANCING 1 LINE.
      *
      * RUTINAS DE UTILIDAD
      *
       OBTENER-FECHA-PROCESO.
           ACCEPT WS-FECHA-PROCESO FROM DATE YYYYMMDD
           INSPECT WS-FECHA-PROCESO REPLACING ALL '/' BY '-'.
