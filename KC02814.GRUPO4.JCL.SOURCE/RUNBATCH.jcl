//RUNBATCH JOB 1,NOTIFY=&SYSUID,MSGLEVEL=(1,1),MSGCLASS=H
//****************************************************************
//* JCL: RUNBATCH - EJECUCION DE PROGRAMA COBOL YA COMPILADO     *
//* DESCRIPCION: EJECUTA UN PROGRAMA BATCH DESDE LOAD LIBRARY     *
//* USO: REEMPLAZAR <PROGRAMA> POR EL NOMBRE DEL PROGRAMA        *
//****************************************************************
//*
//STEP1    EXEC PGM=<PROGRAMA>
//STEPLIB  DD DSN=&SYSUID..LOAD.LIBRARY,DISP=SHR
//SYSPRINT DD SYSOUT=*
//SYSTERM  DD SYSOUT=*
//SYSUDUMP DD SYSOUT=*
//*
//* ---------------------------------------------------------------
//*  ARCHIVOS DE ENTRADA (SEGUN EL PROGRAMA)
//* ---------------------------------------------------------------
//ENTRADA  DD DSN=&SYSUID..DATA.INPUT,DISP=SHR
//NOVEDAD  DD DSN=&SYSUID..DATA.NOVEDADES,DISP=SHR
//*
//* ---------------------------------------------------------------
//*  ARCHIVOS DE SALIDA (REPORTES)
//* ---------------------------------------------------------------
//REPORTE  DD DSN=&SYSUID..REPORTES.OUTPUT,
//            DISP=(NEW,CATLG,DELETE),
//            RECFM=FB,LRECL=133,BLKSIZE=32000,
//            SPACE=(CYL,(1,1))
//*
