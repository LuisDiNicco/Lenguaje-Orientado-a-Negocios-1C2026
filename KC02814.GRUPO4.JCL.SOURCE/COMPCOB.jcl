//COMPCOB JOB 1,NOTIFY=&SYSUID,MSGLEVEL=(1,1),MSGCLASS=H
//****************************************************************
//* JCL: COMPCOB - COMPILACION DE PROGRAMAS COBOL SIN DB2        *
//* DESCRIPCION: COMPILA, LINKEA Y EJECUTA (IGYWCLG)             *
//* USO: REEMPLAZAR <PROGRAMA> POR EL NOMBRE DEL PROGRAMA        *
//****************************************************************
//*
//COBRUN   EXEC IGYWCLG,SRC=<PROGRAMA>
//* ---------------------------------------------------------------
//*  FUENTES COBOL
//* ---------------------------------------------------------------
//COBOL.SYSIN  DD DSN=&SYSUID..COBOL.SOURCE(<PROGRAMA>),DISP=SHR
//*
//* ---------------------------------------------------------------
//*  COPYBOOKS (SI EL PROGRAMA USA COPY)
//* ---------------------------------------------------------------
//COBOL.SYSLIB  DD DSN=&SYSUID..COBOL.COPYLIB,DISP=SHR
//*
//* ---------------------------------------------------------------
//*  SALIDAS DEL COMPILADOR (SYSOUT ESTANDAR)
//* ---------------------------------------------------------------
//COBOL.SYSPRINT DD SYSOUT=*
//COBOL.SYSTERM   DD SYSOUT=*
//*
//* ---------------------------------------------------------------
//*  MODULO EJECUTABLE (LOAD LIBRARY)
//* ---------------------------------------------------------------
//LKED.SYSLMOD  DD DSN=&SYSUID..LOAD.LIBRARY(<PROGRAMA>),DISP=SHR
//*
//* ---------------------------------------------------------------
//*  ARCHIVOS DE ENTRADA/SALIDA PARA EJECUCION (GO STEP)
//*  SE AGREGAN SEGUN LO QUE NECESITE EL PROGRAMA
//* ---------------------------------------------------------------
//*ENTRADA  DD DSN=&SYSUID..DATA.INPUT,DISP=SHR
//*REPORTE  DD DSN=&SYSUID..REPORTES.OUTPUT,DISP=(NEW,CATLG,DELETE),
//*            RECFM=FB,LRECL=133,BLKSIZE=32000,
//*            SPACE=(CYL,(1,1))
//*
