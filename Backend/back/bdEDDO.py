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
                DOC.NOMBRE AS NOMBRE_DOCUMENTO
            FROM DOCUMENTO DOC
            JOIN DOCUMENTO_EXPEDIENTE DE ON DOC.FOLIO = DE.ID_DOCUMENTO
            JOIN EXPEDIENTE E ON DE.ID_EXPEDIENTE = E.ID_EXPEDIENTE
            JOIN DOCENTE D ON E.ID_DOCENTE = D.ID_DOCENTE
            WHERE D.ID_DOCENTE = ?
        """, (idUsuario,)) 

        filas = cursor.fetchall()
        if filas:
            expediente = []
            for fila in filas:
                expediente.append({
                    "Nombre_documento": fila[0]
                })
            return expediente
        else:
            return None

    except Exception as e:
        print("❌ Error al consultar expediente:", e)
        return None
    
def todosDocumentos(conexion):
    try:
        cursor = conexion.cursor()
        cursor.execute("""SELECT NOMBRE 
                       FROM DOCUMENTO""")
        filas = cursor.fetchall()

        documentos = []
        for fila in filas:
            documentos.append({
                "NOMBRE": fila.NOMBRE
            })
        return documentos

    except Exception as e:
        print("❌ Error al consultar documentos:", e)
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
            JOIN DEPARTAMENTO DEP ON DOC.ID_DEPARTAMENTO = DEP.ID_DEPARTAMENTO
            JOIN JEFE J ON DEP.JEFE_ID = J.JEFE_ID
            JOIN RECLAMO R ON DOC.FOLIO = R.ID_DOCUMENTO
            where D.ID_DOCENTE = ? or J.JEFE_ID = ?
        """, (idUsuario, idUsuario)) 

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

def registrarDoc(conexion,idUsuario,nombre,apellido_pat,apellido_mat,campus, correo, telefono, contra):
    try:
        cursor = conexion.cursor()
        cursor.execute("""
            EXEC SP_REGISTRAR_DOCENTE 
                @ID_DOCENTE = ?,
                @NOMBRE = ?, 
                @APELLIDO_PAT = ?,
                @APELLIDO_MAT = ?,
                @CAMPUS = ?,
                @CORREO = ?,
                @TELEFONO = ?,
                @CONTRA = ?
        """, (idUsuario,nombre,apellido_pat, apellido_mat,campus, correo,telefono,contra))
        conexion.commit()

        return {"estatus": True}

    except Exception as e:
        print("❌ Error en registrarDoc:", e)

        mensaje = str(e)

        try:
            # Extraer el mensaje del RAISERROR
            mensaje_sql = e.args[1]
            mensaje_sql = mensaje_sql.split("[SQL Server]")[1].split("(")[0].strip()
        except:
            mensaje_sql = mensaje  # fallback

        return {"estatus": False, "error": mensaje_sql}
    finally:
        try:
            cursor.close()
        except:
            pass
def llenadoDoc(conexion,correo,nombre):
    try:
        cursor = conexion.cursor()
        cursor.execute("""
            exec SP_LLENAR_DATOS_DOCUMENTO_DOCENTE @CORREO = ?, @NOMBRE = ?
        """, (correo, nombre))
        conexion.commit()

        return {"estatus": True}

    except Exception as e:
        print("❌ Error al Llenar los datos:", e)
        return None
    
