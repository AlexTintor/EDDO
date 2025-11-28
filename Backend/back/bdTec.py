import pyodbc

def traerEmpleados(conexion, correo, idDocente):
    try:
        cursor = conexion.cursor()
        cursor.execute("""SELECT 
                    e.ID_EMPLEADO,
                    e.NOMBRE,
                    e.APELLIDO_PAT,
                    e.APELLIDO_MAT,
                    e.CORREO,
                    e.TELEFONO,
                    e.CAMPUS,
                    d.NOMBRE AS NOMBRE_DEPA
                FROM EMPLEADO e
                JOIN DEPARTAMENTO d ON e.ID_DEPARTAMENTO = d.ID_DEPARTAMENTO
                WHERE E.CORREO = ? OR E.ID_EMPLEADO = ?  """, (correo, idDocente,))
        filas = cursor.fetchall()

        empleados = []
        for fila in filas:
            empleados.append({
                "ID_EMPLEADO": fila.ID_EMPLEADO,
                "NOMBRE": fila.NOMBRE,
                "APELLIDO_PAT": fila.APELLIDO_PAT,
                "APELLIDO_MAT": fila.APELLIDO_MAT,
                "CORREO": fila.CORREO,
                "TELEFONO": fila.TELEFONO,
                "CAMPUS": fila.CAMPUS,
                "DEPARTAMENTO": fila.NOMBRE_DEPA
            })
            print(empleados)
        return empleados

    except Exception as e:
        print("❌ Error al consultar empleados:", e)
        return None
    
def traerDocumentosTEC(conexion,correo):
    try:
        cursor = conexion.cursor()
        cursor.execute("""SELECT  D.NOMBRE, ED.DATOS_JSON
                       FROM DOCUMENTO D
                       INNER JOIN EMPLEADOSXDOCUMENTO ED ON D.ID_DOCUMENTO = ED.ID_DOCUMENTO
                       INNER JOIN EMPLEADO E ON ED.ID_EMPLEADO = E.ID_EMPLEADO
                       WHERE E.correo = ?""", (correo,))
        filas = cursor.fetchall()

        documentos = []
        for fila in filas:
            documentos.append({
                "NOMBRE": fila.NOMBRE
                ,"DATOS_JSON": fila.DATOS_JSON
            })
        return documentos

    except Exception as e:
        print("❌ Error al consultar documentos:", e)
        return None
    
def traerPlaza(conexion, idUsuario):
    try:
        cursor = conexion.cursor()
        cursor.execute("""SELECT P.NOMBRE_PLAZA
                       FROM PLAZA P
                       INNER JOIN EMPLEADO E ON P.ID_PLAZA = E.ID_PLAZA
                       WHERE E.ID_EMPLEADO = ?""", (idUsuario,))
        fila = cursor.fetchone()

        if fila:
            return fila.NOMBRE_PLAZA
        else:
            return None

    except Exception as e:
        print("❌ Error al consultar plaza:", e)
        return None
    
def validarDocenteTEC(conexion, correo):
    try:
        cursor = conexion.cursor()

        cursor.execute("""
            SELECT COUNT(*)
            FROM EMPLEADO
            WHERE CORREO = ?
        """, (correo,))
        row = cursor.fetchone()
        count_user = int(row[0]) if row is not None else 0
        return count_user > 0

    except Exception as e:
        print("❌ Error al validar docente TEC:", e)
        return False
    finally:
        try:
            cursor.close()
        except Exception:
            pass

def traerIdDocente(conexion):
    try:
        cursor = conexion.cursor()
        cursor.execute("""
            select id_empleado from Empleados
        """, )
        filas = cursor.fetchall()
        ids = [fila.ID_EMPLEADO for fila in filas]
        return ids

    except Exception as e:
        print("❌ Error al insertar documento TEC:", e)
        return False

