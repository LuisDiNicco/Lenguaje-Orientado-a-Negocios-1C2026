000100*************************************************************
000200* COPYBOOK: LIBROS                                          *
000300* PROPOSITO: ESTRUCTURA DE DATOS PARA LIBROS               *
000400* AUTOR: GRUPO 4 - ESTUDIANTE KC03B1D                                 *
000500* FECHA: 10/06/2026                                           *
000600*************************************************************
000700*
000800 05 LIB-CODIGO              PIC X(10).
000900 05 LIB-TITULO              PIC X(60).
001000 05 LIB-AUTOR               PIC X(40).
001100 05 LIB-EDITORIAL           PIC X(30).
001200 05 LIB-ANIO-PUBLICACION    PIC 9(4).
001300 05 LIB-CATEGORIA           PIC X(20).
001400 05 LIB-STOCK-TOTAL         PIC 9(3).
001500 05 LIB-STOCK-DISPONIBLE    PIC 9(3).
001600 05 LIB-UBICACION           PIC X(10).
001700 05 LIB-FECHA-ALTA          PIC X(10).
001800 05 LIB-USUARIO-ALTA        PIC X(8).
001900 05 LIB-ESTADO              PIC X(1).
002000     88 LIB-ACTIVO          VALUE 'A'.
002100     88 LIB-INACTIVO        VALUE 'I'.
002200     88 LIB-BAJA            VALUE 'B'.
002300 05 FILLER                  PIC X(23).
