/*DROP DATABASE EDD
GO*/
CREATE DATABASE EDD
GO 
USE EDD
GO

-- 1. CREACIÓN DE TABLAS PRINCIPALES
-- Tabla para los requisitos 
CREATE TABLE REQUISITOS_DE_INICIO (
    ID_REQUISITO INT IDENTITY(1,1) PRIMARY KEY,
    NOMBRE VARCHAR(255) NOT NULL,
    DESCRIPCION VARCHAR(1000)
)

-- Tabla para las convocatorias 
CREATE TABLE CONVOCATORIA (
    ID_CONVOCATORIA INT IDENTITY(1,1) PRIMARY KEY,
    NOMBRE VARCHAR(255) NOT NULL,
    FECHA_INICIO DATE,
    FECHA_FIN DATE
)

-- Tabla para los docentes 
CREATE TABLE DOCENTE (
    ID_DOCENTE INT IDENTITY(1,1) PRIMARY KEY,
    NOMBRES VARCHAR(150), 
    APELLIDO_PAT VARCHAR(100),
    APELLIDO_MAT VARCHAR(100),
    FECHA_VIGENCIA DATE,
    CUMPLE_LOS_REQUISITOS_INICO VARCHAR(15) --("CUMPLE", "NO CUMPLE")
)

-- 2. CREACIÓN DE TABLAS INTERMEDIAS (M-M)
-- Tabla intermedia CONVOCATORIA <-> REQUISITOS 
CREATE TABLE REQUISITOS_DE_INICIO_CONVOCATORIA (
    ID_REQUISITO INT NOT NULL,
    ID_CONVOCATORIA INT NOT NULL,
    
    -- Definición de la Clave Primaria Compuesta
    PRIMARY KEY (ID_REQUISITO, ID_CONVOCATORIA),
    
    -- Definición de las Claves Foráneas
    FOREIGN KEY (ID_REQUISITO) REFERENCES REQUISITOS_DE_INICIO(ID_REQUISITO),
    FOREIGN KEY (ID_CONVOCATORIA) REFERENCES CONVOCATORIA(ID_CONVOCATORIA)
)

-- Tabla intermedia CONVOCATORIA <-> DOCENTE 
CREATE TABLE CONVOCATORIA_DOCENTE (
    ID_CONVOCATORIA INT NOT NULL,
    ID_DOCENTE INT NOT NULL,
    
    -- Definición de la Clave Primaria Compuesta
    PRIMARY KEY (ID_CONVOCATORIA, ID_DOCENTE),
    
    -- Definición de las Claves Foráneas
    FOREIGN KEY (ID_CONVOCATORIA) REFERENCES CONVOCATORIA(ID_CONVOCATORIA),
    FOREIGN KEY (ID_DOCENTE) REFERENCES DOCENTE(ID_DOCENTE)
)

-- Tabla intermedia  DOCENTE <-> REQUISITOS
CREATE TABLE DOCENTE_REQUISITOS (
    ID_DOCENTE INT NOT NULL,
    ID_REQUISITO INT NOT NULL,
    DOCUMENTO_RUTA VARCHAR(1024),
    
    -- Definición de la Clave Primaria Compuesta
    PRIMARY KEY (ID_DOCENTE, ID_REQUISITO),
    
    -- Definición de las Claves Foráneas
    FOREIGN KEY (ID_DOCENTE) REFERENCES DOCENTE(ID_DOCENTE),
    FOREIGN KEY (ID_REQUISITO) REFERENCES REQUISITOS_DE_INICIO(ID_REQUISITO)
)


-- ===============================================
-- INSERCIÓN COMPLETA DE DATOS PARA EDD
-- (Asume que las tablas ya fueron creadas)
-- ===============================================

-- 1. ENTIDADES PRINCIPALES

-- REQUISITOS_DE_INICIO (ID 1 al 4)
INSERT INTO REQUISITOS_DE_INICIO (NOMBRE, DESCRIPCION) VALUES
('Título de Posgrado', 'Certificado o título de Maestría/Doctorado.'), -- 1
('Antigüedad Mínima', 'Experiencia docente comprobable mayor a 5 años.'), -- 2
('Cursos de Actualización', 'Constancia de al menos 3 cursos en el último año.'), -- 3
('Documento de Identificación', 'Copia digital de INE/Pasaporte vigente.'); -- 4

-- CONVOCATORIA (ID 1 al 2)
INSERT INTO CONVOCATORIA (NOMBRE, FECHA_INICIO, FECHA_FIN) VALUES
('Convocatoria Estímulo 2025', '2025-01-01', '2025-03-31'), -- 1
('Convocatoria Especial Investigación', '2025-05-15', '2025-07-30'); -- 2

