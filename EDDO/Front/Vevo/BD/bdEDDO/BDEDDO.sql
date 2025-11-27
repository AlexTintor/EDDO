
create database EDDO
select * from DOCENTE
select * from EXPEDIENTE
select * from DOCUMENTO_EXPEDIENTE

CREATE TABLE DOCENTE (
    ID_DOCENTE INT NOT NULL,
    NOMBRE VARCHAR(100),
    APELLIDO_MAT VARCHAR(60),
    APELLIDO_PAT VARCHAR(60),
    CAMPUS VARCHAR(50),
	CONTRA VARCHAR(20),
	CORREO VARCHAR(50),
    TELEFONO VARCHAR(15),
    CONSTRAINT PK_DOCENTE PRIMARY KEY (ID_DOCENTE)
);

CREATE TABLE JEFE (
    JEFE_ID INT NOT NULL,
    NOMBRE VARCHAR(100),
    VIGENTE BIT CONSTRAINT DF_JEFE_VIGENTE DEFAULT (1),
	CONTRA VARCHAR(20),
	CORREO VARCHAR(50),
    CONSTRAINT PK_JEFE PRIMARY KEY (JEFE_ID),
    CONSTRAINT CHK_JEFE_VIGENTE CHECK (VIGENTE IN (0,1))
);

CREATE TABLE DEPARTAMENTO (
    ID_DEPARTAMENTO INT NOT NULL,
    JEFE_ID INT,
	NOMBRE VARCHAR(50),
    CONSTRAINT PK_DEPARTAMENTO PRIMARY KEY (ID_DEPARTAMENTO),
    CONSTRAINT FK_DEP_JEFE_ID FOREIGN KEY (JEFE_ID) REFERENCES JEFE(JEFE_ID)
);

CREATE TABLE CONVOCATORIA (
    ID_CONVOCATORIA INT NOT NULL,
    NOMBRE VARCHAR(100),
    FECHA_INICIO DATE,
    FECHA_FIN DATE,
    CONSTRAINT PK_CONVOCATORIA PRIMARY KEY (ID_CONVOCATORIA)
);

CREATE TABLE EXPEDIENTE (
    ID_EXPEDIENTE INT NOT NULL IDENTITY(1,1),
    ID_DOCENTE INT,
    ID_CONVOC INT,
    CONSTRAINT PK_EXPEDIENTE PRIMARY KEY (ID_EXPEDIENTE),
    CONSTRAINT FK_EXPEDIENTE_DOCENTE FOREIGN KEY (ID_DOCENTE) REFERENCES DOCENTE(ID_DOCENTE),
    CONSTRAINT FK_EXPEDIENTE_CONVOC FOREIGN KEY (ID_CONVOC) REFERENCES CONVOCATORIA(ID_CONVOCATORIA)
);

CREATE TABLE DOCUMENTO (
    FOLIO INT NOT NULL IDENTITY(1,1),
    ID_DEPARTAMENTO INT,
	NOMBRE VARCHAR(100),
    FECHA DATE,
    CONSTRAINT PK_DOCUMENTO PRIMARY KEY (FOLIO),
    CONSTRAINT FK_DOCUMENTO_DEP FOREIGN KEY (ID_DEPARTAMENTO) REFERENCES DEPARTAMENTO(ID_DEPARTAMENTO)
);

CREATE TABLE DOCUMENTO_EXPEDIENTE (
    ID_DOCUMENTO INT NOT NULL,
    ID_EXPEDIENTE INT NOT NULL,
    CONSTRAINT PK_DOCUMENTO_EXPEDIENTE PRIMARY KEY (ID_DOCUMENTO, ID_EXPEDIENTE),
    CONSTRAINT FK_DOC_EXP_DOCUMENTO FOREIGN KEY (ID_DOCUMENTO) REFERENCES DOCUMENTO(FOLIO),
    CONSTRAINT FK_DOC_EXP_EXPEDIENTE FOREIGN KEY (ID_EXPEDIENTE) REFERENCES EXPEDIENTE(ID_EXPEDIENTE)
);

CREATE TABLE RECLAMO (
    ID_RECLAMO INT NOT NULL IDENTITY(1,1),
    ID_DOCUMENTO INT,
    FECHA DATE,
    CONSTRAINT PK_RECLAMO PRIMARY KEY (ID_RECLAMO),
    CONSTRAINT FK_RECLAMO_DOCUMENTO FOREIGN KEY (ID_DOCUMENTO) REFERENCES DOCUMENTO(FOLIO)
);

CREATE TABLE COMENTARIOS (
    ID_COMENTARIO INT IDENTITY(1,1) NOT NULL,
	ID_RECLAMO INT NOT NULL,
    REMITENTE VARCHAR(10),
    FECHA DATETIME,
    DESCRIPCION VARCHAR(255),
    CONSTRAINT PK_COMENTARIOS PRIMARY KEY (ID_COMENTARIO),
    CONSTRAINT FK_COMENTARIOS_RECLAMO FOREIGN KEY (ID_RECLAMO) REFERENCES RECLAMO(ID_RECLAMO)
);
go

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
go
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


go
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



