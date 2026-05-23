      *****************************************************************
      * COPYBOOK: MENSAJES                                            *
      * PROPOSITO: MENSAJES DEL SISTEMA                               *
      * AUTOR: GRUPO 4                                                *
      * FECHA: 23/05/2026                                             *
      * VERSION: 1.0                                                  *
      *****************************************************************
      *
      * MENSAJES DE ERROR
      *
       01 MENSAJES-ERROR.
          05 MSG-ERR-001              PIC X(60)
             VALUE 'ERROR: CODIGO DE LIBRO INVALIDO O VACIO'.
          05 MSG-ERR-002              PIC X(60)
             VALUE 'ERROR: TITULO DE LIBRO REQUERIDO'.
          05 MSG-ERR-003              PIC X(60)
             VALUE 'ERROR: AUTOR REQUERIDO'.
          05 MSG-ERR-004              PIC X(60)
             VALUE 'ERROR: ANIO DE PUBLICACION INVALIDO'.
          05 MSG-ERR-005              PIC X(60)
             VALUE 'ERROR: STOCK DEBE SER NUMERICO Y POSITIVO'.
          05 MSG-ERR-006              PIC X(60)
             VALUE 'ERROR: LIBRO YA EXISTE EN EL SISTEMA'.
          05 MSG-ERR-007              PIC X(60)
             VALUE 'ERROR: USUARIO NO ENCONTRADO'.
          05 MSG-ERR-008              PIC X(60)
             VALUE 'ERROR: USUARIO TIENE PRESTAMOS PENDIENTES'.
      *
      * MENSAJES INFORMATIVOS
      *
       01 MENSAJES-INFO.
          05 MSG-INFO-001             PIC X(60)
             VALUE 'LIBRO CARGADO EXITOSAMENTE'.
          05 MSG-INFO-002             PIC X(60)
             VALUE 'USUARIO REGISTRADO EXITOSAMENTE'.
          05 MSG-INFO-003             PIC X(60)
             VALUE 'PRESTAMO REGISTRADO EXITOSAMENTE'.
          05 MSG-INFO-004             PIC X(60)
             VALUE 'DEVOLUCION PROCESADA EXITOSAMENTE'.
