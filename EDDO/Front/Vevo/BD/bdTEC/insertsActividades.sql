INSERT INTO DOCUMENTO (NOMBRE) VALUES ('Copia Examen de Grado', '{
  "NOMBRE_EGRESADO": "Ricardo Mendoza Torres",
  "NOMBRE_MAESTRIA": "Maestría en Ingeniería en Sistemas Computacionales",
  "NOMBRE_INSTITUTO": "Instituto Tecnológico de Culiacán",
  "CIUDAD_ESTADO": "Culiacán, Sinaloa",
  "DIA": "26",
  "MES": "Noviembre",
  "ANIO": "2025",
  "TITULO_TESIS": "Optimización de Procesos Académicos mediante Sistemas Inteligentes"
}');
INSERT INTO DOCUMENTO (NOMBRE) VALUES ('Oficio de Autorización de Apertura');
INSERT INTO DOCUMENTO (NOMBRE) VALUES ('Constancia con Nombres de Participantes');
INSERT INTO DOCUMENTO (NOMBRE) VALUES ('Constancia de Participación');
INSERT INTO DOCUMENTO (NOMBRE) VALUES ('Constancia de Participación 1.4.8.2');
INSERT INTO DOCUMENTO (NOMBRE) VALUES ('Oficio de Comisión');
INSERT INTO DOCUMENTO (NOMBRE) VALUES ('Oficio de Registro de Módulos');

INSERT INTO DOCUMENTO (NOMBRE) VALUES ('Constancia de participación en cuerpos colegiados');
INSERT INTO DOCUMENTO (NOMBRE) VALUES ('Recursos Educativos Digitales');
INSERT INTO DOCUMENTO (NOMBRE) VALUES ('Formato de implementación de estrategias');
INSERT INTO DOCUMENTO (NOMBRE) VALUES ('Formato asesorías estudiantes');
INSERT INTO DOCUMENTO (NOMBRE) VALUES ('Constancia asesoría lugares');
INSERT INTO DOCUMENTO (NOMBRE) VALUES ('Constancia de participación como jurado');
INSERT INTO DOCUMENTO (NOMBRE) VALUES ('Participación de comités');
INSERT INTO DOCUMENTO (NOMBRE) VALUES ('Participación en auditorías de sistemas de gestión');
INSERT INTO DOCUMENTO (NOMBRE) VALUES ('Constancia de la institución organizadora');
INSERT INTO DOCUMENTO (NOMBRE) VALUES ('Oficio de Comisión (ITec)');

INSERT INTO DOCUMENTO (NOMBRE) VALUES ('Oficio Comisión (curso-diplomado)');
INSERT INTO DOCUMENTO (NOMBRE) VALUES ('Oficio Comisión (curso-diplomado DDIE)');
INSERT INTO DOCUMENTO (NOMBRE) VALUES ('Oficio Comisión (Formación y Competencias Docentes)');
INSERT INTO DOCUMENTO (NOMBRE) VALUES ('Constancia DDIE (Competencias de Tutores)');
INSERT INTO DOCUMENTO (NOMBRE) VALUES ('Oficio Comisión (Ambientes Virtuales)');
INSERT INTO DOCUMENTO (NOMBRE) VALUES ('Oficio Comisión (Educación Inclusiva)');
INSERT INTO DOCUMENTO (NOMBRE) VALUES ('Oficio Comisión (Proyecto Estratégico)');
INSERT INTO DOCUMENTO (NOMBRE) VALUES ('Constancia Cumplimiento SPD');

