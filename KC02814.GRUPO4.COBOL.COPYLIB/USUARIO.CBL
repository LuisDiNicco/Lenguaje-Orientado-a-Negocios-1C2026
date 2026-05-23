      *****************************************************************
      * COPYBOOK: USUARIO                                             *
      * PROPOSITO: ESTRUCTURA DE DATOS PARA USUARIOS                  *
      * AUTOR: ESTUDIANTE KC03XXX                                     *
      * FECHA: 23/05/2026                                             *
      * VERSION: 1.0                                                  *
      *****************************************************************
      *
      * ESTRUCTURA PRINCIPAL DEL USUARIO
      *
       01 USUARIO-RECORD.
          05 USU-CODIGO               PIC X(10).
          05 USU-NOMBRE               PIC X(30).
          05 USU-APELLIDO             PIC X(30).
          05 USU-TIPO-USUARIO         PIC X(1).
             88 USU-ESTUDIANTE        VALUE 'E'.
             88 USU-DOCENTE           VALUE 'D'.
             88 USU-ADMINISTRATIVO    VALUE 'A'.
          05 USU-EMAIL                PIC X(50).
          05 USU-TELEFONO             PIC X(20).
          05 USU-DIRECCION            PIC X(60).
          05 USU-FECHA-ALTA           PIC X(10).
          05 USU-FECHA-BAJA           PIC X(10).
          05 USU-ESTADO               PIC X(1).
             88 USU-ACTIVO            VALUE 'A'.
             88 USU-INACTIVO          VALUE 'I'.
          05 FILLER                   PIC X(7).
