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
CREATE OR ALTER PROCEDURE SP_REGISTRAR_DOCENTE
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
    IF @NOMBRE IS NULL OR @APELLIDO_PAT IS NULL OR @APELLIDO_MAT IS NULL
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
    INSERT INTO DOCENTE (NOMBRE, APELLIDO_PAT, APELLIDO_MAT, CAMPUS, CONTRA, CORREO, TELEFONO)
    VALUES (@NOMBRE, @APELLIDO_PAT, @APELLIDO_MAT, @CAMPUS, @CONTRA, @CORREO, @TELEFONO);
END