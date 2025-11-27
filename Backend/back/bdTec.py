import pyodbc

def traerEmpleados(conexion, correo, idDocente):
    try:
        cursor = conexion.cursor()
        cursor.execute("""SELECT 
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
    
def traerDocumentosTEC(conexion,idUsuario):
    try:
        cursor = conexion.cursor()
        cursor.execute("""SELECT  NOMBRE 
                       FROM DOCUMENTO D
                       INNER JOIN EMPLEADOSXDOCUMENTO ED ON D.ID_DOCUMENTO = ED.ID_DOCUMENTO
                       INNER JOIN EMPLEADO E ON ED.ID_EMPLEADO = E.ID_EMPLEADO
                       WHERE E.ID_EMPLEADO = ?""", (idUsuario,))
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

