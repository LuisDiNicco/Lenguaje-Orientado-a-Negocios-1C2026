       IDENTIFICATION DIVISION.
       PROGRAM-ID. USUMANT.
       AUTHOR. GRUPO 4.
       DATE-WRITTEN. 06/06/2026.
      *****************************************************************
      * PROGRAMA: USUMANT - MANTENIMIENTO DE USUARIOS                 *
      * DESCRIPCION: PROCESA ARCHIVO DE NOVEDADES (ALTA/BAJA/MOD)     *
      *              Y ACTUALIZA LA BASE DB2                           *
      *****************************************************************

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT ARCHIVO-NOVEDADES ASSIGN TO NOVEDAD
                  ORGANIZATION IS SEQUENTIAL
                  ACCESS MODE IS SEQUENTIAL
                  FILE STATUS IS WS-STATUS-NOV.

           SELECT ARCHIVO-REPORTE ASSIGN TO REPORTE
                  ORGANIZATION IS SEQUENTIAL
                  ACCESS MODE IS SEQUENTIAL
                  FILE STATUS IS WS-STATUS-REPORTE.

       DATA DIVISION.
       FILE SECTION.
       FD  ARCHIVO-NOVEDADES
           RECORD CONTAINS 200 CHARACTERS
           BLOCK CONTAINS 0 RECORDS
           DATA RECORD IS REG-NOVEDAD.
       01  REG-NOVEDAD                 PIC X(200).

       FD  ARCHIVO-REPORTE
           RECORDING MODE IS F
           RECORD CONTAINS 133 CHARACTERS
           BLOCK CONTAINS 0 RECORDS
           DATA RECORD IS REG-REPORTE.
       01  REG-REPORTE                 PIC X(133).

       WORKING-STORAGE SECTION.
      *
      * CONSTANTES Y VARIABLES
      *
           COPY CONSTANT.
           COPY MENSAJES.
           COPY USUARIO.
      *
      * DECLARACIONES DB2
      *
           EXEC SQL INCLUDE SQLCA END-EXEC.
      *
      * VARIABLES HOST PARA DB2
      *
       01  DCL-USUARIO.
           05 DCL-USU-CODIGO            PIC X(10).
           05 DCL-USU-NOMBRE            PIC X(30).
           05 DCL-USU-APELLIDO          PIC X(30).
           05 DCL-USU-TIPO-USUARIO      PIC X(1).
           05 DCL-USU-EMAIL             PIC X(50).
           05 DCL-USU-TELEFONO          PIC X(20).
           05 DCL-USU-DIRECCION         PIC X(60).
           05 DCL-USU-FECHA-ALTA        PIC X(10).
           05 DCL-USU-FECHA-BAJA        PIC X(10).
           05 DCL-USU-ESTADO            PIC X(1).
      *
      * CONTADORES Y CONTROL
      *
       01  WS-CONTADORES.
           05 WS-CONT-LEIDOS            PIC 9(7) VALUE ZERO.
           05 WS-CONT-ALTAS             PIC 9(7) VALUE ZERO.
           05 WS-CONT-BAJAS             PIC 9(7) VALUE ZERO.
           05 WS-CONT-MODIFICACIONES    PIC 9(7) VALUE ZERO.
           05 WS-CONT-ERRORES           PIC 9(7) VALUE ZERO.
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
           05 WS-STATUS-NOV             PIC X(2) VALUE '00'.
              88 WS-NOV-OK              VALUE '00'.
              88 WS-NOV-EOF             VALUE '10'.
           05 WS-STATUS-REPORTE         PIC X(2) VALUE '00'.
              88 WS-REPORTE-OK          VALUE '00'.
      *
      * REGISTRO DE NOVEDAD (ENTRADA)
      *
       01  WS-REGISTRO-NOVEDAD.
           05 WS-NOV-TIPO               PIC X(1).
              88 WS-NOV-ALTA            VALUE 'A'.
              88 WS-NOV-BAJA            VALUE 'B'.
              88 WS-NOV-MODIFICACION    VALUE 'M'.
           05 FILLER                    PIC X(1).
           05 WS-NOV-CODIGO             PIC X(10).
           05 FILLER                    PIC X(1).
           05 WS-NOV-NOMBRE             PIC X(30).
           05 FILLER                    PIC X(1).
           05 WS-NOV-APELLIDO           PIC X(30).
           05 FILLER                    PIC X(1).
           05 WS-NOV-TIPO-USUARIO       PIC X(1).
           05 FILLER                    PIC X(1).
           05 WS-NOV-EMAIL              PIC X(50).
           05 FILLER                    PIC X(1).
           05 WS-NOV-TELEFONO           PIC X(20).
           05 FILLER                    PIC X(1).
           05 WS-NOV-DIRECCION          PIC X(60).
           05 FILLER                    PIC X(1).
      *
      * VARIABLES DE TRABAJO
      *
       01  WS-ERROR-EMAIL               PIC X(1) VALUE 'N'.
       01  WS-TALLY-EMAIL               PIC 9(2) VALUE ZERO.
       01  WS-FECHA-PROCESO             PIC X(10).
      *
      * LINEAS DE REPORTE
      *
           COPY LINREP.
      *
       01  WS-CONTADOR-LINEAS           PIC 9(2) VALUE 99.
       01  WS-NUMERO-PAGINA             PIC 9(3) VALUE 1.

       PROCEDURE DIVISION.
      *
       MAIN-PROGRAM.
           PERFORM INICIALIZAR
           PERFORM PROCESAR-NOVEDADES
           PERFORM FINALIZAR
           STOP RUN.
      *
       INICIALIZAR.
           DISPLAY 'INICIANDO MANTENIMIENTO DE USUARIOS'
           PERFORM OBTENER-FECHA-PROCESO
           PERFORM ABRIR-ARCHIVOS
           PERFORM ESCRIBIR-CABECERA-REPORTE.
      *
       PROCESAR-NOVEDADES.
           PERFORM LEER-NOVEDAD
           PERFORM UNTIL WS-FIN-ARCHIVO-SI
               MOVE 'S' TO WS-RESULTADO
               PERFORM VALIDAR-REGLAS-NEGOCIO
               IF WS-RESULTADO-OK
                   PERFORM EJECUTAR-OPERACION
               ELSE
                   ADD 1 TO WS-CONT-ERRORES
                   DISPLAY 'ERROR EN REGISTRO: ' WS-CONT-LEIDOS
               END-IF
               PERFORM LEER-NOVEDAD
           END-PERFORM.
      *
       FINALIZAR.
           PERFORM ESCRIBIR-TOTALES
           PERFORM CERRAR-ARCHIVOS
           DISPLAY 'REGISTROS LEIDOS: ' WS-CONT-LEIDOS
           DISPLAY 'ALTAS: ' WS-CONT-ALTAS
           DISPLAY 'BAJAS: ' WS-CONT-BAJAS
           DISPLAY 'MODIFICACIONES: ' WS-CONT-MODIFICACIONES
           DISPLAY 'ERRORES: ' WS-CONT-ERRORES
           DISPLAY 'FIN PROCESO USUMANT'.
      *
      * RUTINAS DE ARCHIVO
      *
       ABRIR-ARCHIVOS.
           OPEN INPUT  ARCHIVO-NOVEDADES
           IF NOT WS-NOV-OK
               DISPLAY 'ERROR AL ABRIR ARCHIVO NOVEDADES: '
                       WS-STATUS-NOV
               STOP RUN
           END-IF

           OPEN OUTPUT ARCHIVO-REPORTE
           IF NOT WS-REPORTE-OK
               DISPLAY 'ERROR AL ABRIR ARCHIVO REPORTE: '
                       WS-STATUS-REPORTE
               STOP RUN
           END-IF.
      *
       LEER-NOVEDAD.
           READ ARCHIVO-NOVEDADES INTO WS-REGISTRO-NOVEDAD
               AT END MOVE 'S' TO WS-FIN-ARCHIVO
               NOT AT END ADD 1 TO WS-CONT-LEIDOS
           END-READ.
      *
       CERRAR-ARCHIVOS.
           CLOSE ARCHIVO-NOVEDADES
           CLOSE ARCHIVO-REPORTE.
      *
      * VALIDACIONES
      *
       VALIDAR-REGLAS-NEGOCIO.
           PERFORM VALIDAR-TIPO-USUARIO
           IF WS-RESULTADO-OK
               PERFORM VALIDAR-EMAIL
           END-IF
           IF WS-RESULTADO-OK
               PERFORM VALIDAR-DATOS-OBLIGATORIOS
           END-IF.
      *
       VALIDAR-TIPO-USUARIO.
           IF WS-NOV-TIPO-USUARIO = 'E'
               OR WS-NOV-TIPO-USUARIO = 'D'
               OR WS-NOV-TIPO-USUARIO = 'A'
               CONTINUE
           ELSE
               MOVE 'N' TO WS-RESULTADO
               DISPLAY 'ERROR: TIPO DE USUARIO INVALIDO (E/D/A): '
                       WS-NOV-TIPO-USUARIO
           END-IF.
      *
       VALIDAR-EMAIL.
           MOVE ZERO TO WS-TALLY-EMAIL
           INSPECT WS-NOV-EMAIL TALLYING WS-TALLY-EMAIL
                   FOR ALL '@'
           IF WS-TALLY-EMAIL = 1
               CONTINUE
           ELSE
               MOVE 'N' TO WS-RESULTADO
               DISPLAY 'ERROR: EMAIL INVALIDO: ' WS-NOV-EMAIL
           END-IF.
      *
       VALIDAR-DATOS-OBLIGATORIOS.
           IF WS-NOV-CODIGO = SPACES
               MOVE 'N' TO WS-RESULTADO
               DISPLAY 'ERROR: CODIGO VACIO'
           END-IF
           IF WS-NOV-NOMBRE = SPACES
               MOVE 'N' TO WS-RESULTADO
               DISPLAY 'ERROR: NOMBRE VACIO'
           END-IF
           IF WS-NOV-APELLIDO = SPACES
               MOVE 'N' TO WS-RESULTADO
               DISPLAY 'ERROR: APELLIDO VACIO'
           END-IF.
      *
      * EJECUCION DE OPERACIONES
      *
       EJECUTAR-OPERACION.
           EVALUATE TRUE
               WHEN WS-NOV-ALTA
                    PERFORM PROCESAR-ALTA
               WHEN WS-NOV-BAJA
                    PERFORM PROCESAR-BAJA
               WHEN WS-NOV-MODIFICACION
                    PERFORM PROCESAR-MODIFICACION
               WHEN OTHER
                    MOVE 'N' TO WS-RESULTADO
                    DISPLAY 'ERROR: TIPO TRANSACCION INVALIDO: '
                            WS-NOV-TIPO
           END-EVALUATE.
      *
       PROCESAR-ALTA.
      *    Validar email unico antes del INSERT
           MOVE WS-NOV-EMAIL             TO DCL-USU-EMAIL
           EXEC SQL
               SELECT USU_EMAIL INTO :DCL-USU-EMAIL
               FROM KC02814.USUARIOS
               WHERE USU_EMAIL = :DCL-USU-EMAIL
           END-EXEC.
           IF SQLCODE = 0
               MOVE 'N' TO WS-RESULTADO
               DISPLAY 'ERROR: EMAIL YA EXISTE: ' WS-NOV-EMAIL
               EXIT PARAGRAPH
           END-IF.

           MOVE WS-NOV-CODIGO            TO DCL-USU-CODIGO
           MOVE WS-NOV-NOMBRE            TO DCL-USU-NOMBRE
           MOVE WS-NOV-APELLIDO          TO DCL-USU-APELLIDO
           MOVE WS-NOV-TIPO-USUARIO      TO DCL-USU-TIPO-USUARIO
           MOVE WS-NOV-TELEFONO          TO DCL-USU-TELEFONO
           MOVE WS-NOV-DIRECCION         TO DCL-USU-DIRECCION
           MOVE WS-FECHA-PROCESO         TO DCL-USU-FECHA-ALTA
           MOVE SPACES                   TO DCL-USU-FECHA-BAJA
           MOVE 'A'                      TO DCL-USU-ESTADO

           EXEC SQL
               INSERT INTO KC02814.USUARIOS
                   (USU_CODIGO,
                    USU_NOMBRE,
                    USU_APELLIDO,
                    USU_TIPO_USUARIO,
                    USU_EMAIL,
                    USU_TELEFONO,
                    USU_DIRECCION,
                    USU_FECHA_ALTA,
                    USU_FECHA_BAJA,
                    USU_ESTADO)
               VALUES
                   (:DCL-USU-CODIGO,
                    :DCL-USU-NOMBRE,
                    :DCL-USU-APELLIDO,
                    :DCL-USU-TIPO-USUARIO,
                    :DCL-USU-EMAIL,
                    :DCL-USU-TELEFONO,
                    :DCL-USU-DIRECCION,
                    :DCL-USU-FECHA-ALTA,
                    :DCL-USU-FECHA-BAJA,
                    :DCL-USU-ESTADO)
           END-EXEC.

           IF SQLCODE = 0
               ADD 1 TO WS-CONT-ALTAS
               DISPLAY 'ALTA OK: ' WS-NOV-CODIGO
           ELSE
               MOVE 'N' TO WS-RESULTADO
               DISPLAY 'ERROR DB2 INSERT - SQLCODE: ' SQLCODE
                       ' USUARIO: ' WS-NOV-CODIGO
           END-IF.
      *
       PROCESAR-BAJA.
           MOVE 'B'                      TO DCL-USU-ESTADO
           MOVE WS-FECHA-PROCESO         TO DCL-USU-FECHA-BAJA
           MOVE WS-NOV-CODIGO            TO DCL-USU-CODIGO

           EXEC SQL
               UPDATE KC02814.USUARIOS
               SET USU_ESTADO = :DCL-USU-ESTADO,
                   USU_FECHA_BAJA = :DCL-USU-FECHA-BAJA
               WHERE USU_CODIGO = :DCL-USU-CODIGO
           END-EXEC.

           IF SQLCODE = 0
               ADD 1 TO WS-CONT-BAJAS
               DISPLAY 'BAJA OK: ' WS-NOV-CODIGO
           ELSE
               MOVE 'N' TO WS-RESULTADO
               DISPLAY 'ERROR DB2 BAJA - SQLCODE: ' SQLCODE
                       ' USUARIO: ' WS-NOV-CODIGO
           END-IF.
      *
       PROCESAR-MODIFICACION.
           MOVE WS-NOV-NOMBRE            TO DCL-USU-NOMBRE
           MOVE WS-NOV-APELLIDO          TO DCL-USU-APELLIDO
           MOVE WS-NOV-TIPO-USUARIO      TO DCL-USU-TIPO-USUARIO
           MOVE WS-NOV-EMAIL             TO DCL-USU-EMAIL
           MOVE WS-NOV-TELEFONO          TO DCL-USU-TELEFONO
           MOVE WS-NOV-DIRECCION         TO DCL-USU-DIRECCION
           MOVE WS-NOV-CODIGO            TO DCL-USU-CODIGO

           EXEC SQL
               UPDATE KC02814.USUARIOS
               SET USU_NOMBRE = :DCL-USU-NOMBRE,
                   USU_APELLIDO = :DCL-USU-APELLIDO,
                   USU_TIPO_USUARIO = :DCL-USU-TIPO-USUARIO,
                   USU_EMAIL = :DCL-USU-EMAIL,
                   USU_TELEFONO = :DCL-USU-TELEFONO,
                   USU_DIRECCION = :DCL-USU-DIRECCION
               WHERE USU_CODIGO = :DCL-USU-CODIGO
           END-EXEC.

           IF SQLCODE = 0
               ADD 1 TO WS-CONT-MODIFICACIONES
               DISPLAY 'MODIFICACION OK: ' WS-NOV-CODIGO
           ELSE
               MOVE 'N' TO WS-RESULTADO
               DISPLAY 'ERROR DB2 UPDATE - SQLCODE: ' SQLCODE
                       ' USUARIO: ' WS-NOV-CODIGO
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
           MOVE 'REPORTE MANTENIMIENTO USUARIOS'
                 TO LIN-TITULO-REPORTE
           MOVE WS-NUMERO-PAGINA TO LIN-NUMERO-PAGINA
           WRITE REG-REPORTE FROM LINEA-CABECERA-3
                 AFTER ADVANCING 2 LINES
           WRITE REG-REPORTE FROM LINEA-SEPARADOR
                 AFTER ADVANCING 1 LINE
           MOVE 1 TO WS-CONTADOR-LINEAS
           ADD 1 TO WS-NUMERO-PAGINA.
      *
       ESCRIBIR-DETALLE.
           IF WS-CONTADOR-LINEAS > 55
               PERFORM SALTO-PAGINA
           END-IF
           ADD 1 TO WS-CONTADOR-LINEAS.
      *
       ESCRIBIR-TOTALES.
           DISPLAY '--- RESUMEN FINAL ---'
           DISPLAY 'ALTAS: ' WS-CONT-ALTAS
           DISPLAY 'BAJAS: ' WS-CONT-BAJAS
           DISPLAY 'MODIFICACIONES: ' WS-CONT-MODIFICACIONES
           DISPLAY 'ERRORES: ' WS-CONT-ERRORES.
      *
      * RUTINAS DE UTILIDAD
      *
        OBTENER-FECHA-PROCESO.
            ACCEPT WS-FECHA-PROCESO FROM DATE YYYYMMDD.
