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
    
def traerExpediente(conexion, idUsuario):
    try:
        cursor = conexion.cursor()
        cursor.execute("""
            SELECT Nombre_documento, Aprobacion, id_reclamo
            FROM vw_Documento
            WHERE ID_DOCENTE = ?
        """, (idUsuario,))  # 👈 importante: coma final

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

def traerReclamos(conexion, idUsuario):
    try:
        cursor = conexion.cursor()
        cursor.execute("""
            SELECT id_reclamo,NOMBRE_DOCUMENTO, FOLIO_DOCUMENTO, FECHA_RECLAMO
            FROM vw_Documento
            WHERE ID_DOCENTE = ?
        """, (idUsuario,))  # 👈 importante: coma final

        filas = cursor.fetchall()

        if filas:
            reclamos = []
            for fila in filas:
                id_reclamo, nombre_doc, folio, fecha = fila  # Desempaqueta la tupla
                if id_reclamo or fecha or nombre_doc or folio:
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
    
def cambiarContra(conexion, correo, nuevaContra):
    try:
        cursor = conexion.cursor()
        cursor.execute("""
            EXEC sp_CambiarContrasenaDocente @Correo = ?, @NuevaContrasena = ?
        """, (correo, nuevaContra))
        conexion.commit()
        return True
    except Exception as e:
        print("❌ Error al cambiar la contraseña:", e)
        return False
    
def cambiarContraActual(conexion, idUsuario, contraNueva, contraActual):
    try:
        cursor = conexion.cursor()
        cursor.execute("SELECT CONTRA FROM DOCENTE WHERE ID_DOCENTE = ?", (idUsuario,))
        resultado = cursor.fetchone()

        if not resultado:
            return {"estatus": False, "error": "No se encontró el docente."}

        contraGuardada = resultado[0]

        if contraGuardada != contraActual:
            return {"estatus": False, "error": "La contraseña actual no coincide."}

        cursor.execute("""
            EXEC sp_ActualizarContrasenaDocente 
                @IdDocente = ?, 
                @NuevaContrasena = ?
        """, (idUsuario, contraNueva))
        conexion.commit()

        return {"estatus": True, "error": None}

    except Exception as e:
        print("❌ Error al cambiar la contraseña actual:", e)
        return {"estatus": False, "error": str(e)}

    finally:
        try:
            cursor.close()
        except:
            pass

def guardarMensaje(conexion, idUsuario, idReclamo,mensaje):
    try:
        cursor = conexion.cursor()
        if idUsuario:
            if int(idUsuario) >= 1000:
                remitente = "Jefe"
            else:
                remitente = "Docente"
        cursor.execute("""
            INSERT INTO COMENTARIOS (ID_RECLAMO, DESCRIPCION, FECHA, REMITENTE)
            VALUES (?, ?, GETDATE(),?)
        """, (idReclamo, mensaje, remitente))
        conexion.commit()
        return True
    except Exception as e:
        print("❌ Error al guardar el mensaje:", e)
        return False
    
def traerMsjs(conexion, idReclamo, idUsuario):
    try:
        cursor = conexion.cursor()
        cursor.execute("""
            SELECT 
                C.REMITENTE,
                C.FECHA AS FECHA_COMENTARIO,
                C.DESCRIPCION
            FROM COMENTARIOS C
            JOIN RECLAMO R ON C.ID_RECLAMO = R.ID_RECLAMO
            JOIN DOCUMENTO D ON R.ID_DOCUMENTO = D.FOLIO
            JOIN EXPEDIENTE E ON D.ID_EXPED = E.ID_EXPEDIENTE
            JOIN DOCENTE DOC ON E.ID_DOCENTE = DOC.ID_DOCENTE
            JOIN DEPARTAMENTO DEP ON D.ID_DEPARTAMENTO = DEP.ID_DEPARTAMENTO
            JOIN JEFE J ON DEP.JEFE_ID = J.JEFE_ID
            WHERE (DOC.ID_DOCENTE = ? AND R.ID_RECLAMO = ?) OR (J.JEFE_ID = ? and  R.ID_RECLAMO = ?)
        """, (idUsuario, idReclamo, idUsuario,idReclamo))
        
        filas = cursor.fetchall()
        return filas if filas else None

    except Exception as e:
        print("❌ Error al traer los mensajes:", e)
        return False

