      *****************************************************************
      * COPYBOOK: LINREP                                              *
      * PROPOSITO: LAYOUTS DE LINEAS PARA REPORTES                    *
      * AUTOR: GRUPO 4                                                *
      * FECHA: 23/05/2026                                             *
      * VERSION: 1.0                                                  *
      *****************************************************************
      *
      * LINEA DE CABECERA PRINCIPAL
      *
       01 LINEA-CABECERA-1.
          05 FILLER                   PIC X(40) VALUE SPACES.
          05 FILLER                   PIC X(35)
             VALUE 'SISTEMA DE BIBLIOTECA UNIVERSITARIA'.
          05 FILLER                   PIC X(58) VALUE SPACES.

       01 LINEA-CABECERA-2.
          05 FILLER                   PIC X(45) VALUE SPACES.
          05 FILLER                   PIC X(25)
             VALUE 'UNIVERSIDAD DE LA MATANZA'.
          05 FILLER                   PIC X(63) VALUE SPACES.

       01 LINEA-CABECERA-3.
          05 FILLER                   PIC X(5) VALUE 'FECHA'.
          05 FILLER                   PIC X(2) VALUE ': '.
          05 LIN-FECHA                PIC X(10).
          05 FILLER                   PIC X(20) VALUE SPACES.
          05 LIN-TITULO-REPORTE       PIC X(40).
          05 FILLER                   PIC X(40) VALUE SPACES.
          05 FILLER                   PIC X(7) VALUE 'PAGINA '.
          05 LIN-NUMERO-PAGINA        PIC ZZ9.
          05 FILLER                   PIC X(6) VALUE SPACES.

       01 LINEA-SEPARADOR             PIC X(133) VALUE ALL '-'.

      *
      * LINEAS PARA REPORTE DE LIBROS
      *
       01 LINEA-TITULO-LIBROS.
          05 FILLER                   PIC X(10) VALUE 'CODIGO'.
          05 FILLER                   PIC X(2) VALUE SPACES.
          05 FILLER                   PIC X(30) VALUE 'TITULO'.
          05 FILLER                   PIC X(2) VALUE SPACES.
          05 FILLER                   PIC X(20) VALUE 'AUTOR'.
          05 FILLER                   PIC X(2) VALUE SPACES.
          05 FILLER                   PIC X(15) VALUE 'EDITORIAL'.
          05 FILLER                   PIC X(2) VALUE SPACES.
          05 FILLER                   PIC X(4) VALUE 'ANIO'.
          05 FILLER                   PIC X(2) VALUE SPACES.
          05 FILLER                   PIC X(5) VALUE 'STOCK'.
          05 FILLER                   PIC X(2) VALUE SPACES.
          05 FILLER                   PIC X(10) VALUE 'UBICACION'.
          05 FILLER                   PIC X(27) VALUE SPACES.

       01 LINEA-DETALLE-LIBRO.
          05 LIN-LIB-CODIGO           PIC X(10).
          05 FILLER                   PIC X(2) VALUE SPACES.
          05 LIN-LIB-TITULO           PIC X(30).
          05 FILLER                   PIC X(2) VALUE SPACES.
          05 LIN-LIB-AUTOR            PIC X(20).
          05 FILLER                   PIC X(2) VALUE SPACES.
          05 LIN-LIB-EDITORIAL        PIC X(15).
          05 FILLER                   PIC X(2) VALUE SPACES.
          05 LIN-LIB-ANIO             PIC 9(4).
          05 FILLER                   PIC X(2) VALUE SPACES.
          05 LIN-LIB-STOCK            PIC ZZ9.
          05 FILLER                   PIC X(2) VALUE SPACES.
          05 LIN-LIB-UBICACION        PIC X(10).
          05 FILLER                   PIC X(27) VALUE SPACES.

      *
      * LINEAS DE TOTALES
      *
       01 LINEA-TOTAL-REGISTROS.
          05 FILLER                   PIC X(20) VALUE
             'TOTAL DE REGISTROS: '.
          05 LIN-TOTAL-REGISTROS      PIC ZZZ,ZZZ,ZZ9.
          05 FILLER                   PIC X(102) VALUE SPACES.

       01 LINEA-TOTAL-ERRORES.
          05 FILLER                   PIC X(18) VALUE
             'TOTAL DE ERRORES: '.
          05 LIN-TOTAL-ERRORES        PIC ZZZ,ZZZ,ZZ9.
          05 FILLER                   PIC X(104) VALUE SPACES.
