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
            SELECT Nombre_documento, Aprobacion, id_reclamo
            FROM vw_Documento
            WHERE ID_DOCENTE = ?
        """, (docenteID,))  # 👈 importante: coma final

        filas = cursor.fetchall()

        if filas:
            expediente = []
            for fila in filas:
                expediente.append({
                    "Nombre_documento": fila[0],
                    "Aprovacion": fila[1],
                    "id_reclamo": fila[2]
                })
            return expediente
        else:
            return None

    except Exception as e:
        print("❌ Error al consultar expediente:", e)
        return None

def traerReclamos(conexion, docenteID):
    try:
        cursor = conexion.cursor()
        cursor.execute("""
            SELECT id_reclamo,NOMBRE_DOCUMENTO, FOLIO_DOCUMENTO, FECHA_RECLAMO
            FROM vw_Documento
            WHERE ID_DOCENTE = ?
        """, (docenteID,))  # 👈 importante: coma final

        filas = cursor.fetchall()

        if filas:
            reclamos = []
            for fila in filas:
                id_reclamo, nombre_doc, folio, fecha = fila  # Desempaqueta la tupla
                if id_reclamo or fecha or nombre_doc or folio:
                    print(id_reclamo)  
                    reclamos.append({
                        "id_reclamo": id_reclamo,
                        "nombre_documento": nombre_doc,
                        "folio": folio,
                        "fecha": fecha
                    })
            return reclamos
        else:
            return []

    except Exception as e:
        print("❌ Error al consultar reclamos:", e)
        return None
    