INSERT INTO DOCUMENTO (NOMBRE) VALUES ('Formato para el Horario de Actividades');
INSERT INTO DOCUMENTO (NOMBRE) VALUES ('Constancia de Tutoría');
INSERT INTO DOCUMENTO (NOMBRE) VALUES ('Consejo Nacional de Acreditación');
INSERT INTO DOCUMENTO (NOMBRE) VALUES ('Constancia de Trabajo');
INSERT INTO DOCUMENTO (NOMBRE) VALUES ('Constancia de Productos Obtenidos y su Impacto');
INSERT INTO DOCUMENTO (NOMBRE) VALUES ('Constancia Exención Examen Licenciatura');
INSERT INTO DOCUMENTO (NOMBRE) VALUES ('Constancia Exención Examen Especialización');
INSERT INTO DOCUMENTO (NOMBRE) VALUES ('Constancia Exención Examen Maestría');
INSERT INTO DOCUMENTO (NOMBRE) VALUES ('Constancia Exención Examen Maestría (Codirector)');
INSERT INTO DOCUMENTO (NOMBRE) VALUES ('Constancia Exención Examen Doctorado');
INSERT INTO DOCUMENTO (NOMBRE) VALUES ('Constancia Exención Examen Doctorado (Codirector)');
INSERT INTO DOCUMENTO (NOMBRE) VALUES ('Constancia SINODAL Técnico Superior');
INSERT INTO DOCUMENTO (NOMBRE) VALUES ('Constancia SINODAL Licenciatura');
INSERT INTO DOCUMENTO (NOMBRE) VALUES ('Constancia SINODAL Especialización');
INSERT INTO DOCUMENTO (NOMBRE) VALUES ('Constancia SINODAL Maestría');
INSERT INTO DOCUMENTO (NOMBRE) VALUES ('Constancia SINODAL Doctorado');

INSERT INTO DEPARTAMENTO (ID_DEPARTAMENTO, JEFE_ID, NOMBRE) VALUES
(1, 1, 'INSTITUTO TECNOLOGICO DE CULIACAN'),  
(2, 2, 'DIRECCION GENERAL'),                 
(3, 3, 'SUBDIRECCION ACADEMICA'),            
(4, 4, 'DEPARTAMENTO ACADEMICO'),            
(5, 5, 'CENTRO DE INFORMACION'),             
(6, 6, 'SERVICIOS ESCOLARES'),               
(7, 7, 'DOCENCIA E INNOVACIÓN EDUCATIVA'),   
(8, 8, 'PRESIDENTA DE ACADEMIA'),            
(9, 9, 'DEPARTAMENTO SISTEMAS Y COMPUTACION'),
(10, 10, 'ACADEMIA DE ING. EN SISTEMAS COMPUTACIONALES'),
(11, 11, 'Ciencias Básicas'),
(12, 12, 'PRESIDENCIA DE CONAIC');


INSERT INTO EMPLEADO (ID_EMPLEADO, ID_PLAZA, ID_DEPARTAMENTO, NOMBRE, APELLIDO_MAT, APELLIDO_PAT, CAMPUS, VIGENCIA, CONTRA, CORREO, TELEFONO)
VALUES (1, 1, 1, 'Carlos', 'Ramírez', 'González', 'Culiacán', 1, 'pass101', 'carlos.rg@itc.mx', '6671234567');

INSERT INTO EMPLEADO (ID_EMPLEADO, ID_PLAZA, ID_DEPARTAMENTO, NOMBRE, APELLIDO_MAT, APELLIDO_PAT, CAMPUS, VIGENCIA, CONTRA, CORREO, TELEFONO)
VALUES (2, 2, 2, 'María', 'Lozano', 'Hernández', 'Culiacán', 1, 'pass102', 'maria.lh@itc.mx', '6672345678');

INSERT INTO EMPLEADO (ID_EMPLEADO, ID_PLAZA, ID_DEPARTAMENTO, NOMBRE, APELLIDO_MAT, APELLIDO_PAT, CAMPUS, VIGENCIA, CONTRA, CORREO, TELEFONO)
VALUES (3, 1, 3, 'Jorge', 'Pérez', 'Cárdenas', 'Guamúchil', 1, 'pass103', 'jorge.pc@itc.mx', '6673456789');

INSERT INTO EMPLEADO (ID_EMPLEADO, ID_PLAZA, ID_DEPARTAMENTO, NOMBRE, APELLIDO_MAT, APELLIDO_PAT, CAMPUS, VIGENCIA, CONTRA, CORREO, TELEFONO)
VALUES (4, 2, 4, 'Ana', 'Soto', 'Valenzuela', 'Culiacán', 1, 'pass104', 'ana.sv@itc.mx', '6674567890');

