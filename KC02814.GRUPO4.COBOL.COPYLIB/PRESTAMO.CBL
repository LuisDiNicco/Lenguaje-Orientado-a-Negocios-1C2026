000100*************************************************************
000200* COPYBOOK: PRESTAMO                                        *
000300* PROPOSITO: ESTRUCTURA DE DATOS PARA PRESTAMOS            *
000400* AUTOR: GRUPO 4 - ESTUDIANTE KC03B1D                                 *
000500* FECHA: 10/06/2025                                           *
000600*************************************************************
000700*
000800 05 PRES-NUMERO             PIC 9(8).
000900 05 PRES-CODIGO-LIBRO       PIC X(10).
001000 05 PRES-CODIGO-USUARIO     PIC X(10).
001100 05 PRES-FECHA-PRESTAMO     PIC X(10).
001200 05 PRES-FECHA-DEVOLUCION   PIC X(10).
001300 05 PRES-FECHA-LIMITE       PIC X(10).
001400 05 PRES-ESTADO             PIC X(1).
001500     88 PRES-PENDIENTE      VALUE 'P'.
001600     88 PRES-DEVUELTO       VALUE 'D'.
001700     88 PRES-VENCIDO        VALUE 'V'.
001800 05 PRES-MULTA              PIC 9(5)V99.
001900 05 PRES-OBSERVACIONES      PIC X(100).
002000 05 FILLER                  PIC X(11).
