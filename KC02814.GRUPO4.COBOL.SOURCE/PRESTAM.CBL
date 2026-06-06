       IDENTIFICATION DIVISION.
       PROGRAM-ID. PRESTAM.
       AUTHOR. GRUPO 4.
       DATE-WRITTEN. 06/06/2026.
       DATE-COMPILED.
      *****************************************************************
      * PROGRAMA: PRESTAM - PROCESAMIENTO DE PRESTAMOS Y DEVOLUCIONES *
      * DESCRIPCION: PROCESA TRANSACCIONES DE PRESTAMO/DEVOLUCION     *
      *              VALIDA REGLAS DE NEGOCIO Y ACTUALIZA DB2          *
      *****************************************************************

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SOURCE-COMPUTER. IBM-3090.
       OBJECT-COMPUTER. IBM-3090.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT ARCHIVO-TRANSACCIONES ASSIGN TO TRANSAC
                  ORGANIZATION IS SEQUENTIAL
                  ACCESS MODE IS SEQUENTIAL
                  FILE STATUS IS WS-STATUS-TRANS.

           SELECT ARCHIVO-REPORTE ASSIGN TO REPORTE
                  ORGANIZATION IS SEQUENTIAL
                  ACCESS MODE IS SEQUENTIAL
                  FILE STATUS IS WS-STATUS-REPORTE.

       DATA DIVISION.
       FILE SECTION.
       FD  ARCHIVO-TRANSACCIONES
           RECORD CONTAINS 150 CHARACTERS
           BLOCK CONTAINS 0 RECORDS
           DATA RECORD IS REG-TRANSACCION.
       01  REG-TRANSACCION              PIC X(150).

       FD  ARCHIVO-REPORTE
           RECORDING MODE IS F
           RECORD CONTAINS 133 CHARACTERS
           BLOCK CONTAINS 0 RECORDS
           DATA RECORD IS REG-REPORTE.
       01  REG-REPORTE                  PIC X(133).

       WORKING-STORAGE SECTION.
      *
      * CONSTANTES Y VARIABLES DEL SISTEMA
      *
           COPY CONSTANT.
           COPY MENSAJES.
           COPY PRESTAMO.
      *
      * CONTADORES Y CONTROL
      *
       01  WS-CONTADORES.
           05 WS-CONT-LEIDOS            PIC 9(7) VALUE ZERO.
           05 WS-CONT-PROCESADOS        PIC 9(7) VALUE ZERO.
           05 WS-CONT-ERRORES           PIC 9(7) VALUE ZERO.
           05 WS-CONT-PRESTAMOS         PIC 9(7) VALUE ZERO.
           05 WS-CONT-DEVOLUCIONES      PIC 9(7) VALUE ZERO.
      *
      * VARIABLES DE CONTROL
      *
       01  WS-CONTROL.
           05 WS-FIN-ARCHIVO            PIC X(1) VALUE 'N'.
              88 WS-FIN-ARCHIVO-SI      VALUE 'S'.
           05 WS-RESULTADO              PIC X(1) VALUE 'N'.
              88 WS-RESULTADO-OK        VALUE 'S'.
      *
      * FILE STATUS
      *
       01  WS-FILE-STATUS.
           05 WS-STATUS-TRANS           PIC X(2) VALUE '00'.
              88 WS-TRANS-OK            VALUE '00'.
              88 WS-TRANS-EOF           VALUE '10'.
           05 WS-STATUS-REPORTE         PIC X(2) VALUE '00'.
              88 WS-REPORTE-OK          VALUE '00'.
      *
      * REGISTRO DE TRANSACCION ENTRADA
      *
       01  WS-TRANSACCION.
           05 WS-TRANS-TIPO             PIC X(1).
              88 TRANS-PRESTAMO         VALUE 'P'.
              88 TRANS-DEVOLUCION       VALUE 'D'.
           05 FILLER                    PIC X(1).
           05 WS-TRANS-COD-USUARIO      PIC X(10).
           05 FILLER                    PIC X(1).
           05 WS-TRANS-COD-LIBRO        PIC X(10).
           05 FILLER                    PIC X(1).
           05 WS-TRANS-FECHA            PIC X(10).
           05 FILLER                    PIC X(116).
      *
      * AREAS DE TRABAJO PARA REGLAS DE NEGOCIO
      *
       01  WS-DIAS-PRESTAMO             PIC 9(2).
       01  WS-MAX-LIBROS                PIC 9(2).
       01  WS-LIBROS-ACTUALES           PIC 9(2) VALUE ZERO.
       01  WS-STOCK-DISPONIBLE          PIC 9(3) VALUE ZERO.
       01  WS-FECHA-DEVOLUCION          PIC X(10).
       01  WS-FECHA-LIMITE              PIC X(10).
       01  WS-FECHA-PROCESO             PIC X(10).
       01  WS-MULTA-CALCULADA           PIC 9(5)V99 VALUE ZERO.
      *
      * LINEAS DE REPORTE
      *
           COPY LINREP.
      *
       01  WS-NUMERO-PAGINA             PIC 9(3) VALUE 1.
       01  WS-CONTADOR-LINEAS           PIC 9(2) VALUE 99.

      *
      * DECLARACIONES DB2
      *
           EXEC SQL INCLUDE SQLCA END-EXEC.
      *
      * VARIABLES HOST PARA DB2
      *
       01  DCL-PRESTAMO.
           05 DCL-PRES-NUMERO           PIC S9(8) USAGE COMP-3.
           05 DCL-PRES-COD-LIBRO        PIC X(10).
           05 DCL-PRES-COD-USUARIO      PIC X(10).
           05 DCL-PRES-FECHA-PRESTAMO   PIC X(10).
           05 DCL-PRES-FECHA-DEVOLUCION PIC X(10).
           05 DCL-PRES-FECHA-LIMITE     PIC X(10).
           05 DCL-PRES-ESTADO           PIC X(1).
           05 DCL-PRES-MULTA            PIC S9(5)V99 USAGE COMP-3.
           05 DCL-PRES-OBSERVACIONES    PIC X(100).
      *
       01  DCL-LIBRO-STOCK.
           05 DCL-LIB-CODIGO-STK        PIC X(10).
           05 DCL-LIB-STOCK-DISP        PIC S9(3) USAGE COMP-3.
      *
       01  DCL-USUARIO-PREST.
           05 DCL-USU-CODIGO-PREST      PIC X(10).
           05 DCL-USU-TIPO-PREST        PIC X(1).
      *
       01  DCL-CONTADOR-PRESTAMOS       PIC S9(2) USAGE COMP-3.

        PROCEDURE DIVISION.
      *
      * PROGRAMA PRINCIPAL
      *
       MAIN-PROGRAM.
           PERFORM INICIALIZAR
           PERFORM PROCESAR-TRANSACCIONES
           PERFORM FINALIZAR
           STOP RUN.
      *
       INICIALIZAR.
           DISPLAY 'INICIANDO PROGRAMA PRESTAM'
           PERFORM OBTENER-FECHA-PROCESO
           PERFORM ABRIR-ARCHIVOS
           PERFORM ESCRIBIR-CABECERA-REPORTE.
      *
       PROCESAR-TRANSACCIONES.
           PERFORM LEER-TRANSACCION
           PERFORM UNTIL WS-FIN-ARCHIVO-SI
               MOVE 'S' TO WS-RESULTADO
               EVALUATE TRUE
                   WHEN TRANS-PRESTAMO
                        PERFORM PROCESAR-PRESTAMO
                   WHEN TRANS-DEVOLUCION
                        PERFORM PROCESAR-DEVOLUCION
                   WHEN OTHER
                        MOVE 'N' TO WS-RESULTADO
                        DISPLAY 'TIPO TRANSACCION INVALIDO: '
                                WS-TRANS-TIPO
               END-EVALUATE
               IF WS-RESULTADO-OK
                   ADD 1 TO WS-CONT-PROCESADOS
               ELSE
                   ADD 1 TO WS-CONT-ERRORES
               END-IF
               PERFORM LEER-TRANSACCION
           END-PERFORM.
      *
       FINALIZAR.
           PERFORM ESCRIBIR-TOTALES
           PERFORM CERRAR-ARCHIVOS
           DISPLAY 'TRANSACCIONES LEIDAS: ' WS-CONT-LEIDOS
           DISPLAY 'PRESTAMOS PROCESADOS: ' WS-CONT-PRESTAMOS
           DISPLAY 'DEVOLUCIONES PROCESADAS: ' WS-CONT-DEVOLUCIONES
           DISPLAY 'TRANSACCIONES CON ERROR: ' WS-CONT-ERRORES
           DISPLAY 'PROGRAMA TERMINADO NORMALMENTE'.
      *
      * RUTINAS DE ARCHIVO
      *
       ABRIR-ARCHIVOS.
           OPEN INPUT  ARCHIVO-TRANSACCIONES
           IF NOT WS-TRANS-OK
               DISPLAY 'ERROR AL ABRIR ARCHIVO TRANSACCIONES: '
                       WS-STATUS-TRANS
               STOP RUN
           END-IF

           OPEN OUTPUT ARCHIVO-REPORTE
           IF NOT WS-REPORTE-OK
               DISPLAY 'ERROR AL ABRIR ARCHIVO REPORTE: '
                       WS-STATUS-REPORTE
               STOP RUN
           END-IF.
      *
       LEER-TRANSACCION.
           READ ARCHIVO-TRANSACCIONES INTO WS-TRANSACCION
               AT END MOVE 'S' TO WS-FIN-ARCHIVO
               NOT AT END ADD 1 TO WS-CONT-LEIDOS
           END-READ.
      *
       CERRAR-ARCHIVOS.
           CLOSE ARCHIVO-TRANSACCIONES
           CLOSE ARCHIVO-REPORTE.
      *
      * RUTINAS DE PROCESO DE PRESTAMO
      *
       PROCESAR-PRESTAMO.
           PERFORM VALIDAR-USUARIO
           IF WS-RESULTADO-OK
               PERFORM VALIDAR-LIBRO
           END-IF
           IF WS-RESULTADO-OK
               PERFORM VALIDAR-TOPE-USUARIO
           END-IF
           IF WS-RESULTADO-OK
               PERFORM CALCULAR-FECHAS-PRESTAMO
           END-IF
           IF WS-RESULTADO-OK
               PERFORM REGISTRAR-PRESTAMO-DB2
           END-IF
           IF WS-RESULTADO-OK
               ADD 1 TO WS-CONT-PRESTAMOS
               PERFORM ESCRIBIR-DETALLE-REPORTE
           END-IF.
      *
      * RUTINAS DE PROCESO DE DEVOLUCION
      *
       PROCESAR-DEVOLUCION.
           PERFORM VALIDAR-USUARIO
           IF WS-RESULTADO-OK
               PERFORM BUSCAR-PRESTAMO-PENDIENTE
           END-IF
           IF WS-RESULTADO-OK
               PERFORM CALCULAR-MULTA
           END-IF
           IF WS-RESULTADO-OK
               PERFORM REGISTRAR-DEVOLUCION-DB2
           END-IF
           IF WS-RESULTADO-OK
               ADD 1 TO WS-CONT-DEVOLUCIONES
               PERFORM ESCRIBIR-DETALLE-REPORTE
           END-IF.
      *
       * VALIDACIONES DE NEGOCIO
       *
        VALIDAR-USUARIO.
            IF WS-TRANS-COD-USUARIO = SPACES
                MOVE 'N' TO WS-RESULTADO
                DISPLAY 'ERROR: CODIGO USUARIO VACIO'
                EXIT PARAGRAPH
            END-IF.
       *    TODO: EXEC SQL SELECT USU_CODIGO, USU_TIPO_USUARIO
       *          INTO :DCL-USU-CODIGO-PREST, :DCL-USU-TIPO-PREST
       *          FROM KC02814.USUARIOS
       *          WHERE USU_CODIGO = :WS-TRANS-COD-USUARIO
       *            AND USU_ESTADO = 'A'
       *          IF SQLCODE NOT = 0 THEN MOVE 'N' TO WS-RESULTADO
       *          END-EXEC.
       *
       *    TODO: Verificar que el usuario no tenga prestamos vencidos
       *          SELECT COUNT(*) INTO :DCL-CONTADOR-PRESTAMOS
       *          FROM KC02814.PRESTAMOS
       *          WHERE PRES_CODIGO_USUARIO = :WS-TRANS-COD-USUARIO
       *            AND (PRES_ESTADO = 'V'
       *              OR (PRES_ESTADO = 'P'
       *                  AND PRES_FECHA_LIMITE < CURRENT DATE))
       *          IF COUNT > 0 THEN no permitir prestamo (consigna p3)
       *          END-EXEC.
       *
        VALIDAR-LIBRO.
            IF WS-TRANS-COD-LIBRO = SPACES
                MOVE 'N' TO WS-RESULTADO
                DISPLAY 'ERROR: CODIGO LIBRO VACIO'
                EXIT PARAGRAPH
            END-IF.
       *    TODO: EXEC SQL SELECT LIB_STOCK_DISPONIBLE
       *          INTO :DCL-LIB-STOCK-DISP
       *          FROM KC02814.LIBROS
       *          WHERE LIB_CODIGO = :WS-TRANS-COD-LIBRO
       *            AND LIB_ESTADO = 'A'
       *          IF SQLCODE NOT = 0 OR DCL-LIB-STOCK-DISP <= 0
       *          THEN MOVE 'N' TO WS-RESULTADO
       *          END-EXEC.
       *
        VALIDAR-TOPE-USUARIO.
       *    TODO: EXEC SQL SELECT COUNT(*)
       *          INTO :DCL-CONTADOR-PRESTAMOS
       *          FROM KC02814.PRESTAMOS
       *          WHERE PRES_CODIGO_USUARIO = :WS-TRANS-COD-USUARIO
       *            AND PRES_ESTADO = 'P'
       *          END-EXEC.
       *    TODO: Comparar DCL-USU-TIPO-PREST:
       *          'E' -> CONST-MAX-LIBROS-EST (3)
       *          'D' -> CONST-MAX-LIBROS-DOC (10)
       *          'A' -> CONST-MAX-LIBROS-ADM (5)
       *          IF DCL-CONTADOR-PRESTAMOS >= limite THEN error.
       *
        CALCULAR-FECHAS-PRESTAMO.
       *    TODO: Determinar dias segun tipo usuario:
       *          'E' -> MOVE CONST-DIAS-PRESTAMO-EST TO WS-DIAS-PRESTAMO
       *          'D' -> MOVE CONST-DIAS-PRESTAMO-DOC TO WS-DIAS-PRESTAMO
       *          'A' -> MOVE CONST-DIAS-PRESTAMO-ADM TO WS-DIAS-PRESTAMO
       *    TODO: Sumar WS-DIAS-PRESTAMO a WS-FECHA-PROCESO usando
       *          FUNCTION INTEGER-OF-DATE + FUNCTION DATE-OF-INTEGER
       *          para obtener WS-FECHA-LIMITE (formato YYYYMMDD).
       *
        BUSCAR-PRESTAMO-PENDIENTE.
       *    TODO: EXEC SQL SELECT PRES_NUMERO, PRES_FECHA_LIMITE
       *          INTO :DCL-PRES-NUMERO, :DCL-PRES-FECHA-LIMITE
       *          FROM KC02814.PRESTAMOS
       *          WHERE PRES_CODIGO_USUARIO = :WS-TRANS-COD-USUARIO
       *            AND PRES_CODIGO_LIBRO = :WS-TRANS-COD-LIBRO
       *            AND PRES_ESTADO = 'P'
       *          IF SQLCODE NOT = 0 THEN no hay prestamo pendiente
       *          END-EXEC.
       *
        CALCULAR-MULTA.
       *    TODO: Calcular dias de atraso:
       *          dias_atraso = WS-FECHA-PROCESO - PRES-FECHA-LIMITE
       *          usando FUNCTION INTEGER-OF-DATE en ambas fechas
       *          IF dias_atraso > 0 THEN
       *            COMPUTE WS-MULTA-CALCULADA =
       *                    dias_atraso * CONST-MULTA-DIA
       *          ELSE MOVE ZERO TO WS-MULTA-CALCULADA.
       *
       * OPERACIONES DB2
       *
        REGISTRAR-PRESTAMO-DB2.
       *    TODO: EXEC SQL
       *          INSERT INTO KC02814.PRESTAMOS
       *            (PRES_NUMERO, PRES_CODIGO_LIBRO, PRES_CODIGO_USUARIO,
       *             PRES_FECHA_PRESTAMO, PRES_FECHA_DEVOLUCION,
       *             PRES_FECHA_LIMITE, PRES_ESTADO, PRES_MULTA,
       *             PRES_OBSERVACIONES)
       *          VALUES
       *            (NEXT VALUE FOR KC02814.SEQ_PRESTAMOS,
       *             :WS-TRANS-COD-LIBRO, :WS-TRANS-COD-USUARIO,
       *             :WS-FECHA-PROCESO, SPACES,
       *             :WS-FECHA-LIMITE, 'P', 0, SPACES)
       *          END-EXEC.
       *    TODO: EXEC SQL
       *          UPDATE KC02814.LIBROS
       *          SET LIB_STOCK_DISPONIBLE = LIB_STOCK_DISPONIBLE - 1
       *          WHERE LIB_CODIGO = :WS-TRANS-COD-LIBRO
       *          END-EXEC.
       *    TODO: IF SQLCODE = 0 THEN EXEC SQL COMMIT END-EXEC.
       *
        REGISTRAR-DEVOLUCION-DB2.
       *    TODO: EXEC SQL
       *          UPDATE KC02814.PRESTAMOS
       *          SET PRES_ESTADO = 'D',
       *              PRES_FECHA_DEVOLUCION = :WS-FECHA-PROCESO,
       *              PRES_MULTA = :WS-MULTA-CALCULADA
       *          WHERE PRES_NUMERO = :DCL-PRES-NUMERO
       *          END-EXEC.
       *    TODO: EXEC SQL
       *          UPDATE KC02814.LIBROS
       *          SET LIB_STOCK_DISPONIBLE = LIB_STOCK_DISPONIBLE + 1
       *          WHERE LIB_CODIGO = :WS-TRANS-COD-LIBRO
       *          END-EXEC.
       *    TODO: IF SQLCODE = 0 THEN EXEC SQL COMMIT END-EXEC.
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
           MOVE 'REPORTE DE PRESTAMOS Y DEVOLUCIONES'
                 TO LIN-TITULO-REPORTE
           MOVE WS-NUMERO-PAGINA TO LIN-NUMERO-PAGINA
           WRITE REG-REPORTE FROM LINEA-CABECERA-3
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
           DISPLAY 'TRANSACCION PROCESADA OK - TIPO: '
                   WS-TRANS-TIPO
                   ' USUARIO: ' WS-TRANS-COD-USUARIO
                   ' LIBRO: ' WS-TRANS-COD-LIBRO
           ADD 1 TO WS-CONTADOR-LINEAS.
      *
       ESCRIBIR-TOTALES.
           WRITE REG-REPORTE FROM LINEA-SEPARADOR
                 AFTER ADVANCING 3 LINES
           DISPLAY '--- RESUMEN FINAL ---'
           DISPLAY 'PRESTAMOS OK: ' WS-CONT-PRESTAMOS
           DISPLAY 'DEVOLUCIONES OK: ' WS-CONT-DEVOLUCIONES
           DISPLAY 'ERRORES: ' WS-CONT-ERRORES.
      *
      * RUTINAS DE UTILIDAD
      *
        OBTENER-FECHA-PROCESO.
            ACCEPT WS-FECHA-PROCESO FROM DATE YYYYMMDD.