INSERT INTO EMPLEADO (ID_EMPLEADO, ID_PLAZA, ID_DEPARTAMENTO, NOMBRE, APELLIDO_MAT, APELLIDO_PAT, CAMPUS, VIGENCIA, CONTRA, CORREO, TELEFONO)
VALUES (5, 1, 5, 'Ricardo', 'Mendoza', 'Torres', 'Los Mochis', 1, 'pass105', 'ricardo.mt@itc.mx', '6675678901');

INSERT INTO EMPLEADOSXDOCUMENTO (ID_EMPLEADO, ID_DOCUMENTO, DATOS_JSON)
VALUES 
(5, 1, '{
  "NOMBRE_EGRESADO": "Ricardo Mendoza Torres",
  "NOMBRE_MAESTRIA": "Maestría en Ingeniería en Sistemas Computacionales",
  "NOMBRE_INSTITUTO": "Instituto Tecnológico de Culiacán",
  "CIUDAD_ESTADO": "Culiacán, Sinaloa",
  "DIA": "26",
  "MES": "Noviembre",
  "ANIO": "2025",
  "TITULO_TESIS": "Optimización de Procesos Académicos mediante Sistemas Inteligentes"
}');

INSERT INTO EMPLEADOSXDOCUMENTO (ID_EMPLEADO, ID_DOCUMENTO, DATOS_JSON)
VALUES 
(5, 2, '{
  "NUMERO_OFICIO_AUTORIZACION": "OFI-TEC-2025-432",
  "LUGAR_FECHA_EMISION": "Culiacán, Sinaloa; 26 de Noviembre de 2025",
  "PERSONA_TITULAR_INSTITUTO": "Mtra. Laura Gabriela Rodríguez Salinas",
  "NOMBRE_INSTITUTO": "Instituto Tecnológico de Culiacán",
  "NIVEL": "Superior",
  "NOMBRE_PROGRAMA_ESTUDIO": "Ingeniería en Sistemas Computacionales",
  "CLAVE_TECNM": "24ISC001",
  "PERIODO": "Agosto - Diciembre 2025"
}');

INSERT INTO EMPLEADOSXDOCUMENTO (ID_EMPLEADO, ID_DOCUMENTO, DATOS_JSON)
VALUES 
(5, 3, '{
  "VAR_INSTITUTO": "Instituto Tecnológico de Culiacán",
  "VAR_DEPARTAMENTO": "Departamento de Sistemas y Computación",
  "VAR_LUGAR_FECHA": "Culiacán, Sinaloa; 26 de Noviembre de 2025",
  "VAR_JEFE_NOMBRE": "Ing. Jorge Alberto Valdez Montoya",
  "VAR_NIVEL": "Licenciatura",
  "VAR_PROGRAMA": "Ingeniería en Sistemas Computacionales",
  "VAR_FECHA_INICIO": "10 de Agosto de 2025",
  "VAR_FECHA_FIN": "15 de Diciembre de 2025",
  "VAR_PARTICIPANTES": "Ricardo Mendoza Torres",
  "VAR_SUBDIRECTOR": "Mtro. Luis Fernando Cárdenas Soto"
}');

INSERT INTO EMPLEADOSXDOCUMENTO (ID_EMPLEADO, ID_DOCUMENTO, DATOS_JSON)
VALUES 
(5, 4, '{
  "VAR_NOMBRE_FIRMANTE": "Mtra. Laura Gabriela Rodríguez Salinas",
  "VAR_CARGO_FIRMANTE": "Directora Académica",
  "VAR_INSTITUTO": "Instituto Tecnológico de Culiacán",
  "VAR_PROFESOR": "Ricardo Mendoza Torres",
  "VAR_CLAVE_EMPLEADO": "EMP-005-ISC",
  "VAR_DEPARTAMENTO": "Departamento de Sistemas y Computación",
  "VAR_FECHA_INICIO": "01 de Agosto de 2025",
  "VAR_FECHA_TERMINO": "30 de Noviembre de 2025",
  "VAR_CIUDAD_ESTADO": "Culiacán, Sinaloa",
  "VAR_FECHA_EMISION": "26 de Noviembre de 2025",
  "VAR_FIRMA": "L.G.R.S."
}');
INSERT INTO EMPLEADOSXDOCUMENTO (ID_EMPLEADO, ID_DOCUMENTO, DATOS_JSON)
VALUES 
(5, 5, '{
  "VAR_INSTITUTO": "Instituto Tecnológico de Culiacán",
  "VAR_DEPARTAMENTO": "Departamento de Sistemas y Computación",
  "VAR_LUGAR_FECHA": "Culiacán, Sinaloa; 26 de Noviembre de 2025",
  "VAR_PROFESOR": "Ricardo Mendoza Torres",
  "VAR_JEFE_DEPTO": "Ing. Jorge Alberto Valdez Montoya",
  "VAR_LICENCIATURA": "Ingeniería en Sistemas Computacionales",
  "VAR_FECHA_INICIO": "12 de Agosto de 2025",
  "VAR_FECHA_FIN": "16 de Diciembre de 2025",
  "VAR_LISTA_MODULOS": "Arquitectura de Computadoras, Estructuras de Datos, Programación Web",
  "VAR_SUBDIRECTOR": "Mtro. Luis Fernando Cárdenas Soto"
}');

