INSERT INTO JEFE (JEFE_ID, NOMBRE, VIGENTE, CONTRA, CORREO)
VALUES
(1, 'Dr. Ricardo Hernández López', 1, 'Jefe2024', 'ricardo.hernandez@tecnm.mx'),         -- Departamento Académico

(2, 'Mtra. Laura Martínez Rivas', 1, 'Jefe2024', 'laura.martinez@tecnm.mx'),              -- Dirección General del TecNM

(3, 'Dr. Samuel Pérez Quintana', 1, 'Jefe2024', 'samuel.perez@ddie.tecnm.mx'),            -- DDIE TecNM

(4, 'Ing. Rosa Delgado Araujo', 1, 'Jefe2024', 'rosa.delgado@itculiacan.edu.mx'),         -- Dirección del Instituto Tecnológico

(5, 'Lic. Fernando Ruiz Carrillo', 1, 'Jefe2024', 'fernando.ruiz@organizador.mx'),        -- Instituto Organizador

(6, 'Mtro. Alejandro Jiménez Soto', 1, 'Jefe2024', 'alejandro.jimenez@itculiacan.edu.mx'), -- Desarrollo Académico

(7, 'Dr. Patricia Torres Medina', 1, 'Jefe2024', 'patricia.torres@itculiacan.edu.mx'),    -- Ciencias Básicas (ITC)

(8, 'Lic. Mariana Ortiz Velasco', 1, 'Jefe2024', 'mariana.ortiz@itculiacan.edu.mx');      -- Servicios Escolares


--------------------------------------------


INSERT INTO DEPARTAMENTO (ID_DEPARTAMENTO, JEFE_ID, NOMBRE)
VALUES
(1, 1, 'Departamento Académico'),
(2, 2, 'Dirección General del TecNM'),
(3, 3, 'DDIE del TecNM'),
(4, 4, 'Dirección del Instituto Tecnológico'),
(5, 5, 'Instituto Organizador'),
(6, 6, 'Departamento de Desarrollo Académico'),
(7, 7, 'Departamento de Ciencias Básicas'),
(8, 8, 'Departamento de Servicios Escolares');



-- SALOME -------------------------------------------------------------

INSERT INTO DOCUMENTO (ID_DEPARTAMENTO, NOMBRE, FECHA) VALUES
(1, 'Copia Examen de Grado', NULL),
(1, 'Oficio de Autorización de Apertura', NULL),
(8, 'Constancia con Nombres de Participantes', NULL),
(8, 'Constancia de Participación', NULL),
(8, 'Constancia de Participación', NULL),
(2, 'Oficio de Comisión', NULL),
(3, 'Oficio de Registro de Módulos', NULL);

-- MIGUEL -------------------------------------------------------------

INSERT INTO DOCUMENTO (ID_DEPARTAMENTO, NOMBRE, FECHA) VALUES
(8, 'Constancia de participación en cuerpos colegiados', NULL),
(8, 'Recursos Educativos Digitales', NULL),
(8, 'Formato de implementación de estrategias', NULL),
(8, 'Formato asesorías estudiantes', NULL),
(8, 'Constancia asesoría lugares', NULL),
(4, 'Constancia de participación como jurado', NULL),
(4, 'Participación de comités', NULL),
(2, 'Participación en auditorías de sistemas de gestión', NULL),
(4, 'Constancia de la institución organizadora', NULL),
(4, 'Oficio de Comisión (ITec)', NULL);

-- BR -------------------------------------------------------------

INSERT INTO DOCUMENTO (ID_DEPARTAMENTO, NOMBRE, FECHA) VALUES
(5, 'Oficio Comisión (curso/diplomado)', NULL),
(5, 'Oficio Comisión (curso/diplomado DDIE)', NULL),
(5, 'Oficio Comisión (Formación y Competencias Docentes)', NULL),
(3, 'Constancia DDIE (Competencias de Tutores)', NULL),
(5, 'Oficio Comisión (Ambientes Virtuales)', NULL),
(5, 'Oficio Comisión (Educación Inclusiva)', NULL),
(5, 'Oficio Comisión (Proyecto Estratégico)', NULL),
(6, 'Constancia Cumplimiento SPD', NULL);

-- JESUS -------------------------------------------------------------

INSERT INTO DOCUMENTO (ID_DEPARTAMENTO, NOMBRE, FECHA) VALUES
(7, 'Formato para el Horario de Actividades', NULL),
(5, 'Constancia de Tutoría', NULL),
(8, 'Consejo Nacional de Acreditación', NULL),
(8, 'Constancia de Trabajo', NULL),
(8, 'Constancia de Productos Obtenidos y su Impacto', NULL),
(7, 'Constancia Exención Examen Licenciatura', NULL),
(7, 'Constancia Exención Examen Especialización', NULL),
(7, 'Constancia Exención Examen Maestría', NULL),
(7, 'Constancia Exención Examen Maestría (Codirector)', NULL),
(7, 'Constancia Exención Examen Doctorado', NULL),
(7, 'Constancia Exención Examen Doctorado (Codirector)', NULL),
(7, 'Constancia SINODAL Técnico Superior', NULL),
(7, 'Constancia SINODAL Licenciatura', NULL),
(7, 'Constancia SINODAL Especialización', NULL),
(7, 'Constancia SINODAL Maestría', NULL),
(7, 'Constancia SINODAL Doctorado', NULL);
