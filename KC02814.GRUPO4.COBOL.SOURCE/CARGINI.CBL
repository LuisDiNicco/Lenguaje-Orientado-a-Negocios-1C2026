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
       SOURCE-COMPUTER. IBM-3090.
       OBJECT-COMPUTER. IBM-3090.
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
           RECORD CONTAINS 500 CHARACTERS
           BLOCK CONTAINS 0 RECORDS
           DATA RECORD IS REG-ENTRADA.
       01  REG-ENTRADA                PIC X(500).

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
            COPY LIBRO.
      *
      * AREAS DE TRABAJO
      *
      * LINEA CSV COMPLETA (500 bytes para admitir campos largos)
      *
       01  WS-CSV-LINE                PIC X(500).
      *
      * CAMPOS PARSEADOS DEL CSV (8 columnas delimitadas por coma)
      *
       01  WS-CSV-FIELDS.
           05 WS-CSV-CODIGO           PIC X(10).
           05 WS-CSV-TITULO           PIC X(60).
           05 WS-CSV-AUTOR            PIC X(40).
           05 WS-CSV-EDITORIAL        PIC X(30).
           05 WS-CSV-ANIO             PIC X(4).
           05 WS-CSV-CATEGORIA        PIC X(20).
           05 WS-CSV-STOCK            PIC X(3).
           05 WS-CSV-UBICACION        PIC X(10).
      *
      * FLAG PARA DETECTAR PRIMER REGISTRO (HEADER DEL CSV)
      *
       01  WS-PRIMER-REGISTRO         PIC X(1) VALUE 'S'.
          88 WS-ES-HEADER             VALUE 'S'.
      *
      * LINEAS DE REPORTE
      *
           COPY LINREP.
      *
       01  WS-FECHA-PROCESO           PIC X(10).
       01  WS-NUMERO-PAGINA           PIC 9(3) VALUE 1.
       01  WS-CONTADOR-LINEAS         PIC 9(2) VALUE 99.

      *
      * DECLARACIONES DB2
      *
           EXEC SQL INCLUDE SQLCA END-EXEC.
      *
      * VARIABLES HOST PARA DB2
      *
       01  DCL-LIBROS.
           05 DCL-LIB-CODIGO            PIC X(10).
           05 DCL-LIB-TITULO            PIC X(60).
           05 DCL-LIB-AUTOR             PIC X(40).
           05 DCL-LIB-EDITORIAL         PIC X(30).
           05 DCL-LIB-ANIO-PUBLICACION  PIC S9(4) USAGE COMP-3.
           05 DCL-LIB-CATEGORIA         PIC X(20).
           05 DCL-LIB-STOCK-TOTAL       PIC S9(3) USAGE COMP-3.
           05 DCL-LIB-STOCK-DISPONIBLE  PIC S9(3) USAGE COMP-3.
           05 DCL-LIB-UBICACION         PIC X(10).
           05 DCL-LIB-FECHA-ALTA        PIC X(10).
           05 DCL-LIB-USUARIO-ALTA      PIC X(8).
           05 DCL-LIB-ESTADO            PIC X(1).

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
           READ ARCHIVO-ENTRADA INTO WS-CSV-LINE
               AT END MOVE 'S' TO WS-FIN-ARCHIVO
               NOT AT END
                   IF WS-ES-HEADER
                       MOVE 'N' TO WS-PRIMER-REGISTRO
                   ELSE
                       PERFORM PARSE-CSV
                       ADD 1 TO WS-CONT-LEIDOS
                   END-IF
           END-READ.
      *
       PARSE-CSV.
      *    Divide la linea CSV en 8 campos delimitados por coma
           MOVE SPACES TO WS-CSV-FIELDS
           UNSTRING WS-CSV-LINE DELIMITED BY ','
               INTO WS-CSV-CODIGO
                    WS-CSV-TITULO
                    WS-CSV-AUTOR
                    WS-CSV-EDITORIAL
                    WS-CSV-ANIO
                    WS-CSV-CATEGORIA
                    WS-CSV-STOCK
                    WS-CSV-UBICACION
           END-UNSTRING.
      *
       CERRAR-ARCHIVOS.
           CLOSE ARCHIVO-ENTRADA
           CLOSE ARCHIVO-REPORTE.
      *
       * RUTINAS DE PROCESO
       *
        VALIDAR-REGISTRO.
            MOVE 'S' TO WS-RESULTADO

            IF WS-CSV-CODIGO = SPACES
                MOVE 'N' TO WS-RESULTADO
            END-IF

            IF WS-CSV-TITULO = SPACES
                MOVE 'N' TO WS-RESULTADO
            END-IF

            IF WS-CSV-AUTOR = SPACES
                MOVE 'N' TO WS-RESULTADO
            END-IF

            IF WS-CSV-ANIO NOT NUMERIC
                MOVE 'N' TO WS-RESULTADO
            END-IF

            IF WS-CSV-STOCK NOT NUMERIC
                MOVE 'N' TO WS-RESULTADO
            END-IF
       *    TODO: Validar que WS-CSV-ANIO este entre 1900 y 2100
       *    TODO: Validar que WS-CSV-STOCK > 0
       *
        PROCESAR-REGISTRO.
       *    TODO: Validar codigo unico antes del INSERT:
       *          EXEC SQL SELECT LIB_CODIGO INTO :DCL-LIB-CODIGO
       *          FROM KC02814.LIBROS
       *          WHERE LIB_CODIGO = :WS-CSV-CODIGO
       *          END-EXEC.
       *          IF SQLCODE = 0 THEN codigo ya existe, error.
            PERFORM MOVER-DATOS-MAESTRO
            PERFORM GUARDAR-EN-DB2
            PERFORM ESCRIBIR-DETALLE-REPORTE
            ADD 1 TO WS-CONT-PROCESADOS.
       *
        MOVER-DATOS-MAESTRO.
            MOVE WS-CSV-CODIGO          TO LIB-CODIGO
            MOVE WS-CSV-TITULO          TO LIB-TITULO
            MOVE WS-CSV-AUTOR           TO LIB-AUTOR
            MOVE WS-CSV-EDITORIAL       TO LIB-EDITORIAL
            MOVE WS-CSV-ANIO            TO LIB-ANIO-PUBLICACION
            MOVE WS-CSV-CATEGORIA       TO LIB-CATEGORIA
            MOVE WS-CSV-STOCK           TO LIB-STOCK-TOTAL
            MOVE WS-CSV-STOCK           TO LIB-STOCK-DISPONIBLE
            MOVE WS-CSV-UBICACION       TO LIB-UBICACION
            MOVE WS-FECHA-PROCESO       TO LIB-FECHA-ALTA
            MOVE 'GRUPO 4'              TO LIB-USUARIO-ALTA
            MOVE 'A'                    TO LIB-ESTADO.
      *
        GUARDAR-EN-DB2.
      *    INSERT EN DB2 - TABLA LIBROS
           MOVE LIB-CODIGO              TO DCL-LIB-CODIGO
           MOVE LIB-TITULO              TO DCL-LIB-TITULO
           MOVE LIB-AUTOR               TO DCL-LIB-AUTOR
           MOVE LIB-EDITORIAL           TO DCL-LIB-EDITORIAL
           MOVE LIB-ANIO-PUBLICACION    TO DCL-LIB-ANIO-PUBLICACION
           MOVE LIB-CATEGORIA           TO DCL-LIB-CATEGORIA
           MOVE LIB-STOCK-TOTAL         TO DCL-LIB-STOCK-TOTAL
           MOVE LIB-STOCK-DISPONIBLE    TO DCL-LIB-STOCK-DISPONIBLE
           MOVE LIB-UBICACION           TO DCL-LIB-UBICACION
           MOVE LIB-FECHA-ALTA          TO DCL-LIB-FECHA-ALTA
           MOVE LIB-USUARIO-ALTA        TO DCL-LIB-USUARIO-ALTA
           MOVE LIB-ESTADO              TO DCL-LIB-ESTADO

           EXEC SQL
               INSERT INTO KC02814.LIBROS
                   (LIB_CODIGO,
                    LIB_TITULO,
                    LIB_AUTOR,
                    LIB_EDITORIAL,
                    LIB_ANIO_PUBLICACION,
                    LIB_CATEGORIA,
                    LIB_STOCK_TOTAL,
                    LIB_STOCK_DISPONIBLE,
                    LIB_UBICACION,
                    LIB_FECHA_ALTA,
                    LIB_USUARIO_ALTA,
                    LIB_ESTADO)
               VALUES
                   (:DCL-LIB-CODIGO,
                    :DCL-LIB-TITULO,
                    :DCL-LIB-AUTOR,
                    :DCL-LIB-EDITORIAL,
                    :DCL-LIB-ANIO-PUBLICACION,
                    :DCL-LIB-CATEGORIA,
                    :DCL-LIB-STOCK-TOTAL,
                    :DCL-LIB-STOCK-DISPONIBLE,
                    :DCL-LIB-UBICACION,
                    :DCL-LIB-FECHA-ALTA,
                    :DCL-LIB-USUARIO-ALTA,
                    :DCL-LIB-ESTADO)
           END-EXEC.

           IF SQLCODE = 0
               DISPLAY 'INSERT DB2 OK: ' LIB-CODIGO
               EXEC SQL COMMIT END-EXEC
           ELSE
               DISPLAY 'ERROR DB2 SQLCODE: ' SQLCODE
                       ' PARA LIBRO: ' LIB-CODIGO
               MOVE 'N' TO WS-RESULTADO
           END-IF.
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
           DISPLAY 'CODIGO: ' WS-CSV-CODIGO
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
            ACCEPT WS-FECHA-PROCESO FROM DATE YYYYMMDD.
