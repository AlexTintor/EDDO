INSERT INTO DOCUMENTO (NOMBRE) VALUES ('Copia Examen de Grado');
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

INSERT INTO DOCUMENTO (NOMBRE) VALUES ('Oficio Comisión (curso/diplomado)');
INSERT INTO DOCUMENTO (NOMBRE) VALUES ('Oficio Comisión (curso/diplomado DDIE)');
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



INSERT INTO EMPLEADO (ID_EMPLEADO, ID_PLAZA, ID_DEPARTAMENTO, NOMBRE, APELLIDO_MAT, APELLIDO_PAT, CAMPUS, VIGENCIA, CONTRA, CORREO, TELEFONO)
VALUES (101, 1, 1, 'Carlos', 'Ramírez', 'González', 'Culiacán', 1, 'pass101', 'carlos.rg@itc.mx', '6671234567');

INSERT INTO EMPLEADO (ID_EMPLEADO, ID_PLAZA, ID_DEPARTAMENTO, NOMBRE, APELLIDO_MAT, APELLIDO_PAT, CAMPUS, VIGENCIA, CONTRA, CORREO, TELEFONO)
VALUES (102, 2, 2, 'María', 'Lozano', 'Hernández', 'Culiacán', 1, 'pass102', 'maria.lh@itc.mx', '6672345678');

INSERT INTO EMPLEADO (ID_EMPLEADO, ID_PLAZA, ID_DEPARTAMENTO, NOMBRE, APELLIDO_MAT, APELLIDO_PAT, CAMPUS, VIGENCIA, CONTRA, CORREO, TELEFONO)
VALUES (103, 1, 3, 'Jorge', 'Pérez', 'Cárdenas', 'Guamúchil', 1, 'pass103', 'jorge.pc@itc.mx', '6673456789');

INSERT INTO EMPLEADO (ID_EMPLEADO, ID_PLAZA, ID_DEPARTAMENTO, NOMBRE, APELLIDO_MAT, APELLIDO_PAT, CAMPUS, VIGENCIA, CONTRA, CORREO, TELEFONO)
VALUES (104, 2, 4, 'Ana', 'Soto', 'Valenzuela', 'Culiacán', 1, 'pass104', 'ana.sv@itc.mx', '6674567890');

INSERT INTO EMPLEADO (ID_EMPLEADO, ID_PLAZA, ID_DEPARTAMENTO, NOMBRE, APELLIDO_MAT, APELLIDO_PAT, CAMPUS, VIGENCIA, CONTRA, CORREO, TELEFONO)
VALUES (105, 1, 5, 'Ricardo', 'Mendoza', 'Torres', 'Los Mochis', 1, 'pass105', 'ricardo.mt@itc.mx', '6675678901');



INSERT INTO DEPARTAMENTO (ID_DEPARTAMENTO, NOMBRE)
VALUES
(1, 'Departamento Académico'),
(2, 'Dirección General del TecNM'),
(3, 'DDIE del TecNM'),
(4, 'Dirección del Instituto Tecnológico'),
(5, 'Instituto Organizador'),
(6, 'Departamento de Desarrollo Académico'),
(7, 'Departamento de Ciencias Básicas'),
(8, 'Departamento de Servicios Escolares');


INSERT INTO PLAZA(ID_PLAZA,HORARIO)
VALUES
(1,'Tiempo completo'),
(2,'Medio tiempo');