GO
CREATE OR ALTER PROCEDURE SP_LLENAR_DATOS_DOCUMENTO_DOCENTE
        @CORREO VARCHAR(50),
        @NOMBRE VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @ID_DOCUMENTO INT;
    DECLARE @ID_DOCENTE INT;
    DECLARE @ID_EXPEDIENTE INT;


    SELECT @ID_DOCENTE = ID_DOCENTE FROM
        DOCENTE WHERE CORREO = @CORREO

    select @ID_DOCUMENTO = FOLIO FROM
        DOCUMENTO WHERE NOMBRE = @NOMBRE

        IF EXISTS (SELECT 1 FROM EXPEDIENTE WHERE ID_DOCENTE = @ID_DOCENTE)
        BEGIN
                SELECT @ID_EXPEDIENTE = ID_EXPEDIENTE FROM
                EXPEDIENTE WHERE ID_DOCENTE = @ID_DOCENTE
        END
        ELSE
        BEGIN
                INSERT INTO EXPEDIENTE(ID_DOCENTE,ID_CONVOC)
                VALUES (@ID_DOCENTE, NULL);
                SELECT @ID_EXPEDIENTE = SCOPE_IDENTITY();
        END
    -- Validación de nulos
    IF  @ID_DOCENTE IS NULL OR @NOMBRE IS NULL
    BEGIN
        RAISERROR('No se permiten datos nulos', 16, 1);
        RETURN;
    END


        INSERT INTO DOCUMENTO_EXPEDIENTE(ID_DOCUMENTO,ID_EXPEDIENTE)
        VALUES (@ID_DOCUMENTO, @ID_EXPEDIENTE);
END
go
CREATE OR ALTER PROCEDURE SP_REGISTRAR_DOCENTE
        @ID_DOCENTE INT,
    @NOMBRE VARCHAR(100),
    @APELLIDO_PAT VARCHAR(60),
    @APELLIDO_MAT VARCHAR(60),
    @CAMPUS VARCHAR(50),
    @CORREO VARCHAR(50),
    @TELEFONO VARCHAR(15),
    @CONTRA VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    -- Validación de nulos
    IF  @ID_DOCENTE IS NULL OR @NOMBRE IS NULL OR @APELLIDO_PAT IS NULL OR @APELLIDO_MAT IS NULL
       OR @CAMPUS IS NULL OR @CORREO IS NULL OR @TELEFONO IS NULL OR @CONTRA IS NULL
    BEGIN
        RAISERROR('No se permiten datos nulos', 16, 1);
        RETURN;
    END

    -- Validación de correo repetido
    IF EXISTS (SELECT 1 FROM DOCENTE WHERE CORREO = @CORREO)
    BEGIN
        RAISERROR('El correo ya está registrado', 16, 1);
        RETURN;
    END

    -- Inserción correcta SIN ID_DOCENTE
    INSERT INTO DOCENTE (ID_DOCENTE,NOMBRE, APELLIDO_PAT, APELLIDO_MAT, CAMPUS, CONTRA, CORREO, TELEFONO)
    VALUES (@ID_DOCENTE,@NOMBRE, @APELLIDO_PAT, @APELLIDO_MAT, @CAMPUS, @CONTRA, @CORREO, @TELEFONO);
END
GO
CREATE or alter PROCEDURE sp_VerificarLoginDocente
    @Correo VARCHAR(100),
    @Contrasena VARCHAR(100),
    @IdDocente INT OUTPUT
AS
BEGIN
        SET NOCOUNT ON;

        SELECT @IdDocente = ID_DOCENTE
        FROM DOCENTE
        WHERE CORREO = @Correo
            AND CONTRA = @Contrasena;
        
        IF @IdDocente IS NULL
        BEGIN
                SELECT @IdDocente = JEFE_ID
                FROM JEFE
                WHERE CORREO = @Correo AND CONTRA = @Contrasena;
        END


        IF @IdDocente IS NULL
        BEGIN
                RAISERROR('Credenciales invalidas',16,1)
        END
END
GO

CREATE OR ALTER PROCEDURE sp_CambiarContrasenaDocente
        @Correo VARCHAR(100),
        @NuevaContrasena VARCHAR(100)
AS
BEGIN
        SET NOCOUNT ON;

        IF @NuevaContrasena IS NULL OR LTRIM(RTRIM(@NuevaContrasena)) = ''
        BEGIN
                RAISERROR('La nueva contraseña no puede ser nula o vacía.',16,1)
                RETURN
        END

        UPDATE DOCENTE
        SET CONTRA = @NuevaContrasena
        WHERE CORREO = @Correo

        IF @@ROWCOUNT = 0
        BEGIN
                RAISERROR('Correo no encontrado.',16,1)
        END
END
GO

CREATE OR ALTER PROCEDURE sp_ActualizarContrasenaDocente
        @IdDocente INT,
        @NuevaContrasena VARCHAR(100)
AS
BEGIN
        SET NOCOUNT ON;

        IF @IdDocente IS NULL
        BEGIN
                RAISERROR('El Id del docente no puede ser nulo.',16,1)
                RETURN
        END

        IF @NuevaContrasena IS NULL OR LTRIM(RTRIM(@NuevaContrasena)) = ''
        BEGIN
                RAISERROR('La nueva contraseña no puede ser nula o vacía.',16,1)
                RETURN
        END

        UPDATE DOCENTE
        SET CONTRA = @NuevaContrasena
        WHERE ID_DOCENTE = @IdDocente

        IF @@ROWCOUNT = 0
        BEGIN
                RAISERROR('IdDocente no encontrado.',16,1)
        END
END
GO