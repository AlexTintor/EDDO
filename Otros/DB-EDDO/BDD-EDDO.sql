-- =============================================
-- SCRIPT FINAL COMPLETO Y FUNCIONAL PARA EDDO
-- (Creación de Tablas e Inserción de Datos - CORRECCIÓN DE CAMPOS DE FIRMA)
-- =============================================

-- Si la base de datos ya existe, puedes descomentar y usar las siguientes líneas para limpiar:
/*
USE master;
IF DB_ID('EDDO_DB_FINAL') IS NOT NULL DROP DATABASE EDDO_DB_FINAL;
GO
CREATE DATABASE EDDO_DB_FINAL;
GO
USE EDDO_DB_FINAL;
GO
*/

-- =============================================
-- 1. CREACIÓN DE TABLAS (ORDEN POR DEPENDENCIA)
-- =============================================

CREATE TABLE Tipo_Actividad (
    ID_TIPO_ACTIVIDAD INT PRIMARY KEY IDENTITY(1,1),
    NOMBRE NVARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Tipo_Documento (
    ID_TIPO_DOCUMENTO INT PRIMARY KEY IDENTITY(1,1),
    NOMBRE_DOCUMENTO NVARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE CONVOCATORIA (
    ID_CONVOCATORIA INT PRIMARY KEY IDENTITY(1,1),
    NOMBRE NVARCHAR(255) NOT NULL,
    FECHA_INICIO DATE NOT NULL,
    FECHA_FIN DATE NOT NULL
);

CREATE TABLE DOCENTE (
    ID_DOCENTE INT PRIMARY KEY IDENTITY(1,1),
    CUMPLE_REQUISITOS_INICO BIT NOT NULL,
    CAMPUS NVARCHAR(50),
    NOMBRES NVARCHAR(100) NOT NULL,
    APELLIDO_PATERNO NVARCHAR(100) NOT NULL,
    APELLIDO_MATERNO NVARCHAR(100),
    TELEFONO NVARCHAR(20),
    CORREO NVARCHAR(150) NOT NULL UNIQUE,
    CONTRASEÑA NVARCHAR(100) NOT NULL 
);

CREATE TABLE JEFE (
    ID_JEFE INT PRIMARY KEY IDENTITY(1,1),
    CAMPUS NVARCHAR(50),
    NOMBRES NVARCHAR(100) NOT NULL,
    APELLIDO_PATERNO NVARCHAR(100) NOT NULL,
    APELLIDO_MATERNO NVARCHAR(100),
    TELEFONO NVARCHAR(20),
    CORREO NVARCHAR(150) NOT NULL UNIQUE,
    CONTRASEÑA NVARCHAR(100) NOT NULL
);

CREATE TABLE DEPARTAMENTO (
    ID_DEPARTAMENTO INT PRIMARY KEY IDENTITY(1,1),
    NOMBRE_DEPARTAMENTO NVARCHAR(150) NOT NULL,
    ID_JEFE INT NOT NULL, 
    FOREIGN KEY (ID_JEFE) REFERENCES JEFE(ID_JEFE)
);

CREATE TABLE Actividad (
    ID_ACTIVIDAD INT PRIMARY KEY IDENTITY(1,1),
    NOMBRE NVARCHAR(255) NOT NULL,
    TIPO_ACTIVIDAD_FK INT NOT NULL,
    DESCRIPCION NVARCHAR(500),
    PUNTOS INT NOT NULL,
    FOREIGN KEY (TIPO_ACTIVIDAD_FK) REFERENCES Tipo_Actividad(ID_TIPO_ACTIVIDAD)
);

CREATE TABLE EXPEDIENTE (
    ID_EXPEDIENTE INT PRIMARY KEY IDENTITY(1,1),
    ID_DOCENTE INT NOT NULL,
    ID_CONVOCATORIA INT NOT NULL,
    FOREIGN KEY (ID_DOCENTE) REFERENCES DOCENTE(ID_DOCENTE),
    FOREIGN KEY (ID_CONVOCATORIA) REFERENCES CONVOCATORIA(ID_CONVOCATORIA)
);

CREATE TABLE DOCUMENTO (
    FOLIO NVARCHAR(50) PRIMARY KEY,
    ID_EXPEDIENTE INT NOT NULL,
    ID_TIPO_DOCUMENTO INT NOT NULL,
    ID_DEPARTAMENTO INT NOT NULL,
    ID_ACTIVIDAD INT NOT NULL,
    -- CORRECCIÓN: CAMPO PARA EL ESTADO DE FIRMA
    FIRMA_JEFE_DEPARTAMENTO VARCHAR(20), 
    FIRMA_DOCENTE VARCHAR(20),
    APROVACION BIT,
    FECHA DATE NOT NULL,
    FOREIGN KEY (ID_EXPEDIENTE) REFERENCES EXPEDIENTE(ID_EXPEDIENTE),
    FOREIGN KEY (ID_TIPO_DOCUMENTO) REFERENCES Tipo_Documento(ID_TIPO_DOCUMENTO),
    FOREIGN KEY (ID_DEPARTAMENTO) REFERENCES DEPARTAMENTO(ID_DEPARTAMENTO),
    FOREIGN KEY (ID_ACTIVIDAD) REFERENCES Actividad(ID_ACTIVIDAD)
);

CREATE TABLE RECLAMO (
    ID_RECLAMO INT PRIMARY KEY IDENTITY(1,1),
    ID_DOCENTE INT NOT NULL,
    ID_DOCUMENTO NVARCHAR(50) NOT NULL,
    FECHA_INICIO DATE NOT NULL,
    ESTATUS NVARCHAR(50) NOT NULL,
    FOREIGN KEY (ID_DOCENTE) REFERENCES DOCENTE(ID_DOCENTE),
    FOREIGN KEY (ID_DOCUMENTO) REFERENCES DOCUMENTO(FOLIO)
);

CREATE TABLE Comentarios (
    ID_COMENTARIO INT PRIMARY KEY IDENTITY(1,1),
    ID_RECLAMO INT NOT NULL,
    REMITENTE NVARCHAR(10) NOT NULL,
    DESCRIPCION NVARCHAR(500) NOT NULL,
    FOREIGN KEY (ID_RECLAMO) REFERENCES RECLAMO(ID_RECLAMO)
);

-- =============================================
-- 2. INSERCIÓN DE DATOS (CON ESTADOS DE FIRMA)
-- =============================================

-- Catálogos
INSERT INTO Tipo_Actividad (NOMBRE) VALUES
('Investigación'), ('Docencia'), ('Extensión'), ('Gestión Académica');

INSERT INTO Tipo_Documento (NOMBRE_DOCUMENTO) VALUES
('Constancia de Curso'), ('Artículo Publicado'), ('Informe de Proyecto'), ('Acta de Comité');

INSERT INTO CONVOCATORIA (NOMBRE, FECHA_INICIO, FECHA_FIN) VALUES
('Convocatoria Anual EDDO 2023', '2023-01-15', '2023-03-30'), 
('Convocatoria Anual EDDO 2024', '2024-05-01', '2024-08-31'),   
('Convocatoria Anual EDDO 2025', '2025-09-01', '2025-12-15'); 

-- Personal
INSERT INTO DOCENTE (CUMPLE_REQUISITOS_INICO, CAMPUS, NOMBRES, APELLIDO_PATERNO, APELLIDO_MATERNO, TELEFONO, CORREO, CONTRASEÑA) VALUES
(1, 'Culiacán', 'Alejandra', 'Guzmán', 'López', '6671112233', 'alejandra.guzman@eddo.mx', 'passDoc1'), 
(1, 'Culiacán', 'Roberto', 'Sánchez', 'Pérez', '6672223344', 'roberto.sanchez@eddo.mx', 'passDoc2'),  
(1, 'Culiacán', 'Fernanda', 'Díaz', 'Ramos', '6673334455', 'fernanda.diaz@eddo.mx', 'passDoc3'),  
(0, 'Culiacán', 'Miguel', 'Hernández', 'Vega', '6674445566', 'miguel.hernandez@eddo.mx', 'passDoc4'), 
(1, 'Culiacán', 'Laura', 'García', 'Flores', '6675556677', 'laura.garcia@eddo.mx', 'passDoc5'),   
(1, 'Culiacán', 'Javier', 'Reyes', 'Mendoza', '6676667788', 'javier.reyes@eddo.mx', 'passDoc6'),   
(0, 'Culiacán', 'Daniela', 'Castro', 'Ruiz', '6677778899', 'daniela.castro@eddo.mx', 'passDoc7'),   
(1, 'Culiacán', 'Carlos', 'Vargas', 'Soto', '6678889900', 'carlos.vargas@eddo.mx', 'passDoc8'),   
(1, 'Culiacán', 'Patricia', 'Luna', 'Montes', '6679990011', 'patricia.luna@eddo.mx', 'passDoc9'),   
(1, 'Culiacán', 'Sergio', 'Mora', 'Ibarra', '6670001122', 'sergio.mora@eddo.mx', 'passDoc10');

INSERT INTO JEFE (CAMPUS, NOMBRES, APELLIDO_PATERNO, APELLIDO_MATERNO, TELEFONO, CORREO, CONTRASEÑA) VALUES
('Culiacán', 'Ricardo', 'Alvarado', 'Cruz', '6670102030', 'ricardo.alvarado@jefe.mx', 'passJefe1'), 
('Culiacán', 'Sofía', 'Márquez', 'Silva', '6670203040', 'sofia.marquez@jefe.mx', 'passJefe2'),   
('Culiacán', 'Andrés', 'Quintero', 'Rubio', '6670304050', 'andres.quintero@jefe.mx', 'passJefe3'), 
('Culiacán', 'Gabriela', 'Torres', 'Leal', '6670405060', 'gabriela.torres@jefe.mx', 'passJefe4'),  
('Culiacán', 'Héctor', 'Chávez', 'Ponce', '6670506070', 'hector.chavez@jefe.mx', 'passJefe5');

-- Dependencias de 1er Nivel
INSERT INTO DEPARTAMENTO (NOMBRE_DEPARTAMENTO, ID_JEFE) VALUES
('Sistemas Computacionales', 1), ('Electrónica', 2), ('Gestión Tecnológica', 3);

INSERT INTO Actividad (NOMBRE, TIPO_ACTIVIDAD_FK, DESCRIPCION, PUNTOS) VALUES
('Publicación Q1 en IEEE', 1, 'Publicación de alto impacto en revista indexada.', 150), 
('Dirección de Tesis de Maestría', 2, 'Culminación exitosa de tesis de posgrado.', 100), 
('Curso de Verano Especializado', 2, 'Impartición de curso de especialidad para estudiantes.', 50), 
('Organización de Congreso Nacional', 3, 'Liderazgo en la organización de evento de extensión.', 80), 
('Redacción de Manual de Procedimientos', 4, 'Creación de documentación interna crítica.', 40),  
('Ponencia en Evento Internacional', 1, 'Presentación de resultados de investigación en el extranjero.', 120);

INSERT INTO EXPEDIENTE (ID_DOCENTE, ID_CONVOCATORIA) VALUES
(1, 1), (1, 3), (2, 1), (2, 2), (3, 1), (3, 3), (5, 1), (5, 2), (6, 1), (8, 2), (9, 1), (10, 3);

-- Documentos (Nuevos valores de firma: 'Firmado' / 'Pendiente')
INSERT INTO DOCUMENTO (FOLIO, ID_EXPEDIENTE, ID_TIPO_DOCUMENTO, ID_DEPARTAMENTO, ID_ACTIVIDAD, FIRMA_JEFE_DEPARTAMENTO, FIRMA_DOCENTE, APROVACION, FECHA) VALUES
('FOL-A-24-001', 1, 2, 1, 1, 'Firmado', 'Firmado', 1, '2024-03-01'), 
('FOL-A-24-002', 1, 3, 1, 5, 'Firmado', 'Firmado', 1, '2024-03-05'),
('FOL-A-24-003', 2, 4, 1, 6, 'Firmado', 'Firmado', 1, '2024-03-10'), 
('FOL-A-24-004', 2, 1, 1, 3, 'Pendiente', 'Firmado', 0, '2024-03-12'), -- Rechazo/Pendiente de Jefe
('FOL-R-24-005', 3, 2, 2, 1, 'Firmado', 'Firmado', 1, '2024-06-01'), 
('FOL-R-24-006', 3, 3, 2, 4, 'Firmado', 'Firmado', 1, '2024-06-05'),
('FOL-R-24-007', 4, 1, 2, 3, 'Firmado', 'Firmado', 1, '2024-06-10'), 
('FOL-R-24-008', 4, 4, 2, 5, 'Firmado', 'Pendiente', 0, '2024-06-12'), -- Rechazo/Pendiente de Docente
('FOL-F-24-009', 5, 2, 1, 1, 'Firmado', 'Firmado', 1, '2024-03-01'), 
('FOL-F-24-010', 6, 3, 1, 2, 'Firmado', 'Firmado', 1, '2024-03-05'),
('FOL-L-24-011', 7, 2, 3, 6, 'Firmado', 'Firmado', 1, '2024-03-01'), 
('FOL-L-24-012', 7, 1, 3, 3, 'Firmado', 'Firmado', 0, '2024-03-05'),
('FOL-L-24-013', 8, 4, 3, 5, 'Firmado', 'Firmado', 1, '2024-06-10'), 
('FOL-L-24-014', 8, 3, 3, 2, 'Firmado', 'Firmado', 1, '2024-06-12'),
('FOL-J-24-015', 9, 1, 1, 3, 'Firmado', 'Firmado', 1, '2024-03-01'), 
('FOL-J-24-016', 9, 4, 1, 5, 'Firmado', 'Firmado', 1, '2024-03-05'),
('FOL-C-24-017', 10, 2, 2, 6, 'Firmado', 'Firmado', 1, '2024-06-01'), 
('FOL-C-24-018', 10, 3, 2, 2, 'Firmado', 'Firmado', 1, '2024-06-05'),
('FOL-C-24-019', 10, 1, 2, 3, 'Firmado', 'Firmado', 1, '2024-06-10'), 
('FOL-C-24-020', 10, 4, 2, 4, 'Firmado', 'Firmado', 0, '2024-06-12'),
('FOL-P-24-021', 11, 2, 3, 1, 'Firmado', 'Firmado', 1, '2024-03-01'), 
('FOL-P-24-022', 11, 3, 3, 4, 'Firmado', 'Firmado', 1, '2024-03-05'),
('FOL-S-24-023', 12, 1, 1, 3, 'Firmado', 'Firmado', 1, '2024-09-01'), 
('FOL-S-24-024', 12, 4, 1, 5, 'Firmado', 'Firmado', 1, '2024-09-05');

-- Reclamos (Depende de Docente y Documento)
INSERT INTO RECLAMO (ID_DOCENTE, ID_DOCUMENTO, FECHA_INICIO, ESTATUS) VALUES
(1, 'FOL-A-24-004', '2024-03-15', 'Sin Resol'), (2, 'FOL-R-24-008', '2024-06-15', 'Resuelto'),
(5, 'FOL-L-24-012', '2024-03-18', 'Sin Resol'), (8, 'FOL-C-24-020', '2024-06-16', 'Resuelto'),
(3, 'FOL-F-24-009', '2024-03-08', 'Sin Resol'), (6, 'FOL-J-24-016', '2024-03-07', 'Resuelto'),
(10, 'FOL-S-24-024', '2024-09-10', 'Sin Resol');

-- Comentarios (Depende de Reclamo)
INSERT INTO Comentarios (ID_RECLAMO, REMITENTE, DESCRIPCION) VALUES
(1, 'DOCENTE', 'Solicito revisión, el curso sí cumplía las horas requeridas.'), (1, 'JEFE', 'Revisión asignada. Se verificará con coordinación.'), (1, 'DOCENTE', 'Adjunto evidencias adicionales de temario y duración.'),
(2, 'DOCENTE', 'El informe fue enviado a tiempo, la fecha de recibo es incorrecta.'), (2, 'JEFE', 'Revisado y corregido. El estatus cambia a Resuelto.'),
(3, 'DOCENTE', 'No entiendo el rechazo de este documento. La convocatoria lo permite.'),
(4, 'JEFE', 'La actividad asociada no cumple con el nivel 4, el estatus es final.'),
(5, 'DOCENTE', 'Pido mayor puntaje, el factor de impacto de la revista es el más alto.'),
(5, 'JEFE', 'El puntaje se revisa según la tabla de criterios, no el factor de impacto.'),
(5, 'DOCENTE', 'Comprendido. Gracias por la aclaración.');