def guardarMensaje(conexion, idUsuario, idReclamo, mensaje, nombreDoc):
    try:
        cursor = conexion.cursor()

        # Determinar remitente
        if idUsuario and int(idUsuario) >= 1000:
            remitente = "JEFE"
        else:
            remitente = "DOCENTE"

        # =========================================
        # 1. SI EL ID_RECLAMO NO VIENE, SE BUSCA
        # =========================================
        if idReclamo is None:
            cursor.execute("""
                SELECT R.ID_RECLAMO
                FROM RECLAMO R
                JOIN DOCUMENTO DOC ON R.ID_DOCUMENTO = DOC.FOLIO
                WHERE DOC.NOMBRE = ?
            """, (nombreDoc,))
            
            resultado = cursor.fetchone()
            print("Resultado SELECT reclamo:", resultado)

            if resultado:  
                idReclamo = resultado[0]   # ✔ resultado.ID_RECLAMO NO EXISTE, se usa índice
            else:
                # Crear reclamo nuevo
                cursor.execute("""
                    INSERT INTO RECLAMO (ID_DOCUMENTO, FECHA)
                    VALUES ((SELECT FOLIO FROM DOCUMENTO WHERE NOMBRE = ?), GETDATE())
                """, (nombreDoc,))
                conexion.commit()

                # Volvemos a consultar el ID recién creado
                cursor.execute("""
                    SELECT R.ID_RECLAMO
                    FROM RECLAMO R
                    JOIN DOCUMENTO DOC ON R.ID_DOCUMENTO = DOC.FOLIO
                    WHERE DOC.NOMBRE = ?
                    ORDER BY R.ID_RECLAMO DESC
                """, (nombreDoc,))

                resultado = cursor.fetchone()
                idReclamo = resultado[0]

        # =========================================
        # 2. Insertar comentario
        # =========================================
        cursor.execute("""
            INSERT INTO COMENTARIOS (ID_RECLAMO, DESCRIPCION, FECHA, REMITENTE)
            VALUES (?, ?, GETDATE(), ?)
        """, (idReclamo, mensaje, remitente))

        conexion.commit()
        return True

    except Exception as e:
        print("❌ Error al guardar el mensaje:", e)
        return False

    
def traerMsjs(conexion, idReclamo, idUsuario,nombreDoc):
    try:
        cursor = conexion.cursor()
        query = """

                SELECT 
            CO.remitente,
            CO.fecha,
            CO.descripcion,
            DOC.NOMBRE 
        FROM DOCUMENTO DOC
        JOIN DOCUMENTO_EXPEDIENTE DE ON DOC.FOLIO = DE.ID_DOCUMENTO
        JOIN EXPEDIENTE E ON DE.ID_EXPEDIENTE = E.ID_EXPEDIENTE
        JOIN DOCENTE D ON E.ID_DOCENTE = D.ID_DOCENTE
        JOIN DEPARTAMENTO DEP ON DOC.ID_DEPARTAMENTO = DEP.ID_DEPARTAMENTO
        JOIN JEFE J ON DEP.JEFE_ID = J.JEFE_ID
        JOIN RECLAMO R ON DOC.FOLIO = R.ID_DOCUMENTO
        JOIN COMENTARIOS CO ON CO.ID_RECLAMO = R.ID_RECLAMO
        WHERE 
            (
                D.ID_DOCENTE = ?
                OR J.JEFE_ID = ?
            )
            AND 
            (
                R.ID_RECLAMO = ?
                OR DOC.NOMBRE = ?
            );


        """
        cursor.execute(query, (
            idUsuario,
            idUsuario,
            idReclamo,
            nombreDoc
        ))


        
        filas = cursor.fetchall()
        return filas if filas else None

    except Exception as e:
        print("❌ Error al traer los mensajes:", e)
        return False
    

def traerDocumentosEDDO(conexion,idUsuario):
    try:
        cursor = conexion.cursor()
        cursor.execute("""SELECT  D.NOMBRE 
                       FROM DOCUMENTO D
                       INNER JOIN DOCUMENTO_EXPEDIENTE DE ON D.FOLIO = DE.ID_DOCUMENTO
                       INNER JOIN EXPEDIENTE E ON DE.ID_EXPEDIENTE = E.ID_EXPEDIENTE
                       INNER JOIN DOCENTE DO ON E.ID_DOCENTE = DO.ID_DOCENTE
                       WHERE  DO.ID_DOCENTE = ?""", (idUsuario,))
        filas = cursor.fetchall()

        documentos = []
        for fila in filas:
            documentos.append({
                "NOMBRE": fila.NOMBRE
            })
        return documentos

    except Exception as e:
        print("❌ Error al consultar documentos:", e)
        return None
