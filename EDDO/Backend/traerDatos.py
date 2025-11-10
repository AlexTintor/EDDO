import pyodbc

def conectar_bd():
    try:
        conexion = pyodbc.connect(
            f'DRIVER={{ODBC Driver 17 for SQL Server}};'
            f'SERVER=localhost;'
            f'DATABASE=EDDO;'
            f'UID=irvin;'
            f'PWD=123;'
        )
        return conexion
    except Exception as e:
        print("❌ Error al conectar a la base de datos:", e)
        return None
    
def validarLogin(conexion,correo,contra):
    try:
        cursor = conexion.cursor()
        cursor.execute("""
            DECLARE @IdDocente INT;
            EXEC sp_VerificarLoginDocente @Correo = ?, @Contrasena = ?,  @IdDocente = @IdDocente OUTPUT;
            SELECT @IdDocente AS idDocente;
        """, (correo, contra))
        resultado = cursor.fetchone()
        usuario_id = resultado.idDocente if resultado and resultado.idDocente is not None else None

        return usuario_id
    except Exception as e:
        print("❌ Error al consultar nombre de usuario:", e)
        return None
    
def traerExpediente(conexion, docenteID):
    try:
        cursor = conexion.cursor()
        cursor.execute("""
            SELECT Nombre_documento, Aprovacion, id_reclamo
            FROM vw_Documento
            WHERE DocenteID = ?
        """, (docenteID,))
        fila = cursor.fetchone()
        if fila:
            expediente = {
                "Nombre_documento": fila[0],
                "Aprovacion": fila[1],
                "id_reclamo": fila[2]
            }
            return expediente
        else:
            return None
    except Exception as e:
        print("❌ Error al consultar expediente:", e)
        return None
    
def datosCuenta(conexion, docenteId):
    try:
        cursor = conexion.cursor()
        cursor.execute("""
            SELECT nombre_docente, correo, nombre_departamento, TELEFONO
            FROM vw_documento
            WHERE docenteID = ?
        """, (docenteId,))
        fila = cursor.fetchone()
        if fila:
            cuenta = {
                "nombre_docente": fila[0],
                "correo": fila[1],
                "nombre_departamento": fila[2],
                "telefono": fila[3]
            }
            return cuenta
        else:
            return None
    except Exception as e:
        print("❌ Error al consultar datos de la cuenta:", e)
        return None