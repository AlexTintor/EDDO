/*DROP DATABASE TEC_FINAL
GO*/
CREATE DATABASE TECF
GO 
USE TECF
GO

-- =============================================
-- 1. CREACIÓN DE TABLAS DE CATÁLOGO (Entidades Principales)
-- =============================================

-- 1.1 CORRECCIÓN: TIPO_EMPLEADO (En lugar de TIPO_EMPLEDADO)
CREATE TABLE TIPO_EMPLEADO (
    ID_TIPO INT IDENTITY(1,1) PRIMARY KEY,
    NOM_TIPO VARCHAR(150) NOT NULL
);

-- 1.2 TIPO_ACTIVIDAD
CREATE TABLE TIPO_ACTIVIDAD (
    ID_TIPO_ACTIVIDAD INT IDENTITY(1,1) PRIMARY KEY,
    NOM_TIPO VARCHAR(150) NOT NULL
);

-- 1.3 Plaza
CREATE TABLE Plaza (
    ID_PLAZA INT IDENTITY(1,1) PRIMARY KEY,
    HORARIO VARCHAR(100)
);

-- =============================================
-- 2. CREACIÓN DE TABLAS DEPENDIENTES
-- =============================================

-- 2.1 DEPARTAMENTO (CORRECCIÓN: Ya no depende de TIPO_DEPARTAMENTO)
CREATE TABLE DEPARTAMENTO (
    ID_DEPARTAMENTO INT IDENTITY(1,1) PRIMARY KEY,
    NOM_DEPARTAMENTO VARCHAR(200) NOT NULL
);

-- 2.2 ACTIVIDAD
CREATE TABLE ACTIVIDAD (
    ID_ACTIVIDAD INT IDENTITY(1,1) PRIMARY KEY,
    ID_TIPO_ACTIVIDAD INT NOT NULL,
    NOM_ACTIVIDAD VARCHAR(255) NOT NULL,
    REQUISITO VARCHAR(1000),
    DESCRIPCION VARCHAR(MAX),
    
    FOREIGN KEY (ID_TIPO_ACTIVIDAD) REFERENCES TIPO_ACTIVIDAD(ID_TIPO_ACTIVIDAD)
);

-- 2.3 EMPLEADO
CREATE TABLE EMPLEADO (
    ID_EMPLEADO INT IDENTITY(1,1) PRIMARY KEY,
    ID_PLAZA INT NOT NULL,
    RFC VARCHAR(13) NOT NULL UNIQUE,
    NOMBRE_EMP VARCHAR(150),
    APELLIDO_PAT VARCHAR(100),
    APELLIDO_MAT VARCHAR(100),
    CORREO VARCHAR(255) NOT NULL UNIQUE,
    CONTRASEÑA VARCHAR(255) NOT NULL,
    
    FOREIGN KEY (ID_PLAZA) REFERENCES Plaza(ID_PLAZA)
);

-- =============================================
-- 3. CREACIÓN DE TABLAS INTERMEDIAS (Relaciones M-M)
-- =============================================

-- 3.1 TIPO_EMPLEADO_EMPLEADO
CREATE TABLE TIPO_EMPLEADO_EMPLEADO (
    ID_TIPO INT NOT NULL,
    ID_EMPLEADO INT NOT NULL,
    
    PRIMARY KEY (ID_TIPO, ID_EMPLEADO),
    FOREIGN KEY (ID_TIPO) REFERENCES TIPO_EMPLEADO(ID_TIPO),
    FOREIGN KEY (ID_EMPLEADO) REFERENCES EMPLEADO(ID_EMPLEADO)
);

-- 3.2 EMPLEADO_DEPARTAMENTO
CREATE TABLE EMPLEADO_DEPARTAMENTO (
    ID_DEPARTAMENTO INT NOT NULL,
    ID_EMPLEADO INT NOT NULL,
    
    PRIMARY KEY (ID_DEPARTAMENTO, ID_EMPLEADO),
    FOREIGN KEY (ID_DEPARTAMENTO) REFERENCES DEPARTAMENTO(ID_DEPARTAMENTO),
    FOREIGN KEY (ID_EMPLEADO) REFERENCES EMPLEADO(ID_EMPLEADO)
);

-- 3.3 EMPLEADOS_ACTIVIDADES
CREATE TABLE EMPLEADOS_ACTIVIDADES (
    ID_EMPLEADO INT NOT NULL,
    ID_ACTIVIDAD INT NOT NULL,
    
    PRIMARY KEY (ID_EMPLEADO, ID_ACTIVIDAD),
    FOREIGN KEY (ID_EMPLEADO) REFERENCES EMPLEADO(ID_EMPLEADO),
    FOREIGN KEY (ID_ACTIVIDAD) REFERENCES ACTIVIDAD(ID_ACTIVIDAD)
);

-- =============================================
-- 4. INSERCIÓN DE DATOS DE EJEMPLO
-- =============================================

