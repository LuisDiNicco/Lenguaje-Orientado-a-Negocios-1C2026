//DROPGRUX  JOB (UNLAM),'DROP OBJETOS DB2',CLASS=A,MSGCLASS=H,
//         NOTIFY=&SYSUID
//*
//*==============================================================*
//* JCL PARA ELIMINAR TODOS LOS OBJETOS DB2 DEL GRUPO           *
//* SUBSISTEMA: DBDG    BASE DE DATOS: UNLAM                     *
//*                                                              *
//* ACLARACIONES:                                                *
//* I)   EJECUTAR SOLO SI NECESITAN EMPEZAR DE CERO             *
//* II)  SOLO EL OWNER (KC03XXX) PUEDE EJECUTAR ESTE JCL        *
//* III) REEMPLAZAR Z CON EL NUMERO DE GRUPO                     *
//* IV)  REEMPLAZAR KC03XXX CON EL USUARIO OWNER DEL GRUPO      *
//*==============================================================*
//*
//STEP1    EXEC PGM=IKJEFT01,REGION=0M
//STEPLIB  DD DSN=DSND10.SDSNLOAD,DISP=SHR
//         DD DSN=DSND10.DBDG.SDSNEXIT,DISP=SHR
//         DD DSN=DSND10.DBDG.RUNLIB.LOAD,DISP=SHR
//SYSTSPRT DD SYSOUT=*
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *

-- ============================================================
-- PASO 1: DROP DE INDICES SECUNDARIOS
-- ============================================================

  DROP INDEX KC03B1D.ID4_USU_TIPO;
  DROP INDEX KC03B1D.ID4_LIB_CAT;

-- ============================================================
-- PASO 2: DROP DE TABLAS
-- PRESTAMOS PRIMERO POR LAS FOREIGN KEYS
-- LOS INDICES DE PK SE DROPEAN AUTOMATICAMENTE
-- ============================================================

  DROP TABLE KC03B1D.PRESTAMOS;
  DROP TABLE KC03B1D.LIBROS;
  DROP TABLE KC03B1D.USUARIOS;

-- ============================================================
-- PASO 3: DROP DE SECUENCIA
-- ============================================================

  DROP SEQUENCE KC03B1D.SEQ_PRESTAMOS;

  COMMIT;

/*
//SYSTSIN  DD *
  DSN SYSTEM(DBDG)
  RUN PROGRAM(DSNTEP2) PLAN(DSNTEP13)
  END
/*
