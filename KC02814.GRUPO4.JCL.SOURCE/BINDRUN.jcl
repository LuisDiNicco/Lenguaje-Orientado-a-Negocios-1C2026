//BINDRUN JOB 1,NOTIFY=&SYSUID,MSGLEVEL=(1,1),MSGCLASS=H
//****************************************************************
//* JCL: BINDRUN - BIND DE PLAN DB2 Y EJECUCION DE PROGRAMA     *
//* DESCRIPCION: BINDEA EL PLAN DB2 Y EJECUTA EL PROGRAMA        *
//* USO: REEMPLAZAR <PROGRAMA> POR EL NOMBRE DEL PROGRAMA        *
//****************************************************************
//*
//* ---------------------------------------------------------------
//* PASO 1: BIND DEL PLAN DB2
//* ---------------------------------------------------------------
//BIND     EXEC PGM=IKJEFT01,DYNAMNBR=20
//STEPLIB  DD DSN=DSND10.SDSNLOAD,DISP=SHR
//         DD DSN=DSND10.DBDG.SDSNEXIT,DISP=SHR
//SYSPRINT DD SYSOUT=*
//SYSTERM  DD SYSOUT=*
//SYSUDUMP DD SYSOUT=*
//SYSOUT   DD SYSOUT=*
//DBRMLIB  DD DSN=&SYSUID..DB2.DBRMLIB,DISP=SHR
//SYSTSIN  DD *
  DSN SYSTEM(DBDG)
  BIND PLAN(<PROGRAMA>) -
       MEMBER(<PROGRAMA>) -
       ACTION(REPLACE) -
       VALIDATE(BIND)
  END
/*
//*
//* ---------------------------------------------------------------
//* PASO 2: EJECUCION DEL PROGRAMA
//* ---------------------------------------------------------------
//RUN      EXEC PGM=<PROGRAMA>,COND=(4,LT,BIND)
//STEPLIB  DD DSN=&SYSUID..LOAD.LIBRARY,DISP=SHR
//         DD DSN=DSND10.SDSNLOAD,DISP=SHR
//         DD DSN=DSND10.DBDG.RUNLIB.LOAD,DISP=SHR
//SYSPRINT DD SYSOUT=*
//SYSTERM  DD SYSOUT=*
//SYSUDUMP DD SYSOUT=*
//*
//* ---------------------------------------------------------------
//*  ARCHIVOS DE ENTRADA Y SALIDA (SEGUN PROGRAMA)
//* ---------------------------------------------------------------
//*ENTRADA  DD DSN=&SYSUID..DATA.INPUT,DISP=SHR
//*NOVEDAD  DD DSN=&SYSUID..DATA.NOVEDADES,DISP=SHR
//*REPORTE  DD DSN=&SYSUID..REPORTES.OUTPUT,DISP=(NEW,CATLG,DELETE),
//*            RECFM=FB,LRECL=133,BLKSIZE=32000,
//*            SPACE=(CYL,(1,1))
//*