-- DOCENTE (ID 1 al 5)
INSERT INTO DOCENTE (NOMBRES, APELLIDO_PAT, APELLIDO_MAT, FECHA_VIGENCIA, CUMPLE_LOS_REQUISITOS_INICO) VALUES
('Adriana', 'Ruiz', 'Guerra', '2026-12-31', 'CUMPLE'),     -- 1
('Benito', 'López', 'Ramos', '2025-06-30', 'CUMPLE'),      -- 2
('Carla', 'Méndez', 'Vargas', '2025-01-01', 'NO CUMPLE'),  -- 3
('David', 'Pérez', 'Soto', '2027-10-01', 'CUMPLE'),        -- 4
('Elena', 'Castro', 'Luna', '2026-03-15', 'CUMPLE');       -- 5


-- 2. TABLAS INTERMEDIAS (RELACIONES M:M)

-- REQUISITOS_DE_INICIO_CONVOCATORIA (Requisitos por convocatoria)
-- Conv. 1: R1, R2, R3, R4. | Conv. 2: R1, R3, R4.
INSERT INTO REQUISITOS_DE_INICIO_CONVOCATORIA (ID_REQUISITO, ID_CONVOCATORIA) VALUES
(1, 1), (2, 1), (3, 1), (4, 1),
(1, 2), (3, 2), (4, 2);

-- CONVOCATORIA_DOCENTE (Docentes inscritos en convocatorias)
INSERT INTO CONVOCATORIA_DOCENTE (ID_CONVOCATORIA, ID_DOCENTE) VALUES
(1, 1), (1, 2), (1, 3), (1, 5),
(2, 1), (2, 4);

-- DOCENTE_REQUISITOS (Cumplimiento de requisitos por docente)
-- D1 (Adriana): Cumple todos (R1, R2, R3, R4)
INSERT INTO DOCENTE_REQUISITOS (ID_DOCENTE, ID_REQUISITO, DOCUMENTO_RUTA) VALUES
(1, 1, '/doc/ad/titulo_pos.pdf'),
(1, 2, '/doc/ad/antiguedad.pdf'),
(1, 3, '/doc/ad/cursos_act.pdf'),
(1, 4, '/doc/ad/ine.pdf');

-- D3 (Carla): Solo cumple R2 y R4
INSERT INTO DOCENTE_REQUISITOS (ID_DOCENTE, ID_REQUISITO, DOCUMENTO_RUTA) VALUES
(3, 2, '/doc/ca/antiguedad.pdf'),
(3, 4, '/doc/ca/ine.pdf');

-- D4 (David): Solo cumple R1
INSERT INTO DOCENTE_REQUISITOS (ID_DOCENTE, ID_REQUISITO, DOCUMENTO_RUTA) VALUES
(4, 1, '/doc/da/titulo_pos.pdf');


SELECT * FROM REQUISITOS_DE_INICIO
SELECT * FROM CONVOCATORIA
SELECT * FROM DOCENTE
SELECT * FROM REQUISITOS_DE_INICIO_CONVOCATORIA
SELECT * FROM CONVOCATORIA_DOCENTE
SELECT * FROM DOCENTE_REQUISITOS

SELECT
    D.ID_DOCENTE,
    D.NOMBRES AS Nombre_Docente,
    D.APELLIDO_PAT AS Apellido_Paterno,
    D.APELLIDO_MAT AS Apellido_Materno,
    D.CUMPLE_LOS_REQUISITOS_INICO AS Cumple_Inicial,
    R.NOMBRE AS Nombre_Requisito,
    DR.DOCUMENTO_RUTA AS Ruta_Documento_Adjunto
FROM
    DOCENTE D
-- Une al docente con los requisitos que ha subido/cumplido
INNER JOIN DOCENTE_REQUISITOS DR
    ON D.ID_DOCENTE = DR.ID_DOCENTE
-- Une el requisito subido con el nombre y descripción del requisito
INNER JOIN REQUISITOS_DE_INICIO R
    ON DR.ID_REQUISITO = R.ID_REQUISITO
ORDER BY
    D.APELLIDO_PAT, R.NOMBRE;
--***********************************************************
SELECT
    D.ID_DOCENTE,
    D.NOMBRES + ' ' + D.APELLIDO_PAT + ' ' + D.APELLIDO_MAT AS "Nombre_Completo",
    D.CUMPLE_LOS_REQUISITOS_INICO AS "Cumple_Requisitos_De_Inicio",
    R.NOMBRE AS "Requisito_Docente"
FROM
    DOCENTE D
-- Une al docente con los requisitos que ha subido/cumplido
INNER JOIN DOCENTE_REQUISITOS DR
    ON D.ID_DOCENTE = DR.ID_DOCENTE
-- Une el requisito subido con el nombre del requisito
INNER JOIN REQUISITOS_DE_INICIO R
    ON DR.ID_REQUISITO = R.ID_REQUISITO
ORDER BY
    "Nombre_Completo", "Requisito_Docente";