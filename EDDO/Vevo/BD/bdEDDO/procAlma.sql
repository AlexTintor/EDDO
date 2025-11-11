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