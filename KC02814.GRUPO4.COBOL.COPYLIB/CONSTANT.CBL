      *****************************************************************
      * COPYBOOK: CONSTANT                                            *
      * PROPOSITO: CONSTANTES DEL SISTEMA DE BIBLIOTECA               *
      * AUTOR: GRUPO 4                                                *
      * FECHA: 23/05/2026                                             *
      * VERSION: 1.0                                                  *
      *****************************************************************
      *
      * CONSTANTES GENERALES
      *
       01 CONSTANTES-SISTEMA.
          05 CONST-NOMBRE-SISTEMA     PIC X(30)
             VALUE 'SISTEMA BIBLIOTECA UNLAM'.
          05 CONST-VERSION            PIC X(5) VALUE 'V1.0'.
          05 CONST-UNIVERSIDAD        PIC X(40)
             VALUE 'UNIVERSIDAD NACIONAL DE LA MATANZA'.
      *
       * CONSTANTES DE BUSINESS RULES (E=3/15, D=10/30, A=5/20)
       *
       01 CONSTANTES-NEGOCIO.
           05 CONST-DIAS-PRESTAMO-EST  PIC 9(2) VALUE 15.
           05 CONST-DIAS-PRESTAMO-DOC  PIC 9(2) VALUE 30.
           05 CONST-DIAS-PRESTAMO-ADM  PIC 9(2) VALUE 20.
           05 CONST-MAX-LIBROS-EST     PIC 9(2) VALUE 03.
           05 CONST-MAX-LIBROS-DOC     PIC 9(2) VALUE 10.
           05 CONST-MAX-LIBROS-ADM     PIC 9(2) VALUE 05.
           05 CONST-MULTA-DIA          PIC 9(3)V99 VALUE 50.00.
      *
      * CONSTANTES DE REPORTES
      *
       01 CONSTANTES-REPORTE.
          05 CONST-LINEAS-PAGINA      PIC 9(2) VALUE 60.
          05 CONST-LINEAS-CABECERA    PIC 9(2) VALUE 05.
          05 CONST-ANCHO-REPORTE      PIC 9(3) VALUE 133.
