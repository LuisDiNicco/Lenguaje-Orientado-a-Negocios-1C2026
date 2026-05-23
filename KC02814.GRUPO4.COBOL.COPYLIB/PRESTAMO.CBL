      *****************************************************************
      * COPYBOOK: PRESTAMO                                            *
      * PROPOSITO: ESTRUCTURA DE DATOS PARA PRESTAMOS                 *
      * AUTOR: GRUPO 4                                                *
      * FECHA: 23/05/2026                                             *
      * VERSION: 1.0                                                  *
      *****************************************************************
      *
      * ESTRUCTURA PRINCIPAL DEL PRESTAMO
      *
       01 PRESTAMO-RECORD.
          05 PRES-NUMERO              PIC 9(8).
          05 PRES-CODIGO-LIBRO        PIC X(10).
          05 PRES-CODIGO-USUARIO      PIC X(10).
          05 PRES-FECHA-PRESTAMO      PIC X(10).
          05 PRES-FECHA-DEVOLUCION    PIC X(10).
          05 PRES-FECHA-LIMITE        PIC X(10).
          05 PRES-ESTADO              PIC X(1).
             88 PRES-PENDIENTE        VALUE 'P'.
             88 PRES-DEVUELTO         VALUE 'D'.
             88 PRES-VENCIDO          VALUE 'V'.
          05 PRES-MULTA               PIC 9(5)V99.
          05 PRES-OBSERVACIONES       PIC X(100).
          05 FILLER                   PIC X(11).