INSERT INTO EMPLEADOSXDOCUMENTO (ID_EMPLEADO, ID_DOCUMENTO, DATOS_JSON)
VALUES 
(5, 6, '{
  "NOMBRE_INSTITUTO": "Instituto Tecnológico de Culiacán",
  "NUMERO_OFICIO": "OFI-COM-2025-118",
  "LUGAR_FECHA_EMISION": "Culiacán, Sinaloa; 26 de Noviembre de 2025",
  "NOMBRE_PROFESOR_COMISIONADO": "Ricardo Mendoza Torres",
  "NOMBRE_DEPARTAMENTO": "Departamento de Sistemas y Computación",
  "NOMBRE_PROGRAMA_LICENCIATURA": "Ingeniería en Sistemas Computacionales",
  "OBJETIVO": "Participar como responsable académico en actividades de fortalecimiento del programa educativo.",
  "FECHA_INICIO": "02 de Septiembre de 2025",
  "FECHA_TERMINO": "30 de Noviembre de 2025",
  "NOMBRE_TITULAR": "Mtra. Laura Gabriela Rodríguez Salinas",
  "CARGO_TITULAR": "Directora Académica"
}');

INSERT INTO EMPLEADOSXDOCUMENTO (ID_EMPLEADO, ID_DOCUMENTO, DATOS_JSON)
VALUES 
(5, 7, '{
  "VAR_NUM_REGISTRO": "REG-ISC-2025-087",
  "VAR_LUGAR_FECHA": "Culiacán, Sinaloa; 26 de Noviembre de 2025",
  "VAR_DIRECTOR_INSTITUTO": "Ing. Marco Antonio Beltrán Sánchez",
  "VAR_INSTITUTO": "Instituto Tecnológico de Culiacán",
  "VAR_LICENCIATURA": "Ingeniería en Sistemas Computacionales",
  "VAR_TABLA_MODULOS": "Algoritmos, Matemáticas Discretas, Redes de Computadoras",
  "VAR_DIRECTOR_DOCENCIA": "Mtra. Laura Gabriela Rodríguez Salinas"
}');


go
--1.2.2.1
INSERT INTO EMPLEADOSXDOCUMENTO
    (ID_EMPLEADO, ID_DOCUMENTO, DATOS_JSON)
VALUES
    (2, 18, 
    '{"VAR_OFICIO_COMISION": "DDA/CEN-101/2024", 
    "VAR_NOMBRE_DOCENTE": "María Lozano Hernández", 
    "VAR_NOMBRE_CURSO": "Taller de Programación en Python", 
    "VAR_FECHA_INICIO_COMISION": "10 de abril de 2024", 
    "VAR_FECHA_FIN_COMISION": "15 de abril de 2024", 
    "VAR_NOMBRE_JEFE_DDA": "Ana Bertha Soto"}');
--1.2.2.2
INSERT INTO EMPLEADOSXDOCUMENTO
    (ID_EMPLEADO, ID_DOCUMENTO, DATOS_JSON)
VALUES
    (2, 19,
    '{
    "VAR_OFICIO_COMISION": "DDA/DDIE-001/2024",
    "VAR_NOMBRE_DOCENTE": "María Lozano Hernández",
    "VAR_NOMBRE_CURSO": "Desarrollo de Competencias Digitales Docentes",
    "VAR_FECHA_INICIO_COMISION": "10 de marzo de 2024",
    "VAR_FECHA_FIN_COMISION": "10 de abril de 2024",
    "VAR_NOMBRE_JEFE_DDA": "Ana Bertha Soto"}');

