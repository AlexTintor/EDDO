CREATE database BDEDD;
-- ================================
-- TABLA: REQUISITOS_DE_INICIO
-- ================================
CREATE TABLE REQUISITOS_DE_INICIO (
    ID_REQUISITO INT NOT NULL,
    NOMBRE VARCHAR(100) NOT NULL,
    DESCRIPCION VARCHAR(300)
);

-- ================================
-- TABLA: CONVOCATORIA
-- ================================
CREATE TABLE CONVOCATORIA (
    ID_CONVOCATORIA INT NOT NULL,
    NOMBRE VARCHAR(100) NOT NULL,
    FECHA_INICIO DATE NOT NULL,
    FECHA_FIN DATE NOT NULL
);

-- ================================
-- TABLA: DOCENTE
-- ================================
CREATE TABLE DOCENTE (
    ID_DOCENTE INT NOT NULL IDENTITY,
    NOMBRE VARCHAR(100),
    APELLIDO_PAT VARCHAR(60),
    APELLIDO_MAT VARCHAR(60),
    CAMPUS VARCHAR(50),
	VIGENCIA INT CONSTRAINT DF_DOCENTE_VIGENTE DEFAULT (1),
	CONTRA VARCHAR(20),
	CORREO VARCHAR(50),
    TELEFONO VARCHAR(15),
    CONSTRAINT CHK_DOCENTE_VIGENTE CHECK (VIGENCIA IN (0,1))
);

-- ================================
-- TABLA: REQUISITO_CONVO
-- Relaciona requisitos ↔ convocatorias (N:M)
-- ================================
CREATE TABLE REQUISITO_CONVO (
    ID_REQUISITO INT NOT NULL,
    ID_CONVOCATORIA INT NOT NULL
);

-- ================================
-- TABLA: DOCENTE_REQUISITOS
-- Docente entrega requisito por convocatoria
-- ================================
CREATE TABLE DOCENTE_REQUISITOS (
    ID_DOCENTE INT NOT NULL,
    ID_REQUISITO INT NOT NULL,
    ID_CONVOCATORIA INT NOT NULL,
    DOCUMENTO_RUTA VARCHAR(300) NOT NULL
);
ALTER TABLE REQUISITOS_DE_INICIO
ADD CONSTRAINT PK_REQUISITOS_DE_INICIO
PRIMARY KEY (ID_REQUISITO);

ALTER TABLE CONVOCATORIA
ADD CONSTRAINT PK_CONVOCATORIA
PRIMARY KEY (ID_CONVOCATORIA);

ALTER TABLE DOCENTE
ADD CONSTRAINT PK_DOCENTE
PRIMARY KEY (ID_DOCENTE);

ALTER TABLE REQUISITO_CONVO
ADD CONSTRAINT PK_REQUISITO_CONVO
PRIMARY KEY (ID_REQUISITO, ID_CONVOCATORIA);

ALTER TABLE DOCENTE_REQUISITOS
ADD CONSTRAINT PK_DOCENTE_REQUISITOS
PRIMARY KEY (ID_DOCENTE, ID_REQUISITO, ID_CONVOCATORIA);

-- REQUISITO_CONVO → REQUISITOS_DE_INICIO
ALTER TABLE REQUISITO_CONVO
ADD CONSTRAINT FK_REQUISITOCONVO_REQUISITO
FOREIGN KEY (ID_REQUISITO)
REFERENCES REQUISITOS_DE_INICIO(ID_REQUISITO);

-- REQUISITO_CONVO → CONVOCATORIA
ALTER TABLE REQUISITO_CONVO
ADD CONSTRAINT FK_REQUISITOCONVO_CONVOCATORIA
FOREIGN KEY (ID_CONVOCATORIA)
REFERENCES CONVOCATORIA(ID_CONVOCATORIA);

-- DOCENTE_REQUISITOS → DOCENTE
ALTER TABLE DOCENTE_REQUISITOS
ADD CONSTRAINT FK_DOCR_DOCENTE
FOREIGN KEY (ID_DOCENTE)
REFERENCES DOCENTE(ID_DOCENTE);

-- DOCENTE_REQUISITOS → REQUISITOS_DE_INICIO
ALTER TABLE DOCENTE_REQUISITOS
ADD CONSTRAINT FK_DOCR_REQUISITO
FOREIGN KEY (ID_REQUISITO)
REFERENCES REQUISITOS_DE_INICIO(ID_REQUISITO);

-- DOCENTE_REQUISITOS → CONVOCATORIA
ALTER TABLE DOCENTE_REQUISITOS
ADD CONSTRAINT FK_DOCR_CONVOCATORIA
FOREIGN KEY (ID_CONVOCATORIA)
REFERENCES CONVOCATORIA(ID_CONVOCATORIA);


INSERT INTO REQUISITOS_DE_INICIO (ID_REQUISITO, NOMBRE, DESCRIPCION) VALUES
(1, 'Constancia de Recursos Humanos', 'Nombramiento de tiempo completo (estatus 10 o 95) y 90% de asistencia.'),
(2, 'Talón de pago', 'Talón de la quincena 07 del 2025 sin percepción DT o I8.'),
(3, 'Horarios de labores', 'Horarios del periodo 2024 y primer semestre 2025 con carga académica reglamentaria.'),
(4, 'Carta de exclusividad laboral', 'Carta de exclusividad laboral, formato oficial descargable.'),
(5, 'Proyecto de investigación', 'Proyecto vigente registrado ante DPII/DDIE o institución externa con dictamen.'),
(6, 'Constancia CVU-TecNM', 'Constancia de CVU-TecNM registrado y actualizado por Desarrollo Académico.'),
(7, 'Constancia de Servicios Escolares', 'Asignaturas impartidas, claves y número de estudiantes durante 2024.'),
(8, 'Oficio de sabático o licencia', 'Oficio de autorización de período sabático o licencia por beca comisión.'),
(9, 'Licencia por gravidez', 'Documento probatorio de licencia por gravidez, si aplica.'),
(10, 'Cédula profesional o acta de grado', 'Evidencia de cédula o acta de examen validada como copia fiel.'),
(11, 'Liberación de actividades docentes', 'Liberaciones de actividades de los dos semestres del periodo 2024.'),
(12, 'Carta de liberación académica', 'Anexo oficial donde conste cumplimiento al 100% de actividades académicas.'),
(13, 'Evaluaciones departamentales', 'Dos evaluaciones departamentales 2024 con calificación mínima de suficiente.'),
(14, 'Evaluaciones de desempeño', 'Dos evaluaciones del desempeño 2024 con calificación mínima de suficiente.');
go
    INSERT INTO CONVOCATORIA (ID_CONVOCATORIA, NOMBRE, FECHA_INICIO, FECHA_FIN)
    VALUES (1, 'Convocatoria 2025', '2025-01-01', '2025-12-31');
    go
INSERT INTO REQUISITO_CONVO (ID_REQUISITO, ID_CONVOCATORIA) VALUES
(1, 1),
(2, 1),
(3, 1),
(4, 1),
(5, 1),
(6, 1),
(7, 1),
(8, 1),
(9, 1),
(10, 1),
(11, 1),
(12, 1),
(13, 1),
(14, 1);

