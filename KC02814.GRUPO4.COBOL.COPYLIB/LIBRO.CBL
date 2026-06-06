      *****************************************************************
       * COPYBOOK: LIBRO                                               *
       * PROPOSITO: ESTRUCTURA DE DATOS PARA LIBROS                    *
      * AUTOR: GRUPO 4                                                *
      * FECHA: 23/05/2026                                             *
      * VERSION: 1.0                                                  *
      *****************************************************************
      *
      * ESTRUCTURA PRINCIPAL DEL LIBRO
      *
       01 LIBRO-RECORD.
          05 LIB-CODIGO               PIC X(10).
          05 LIB-TITULO               PIC X(60).
          05 LIB-AUTOR                PIC X(40).
          05 LIB-EDITORIAL            PIC X(30).
          05 LIB-ANIO-PUBLICACION     PIC 9(4).
          05 LIB-CATEGORIA            PIC X(20).
          05 LIB-STOCK-TOTAL          PIC 9(3).
          05 LIB-STOCK-DISPONIBLE     PIC 9(3).
          05 LIB-UBICACION            PIC X(10).
          05 LIB-FECHA-ALTA           PIC X(10).
          05 LIB-USUARIO-ALTA         PIC X(8).
          05 LIB-ESTADO               PIC X(1).
             88 LIB-ACTIVO            VALUE 'A'.
             88 LIB-INACTIVO          VALUE 'I'.
             88 LIB-BAJA              VALUE 'B'.
          05 FILLER                   PIC X(23).
