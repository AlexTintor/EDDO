import pyodbc

def traerEmpleados(conexion, idDocente):
    try:
        cursor = conexion.cursor()
        cursor.execute("SELECT NOMBRE_EMPLEADO,CORREO_EMPLEADO,TELEFONO,CAMPUS, NOMBRE_DEPARTAMENTO  FROM VISTA_EMPLEADOS_COMPLETA where ID_EMPLEADO = ?", (idDocente,))
        filas = cursor.fetchall()

        empleados = []
        for fila in filas:
            empleados.append({
                "NOMBRE": fila.NOMBRE_EMPLEADO,
                "CORREO": fila.CORREO_EMPLEADO,
                "TELEFONO": fila.TELEFONO,
                "CAMPUS": fila.CAMPUS,
                "DEPARTAMENTO": fila.NOMBRE_DEPARTAMENTO
            })
        return empleados

    except Exception as e:
        print("❌ Error al consultar empleados:", e)
        return None