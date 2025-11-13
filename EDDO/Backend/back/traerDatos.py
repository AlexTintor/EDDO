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
            SELECT 
                DOC.NOMBRE AS NOMBRE_DOCUMENTO,
                DOC.APROBACION
            FROM DOCUMENTO DOC
            JOIN DOCUMENTO_EXPEDIENTE DE ON DOC.FOLIO = DE.ID_DOCUMENTO
            JOIN EXPEDIENTE E ON DE.ID_EXPEDIENTE = E.ID_EXPEDIENTE
            JOIN DOCENTE D ON E.ID_DOCENTE = D.ID_DOCENTE
            JOIN CONVOCATORIA C ON E.ID_CONVOC = C.ID_CONVOCATORIA
            JOIN DEPARTAMENTO DEP ON DOC.ID_DEPARTAMENTO = DEP.ID_DEPARTAMENTO
            JOIN JEFE J ON DEP.JEFE_ID = J.JEFE_ID
            JOIN TIPO_DOCUMENTO TD ON DOC.ID_TIPO_DOCUMENTO = TD.ID_TIPO_DOCUMENTO
            WHERE D.ID_DOCENTE = ?
        """, (idUsuario,)) 

        filas = cursor.fetchall()
        if filas:
            expediente = []
            for fila in filas:
                expediente.append({
                    "Nombre_documento": fila[0],
                    "APROBACION": fila[1]
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
            SELECT 
                R.id_reclamo,
                DOC.NOMBRE AS nombre_documento,
                DOC.folio,
                R.fecha
            FROM DOCUMENTO DOC
            JOIN DOCUMENTO_EXPEDIENTE DE ON DOC.FOLIO = DE.ID_DOCUMENTO
            JOIN EXPEDIENTE E ON DE.ID_EXPEDIENTE = E.ID_EXPEDIENTE
            JOIN DOCENTE D ON E.ID_DOCENTE = D.ID_DOCENTE
            JOIN CONVOCATORIA C ON E.ID_CONVOC = C.ID_CONVOCATORIA
            JOIN DEPARTAMENTO DEP ON DOC.ID_DEPARTAMENTO = DEP.ID_DEPARTAMENTO
            JOIN JEFE J ON DEP.JEFE_ID = J.JEFE_ID
            JOIN TIPO_DOCUMENTO TD ON DOC.ID_TIPO_DOCUMENTO = TD.ID_TIPO_DOCUMENTO
            JOIN RECLAMO R ON DOC.FOLIO = R.ID_DOCUMENTO
            where D.ID_DOCENTE = ?
        """, (idUsuario,)) 

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
    
def traerMsjs(conexion, nombreDoc, idUsuario):
    try:
        cursor = conexion.cursor()
        cursor.execute("""
            SELECT 
                CO.remitente,
                CO.fecha,
                CO.descripcion
            FROM DOCUMENTO DOC
            JOIN DOCUMENTO_EXPEDIENTE DE ON DOC.FOLIO = DE.ID_DOCUMENTO
            JOIN EXPEDIENTE E ON DE.ID_EXPEDIENTE = E.ID_EXPEDIENTE
            JOIN DOCENTE D ON E.ID_DOCENTE = D.ID_DOCENTE
            JOIN CONVOCATORIA C ON E.ID_CONVOC = C.ID_CONVOCATORIA
            JOIN DEPARTAMENTO DEP ON DOC.ID_DEPARTAMENTO = DEP.ID_DEPARTAMENTO
            JOIN JEFE J ON DEP.JEFE_ID = J.JEFE_ID
            JOIN TIPO_DOCUMENTO TD ON DOC.ID_TIPO_DOCUMENTO = TD.ID_TIPO_DOCUMENTO
            JOIN RECLAMO R ON DOC.FOLIO = R.ID_DOCUMENTO
            JOIN COMENTARIOS CO ON CO.ID_RECLAMO = R.ID_RECLAMO
            WHERE (D.ID_DOCENTE = ? AND DOC.NOMBRE LIKE ?) 
            OR (J.JEFE_ID   = ? AND DOC.NOMBRE LIKE ?)
        """, (idUsuario, f"%{nombreDoc}%", idUsuario, f"%{nombreDoc}%"))

        
        filas = cursor.fetchall()
        return filas if filas else None

    except Exception as e:
        print("❌ Error al traer los mensajes:", e)
        return False