--1.2.2.4
INSERT INTO EMPLEADOSXDOCUMENTO
    (ID_EMPLEADO, ID_DOCUMENTO, DATOS_JSON)
VALUES
    (2, 21,
    '{
    "VAR_FOLIO_CONSTANCIA": "DDIE/DFDT-150/2024",
    "VAR_NOMBRE_DOCENTE": "María Lozano Hernández",
    "VAR_DURACION_HRS": "120",
    "VAR_PERIODO": "01 de abril al 30 de junio de 2024",
    "VAR_DIA": "20",
    "VAR_MES": "Julio",
    "VAR_ANIO": "2024",
    "VAR_NOMBRE_DIRECTOR_DDIE": "Mario Alberto González" }');

--1.2.2.5
INSERT INTO EMPLEADOSXDOCUMENTO
    (ID_EMPLEADO, ID_DOCUMENTO, DATOS_JSON)
VALUES
    (2, 22,
    '{"VAR_OFICIO_COMISION": "DDA/RAV-008/2024",
    "VAR_NOMBRE_DOCENTE": "María Lozano Hernández",
    "VAR_NOMBRE_CURSO": "Diplomado Recursos Educativos en Ambientes Virtuales",
    "VAR_FECHA_INICIO_COMISION": "01 de septiembre de 2024",
    "VAR_FECHA_FIN_COMISION": "30 de noviembre de 2024",
    "VAR_NOMBRE_JEFE_DDA": "Ana Bertha Soto"}');

--1.2.2.6
INSERT INTO EMPLEADOSXDOCUMENTO
    (ID_EMPLEADO, ID_DOCUMENTO, DATOS_JSON)
VALUES
    (2, 23,
    '{"VAR_OFICIO_COMISION": "DDA/DEI-001/2024",
    "VAR_NOMBRE_DOCENTE": "María Lozano Hernández",
    "VAR_NOMBRE_CURSO": "Diplomado en Educación Inclusiva para Profesores(as) del TecNM",
    "VAR_FECHA_INICIO_COMISION": "01 de octubre de 2024",
    "VAR_FECHA_FIN_COMISION": "30 de noviembre de 2024",
    "VAR_NOMBRE_JEFE_DDA": "Ana Bertha Soto"}');

--1.2.2.7
INSERT INTO EMPLEADOSXDOCUMENTO
    (ID_EMPLEADO, ID_DOCUMENTO, DATOS_JSON)
VALUES
    (2, 24,
    '{"VAR_OFICIO_COMISION": "DDA/PE-001/2024",
    "VAR_NOMBRE_DOCENTE": "María Lozano Hernández",
    "VAR_NOMBRE_CURSO": "Diplomado en Tecnologías 4.0",
    "VAR_FECHA_INICIO_COMISION": "01 de noviembre de 2024",
    "VAR_FECHA_FIN_COMISION": "30 de diciembre de 2024",
    "VAR_NOMBRE_JEFE_DDA": "Ana Bertha Soto"}');

-- 1.4.1 (Constancia Cumplimiento SPD)
INSERT INTO EMPLEADOSXDOCUMENTO
    (ID_EMPLEADO, ID_DOCUMENTO, DATOS_JSON)
VALUES
    (2, 25,
    '{"VAR_FOLIO_CONSTANCIA": "CB/AAC/15/2024",
    "VAR_NOMBRE_DOCENTE": "María Lozano Hernández",
    "VAR_ASIGNATURA_ASESORIA": "Cálculo Integral",
    "VAR_PERIODO_CONSTANCIA": "Agosto - Diciembre 2024",
    "VAR_TOTAL_ESTUDIANTES": "12",
    "VAR_DIA_CONSTANCIA": "15",
    "VAR_MES_CONSTANCIA": "Enero",
    "VAR_ANIO_CONSTANCIA": "2024",
    "VAR_NOMBRE_JEFE_CB": "Dr. Juan Carlos Soria",
    "VAR_NOMBRE_SUBDIRECTOR_ACADEMICO": "M.C. Rigoberto Tarín Salazar"}');