000100*************************************************************
000200* COPYBOOK: USUARIO                                         *
000300* PROPOSITO: ESTRUCTURA DE DATOS PARA USUARIOS             *
000400* AUTOR: GRUPO 4 - ESTUDIANTE KC03B1D                                 *
000500* FECHA: 10/06/2025                                         *
000600*************************************************************
000700*
000800 05 USU-CODIGO              PIC X(10).
000900 05 USU-NOMBRE              PIC X(30).
001000 05 USU-APELLIDO            PIC X(30).
001100 05 USU-TIPO-USUARIO        PIC X(1).
001200     88 USU-ESTUDIANTE      VALUE 'E'.
001300     88 USU-DOCENTE         VALUE 'D'.
001400     88 USU-ADMINISTRATIVO  VALUE 'A'.
001500 05 USU-EMAIL               PIC X(50).
001600 05 USU-TELEFONO            PIC X(20).
001700 05 USU-DIRECCION           PIC X(60).
001800 05 USU-FECHA-ALTA          PIC X(10).
001900 05 USU-FECHA-BAJA          PIC X(10).
002000 05 USU-ESTADO              PIC X(1).
002100     88 USU-ACTIVO          VALUE 'A'.
002200     88 USU-INACTIVO        VALUE 'I'.
002300 05 FILLER                  PIC X(7).
