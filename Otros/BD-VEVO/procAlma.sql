CREATE PROCEDURE sp_VerificarLoginDocente
    @Correo VARCHAR(100),
    @Contrasena VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @IdDocente INT;

    -- Verificamos si el correo y contraseña existen
    SELECT @IdDocente = ID_DOCENTE
    FROM DOCENTE
    WHERE CORREO = @Correo
      AND CONTRA = @Contrasena;

    -- Si encontró coincidencia, regresa el ID
    IF @IdDocente IS NOT NULL
        SELECT @IdDocente AS ID_DOCENTE;
    ELSE
		RAISERROR('Credenciales invalidas',16,1)
END
GO


CREATE PROCEDURE sp_VerificarLoginDocente
    @Correo VARCHAR(100),
    @Contrasena VARCHAR(100),
    @IdDocente INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT @IdDocente = ID_DOCENTE
    FROM DOCENTE
    WHERE CORREO = @Correo
      AND CONTRASENA = @Contrasena;

	IF @IdDocente IS NULL
	BEGIN
		RAISERROR('Credenciales invalidas',16,1)
	END

END
GO