-- TIPO_EMPLEADO (ID 1-3)
INSERT INTO TIPO_EMPLEADO (NOM_TIPO) VALUES 
('Docente Titular'), 
('Investigador Asociado'), 
('Personal Administrativo');

-- TIPO_ACTIVIDAD (ID 1-3)
INSERT INTO TIPO_ACTIVIDAD (NOM_TIPO) VALUES 
('Clase Semanal'), 
('Proyecto I+D'), 
('Reunión Administrativa');

-- Plaza (ID 1-3)
INSERT INTO Plaza (HORARIO) VALUES 
('L-V 8:00 a 16:00'), 
('Turno Vespertino'), 
('Horario Flexible');

-- DEPARTAMENTO (ID 1-3)
INSERT INTO DEPARTAMENTO (NOM_DEPARTAMENTO) VALUES 
('Sistemas Computacionales'), 
('Recursos Humanos'), 
('Centro de Nanotecnología');

-- ACTIVIDAD (ID 1-3)
INSERT INTO ACTIVIDAD (ID_TIPO_ACTIVIDAD, NOM_ACTIVIDAD, REQUISITO, DESCRIPCION) VALUES 
(1, 'Algoritmos y Estructuras', 'Maestría en CS', 'Impartición de la materia base.'), 
(2, 'Desarrollo de Sensor Óptico', 'Doctorado en Optoelectrónica', 'Investigación en nuevos materiales.'), 
(3, 'Junta de Fin de Mes', 'Ninguno', 'Revisión de métricas de desempeño.');

-- EMPLEADO (ID 1-4)
INSERT INTO EMPLEADO (ID_PLAZA, RFC, NOMBRE_EMP, APELLIDO_PAT, APELLIDO_MAT, CORREO, CONTRASEÑA) VALUES 
(1, 'AIGR801020XYZ', 'Andrea', 'Ibarra', 'García', 'andrea.i@tec.mx', 'hash1'), -- 1
(2, 'BERJ750515ABC', 'Benito', 'Estrada', 'Rojas', 'benito.e@tec.mx', 'hash2'), -- 2
(3, 'CARL900101DEF', 'Carlos', 'López', 'Ruiz', 'carlos.l@tec.mx', 'hash3'),   -- 3
(1, 'DIAM851122GHI', 'Diana', 'Méndez', 'Vargas', 'diana.m@tec.mx', 'hash4'); -- 4

-- =============================================
-- 5. POBLACIÓN DE RELACIONES M-M
-- =============================================

-- TIPO_EMPLEADO_EMPLEADO (Asignación de roles)
INSERT INTO TIPO_EMPLEADO_EMPLEADO (ID_TIPO, ID_EMPLEADO) VALUES 
(1, 1), -- Andrea: Docente Titular
(2, 1), -- Andrea: Investigador Asociado (Doble Rol)
(2, 2), -- Benito: Investigador Asociado
(3, 3); -- Carlos: Personal Administrativo

-- EMPLEADO_DEPARTAMENTO (Asignación de Empleados a Departamentos)
INSERT INTO EMPLEADO_DEPARTAMENTO (ID_DEPARTAMENTO, ID_EMPLEADO) VALUES 
(1, 1), -- Andrea en Sistemas
(3, 1), -- Andrea en Nanotecnología (Multi-departamento)
(3, 2), -- Benito en Nanotecnología
(2, 3); -- Carlos en Recursos Humanos

-- EMPLEADOS_ACTIVIDADES (Qué actividades realiza cada empleado)
INSERT INTO EMPLEADOS_ACTIVIDADES (ID_EMPLEADO, ID_ACTIVIDAD) VALUES 
(1, 1), -- Andrea: Da clases (Algoritmos)
(1, 2), -- Andrea: Participa en proyecto (Sensor Óptico)
(2, 2), -- Benito: Participa en proyecto (Sensor Óptico)
(3, 3); -- Carlos: Va a reunión (Junta)


SELECT * FROM TIPO_EMPLEADO
SELECT * FROM TIPO_ACTIVIDAD
SELECT * FROM Plaza
SELECT * FROM DEPARTAMENTO
SELECT * FROM ACTIVIDAD
SELECT * FROM EMPLEADO
SELECT * FROM TIPO_EMPLEADO_EMPLEADO 
SELECT * FROM EMPLEADO_DEPARTAMENTO
SELECT * FROM EMPLEADOS_ACTIVIDADES

SELECT
    E.NOMBRE_EMP + ' ' + E.APELLIDO_PAT AS Nombre_Completo,
    E.RFC,
    P.HORARIO AS Horario_Plaza,
    TE.NOM_TIPO AS Rol_Tipo_Empleado
FROM EMPLEADO E
JOIN Plaza P ON E.ID_PLAZA = P.ID_PLAZA
JOIN TIPO_EMPLEADO_EMPLEADO TEE ON E.ID_EMPLEADO = TEE.ID_EMPLEADO
JOIN TIPO_EMPLEADO TE ON TEE.ID_TIPO = TE.ID_TIPO
ORDER BY E.APELLIDO_PAT, TE.NOM_TIPO