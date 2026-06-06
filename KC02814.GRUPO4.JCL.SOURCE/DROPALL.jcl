//DROPALL JOB 1,NOTIFY=&SYSUID,MSGLEVEL=(1,1),MSGCLASS=H
//****************************************************************
//* JCL: DROPALL - ELIMINACION DE OBJETOS DB2                   *
//* ORDEN ELIMINACION:                                           *
//*   1. Tablas con FK -> 2. Tablas padre -> 3. Secuencia        *
//*   Los tablespaces e indices se eliminan automaticamente      *
//****************************************************************
//*
//SQL      EXEC PGM=IKJEFT01,DYNAMNBR=20
//STEPLIB  DD DSN=DSND10.SDSNLOAD,DISP=SHR
//         DD DSN=DSND10.DBDG.SDSNEXIT,DISP=SHR
//         DD DSN=DSND10.DBDG.RUNLIB.LOAD,DISP=SHR
//SYSPRINT DD SYSOUT=*
//SYSTERM  DD SYSOUT=*
//SYSUDUMP DD SYSOUT=*
//SYSOUT   DD SYSOUT=*
//SYSTSIN  DD *
  DSN SYSTEM(DBDG)
  RUN  PROGRAM(DSNTEP2) PLAN(DSNTEP13)
  END
/*
//SYSIN    DD *
-- ORDEN: FK hija primero, luego tablas padre
DROP TABLE KC02814.PRESTAMOS;
COMMIT;
DROP TABLE KC02814.LIBROS;
COMMIT;
DROP TABLE KC02814.USUARIOS;
COMMIT;
DROP SEQUENCE KC02814.SEQ_PRESTAMOS;
COMMIT;
/*
//*
