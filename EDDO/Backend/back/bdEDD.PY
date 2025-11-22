def validarRequisito(conexion, idUsuario):
    try:
        cursor = conexion.cursor()

        cursor.execute("""
            SELECT COUNT(*)
            FROM docente_requisitos DR
            JOIN CONVOCATORIA C ON DR.ID_CONVOCATORIA = C.ID_CONVOCATORIA
            WHERE id_docente = ?
            AND C.FECHA_INICIO <= GETDATE() AND C.FECHA_FIN >= GETDATE()
        """, (idUsuario,))
        row1 = cursor.fetchone()
        count_user = int(row1[0]) if row1 is not None else 0

        cursor.execute("""
            SELECT COUNT(*)
            FROM REQUISITO_CONVO R
            JOIN CONVOCATORIA C ON R.ID_CONVOCATORIA = C.ID_CONVOCATORIA
            WHERE C.FECHA_INICIO <= GETDATE() AND C.FECHA_FIN >= GETDATE()
        """)
        row2 = cursor.fetchone()
        count_required = int(row2[0]) if row2 is not None else 0

        return count_user == count_required

    except Exception as e:
        print("❌ Error al validar requisitos:", e)
        return False
    finally:
        try:
            cursor.close()
        except Exception:
            pass