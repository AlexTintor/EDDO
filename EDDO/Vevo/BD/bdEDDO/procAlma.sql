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