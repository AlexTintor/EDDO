import os
import threading
import time
from flask import Flask, after_this_request, request, jsonify, send_file
import smtplib, random
from email.message import EmailMessage
from flask_cors import CORS
from bdEDDO import validarLogin, traerExpediente, traerReclamos, cambiarContra,cambiarContraActual,guardarMensaje,traerMsjs,registrarDoc, todosDocumentos,llenadoDoc
from bdTec import  traerEmpleados, traerPlaza,validarDocenteTEC,traerDocumentosTEC
from bdEDD import validarRequisito # type: ignore
from convertirPdf import generar_constancia
import pyodbc
app = Flask(__name__)
CORS(app)

def conectar_bd(bd):
    try:
        conexion = pyodbc.connect(
            f'DRIVER={{ODBC Driver 17 for SQL Server}};'
            f'SERVER=localhost;'
            f'DATABASE={bd};'
            f'UID=irvin;'
            f'PWD=123;'
        )
        return conexion
    except Exception as e:
        print("❌ Error al conectar a la base de datos:", e)
        return None
    
@app.route("/enviar-codigo", methods=["POST"])
def enviar_codigo():
    data = request.get_json()
    correo_destino = data.get("correo")

    if not correo_destino:
        return jsonify({"ok": False, "error": "No se proporcionó correo"}), 400

    codigo = random.randint(100000, 999999)
    remitente = "vevovevo963@gmail.com"
    contraseña = "rryeyeztaugrbppy"

    msg = EmailMessage()
    msg["Subject"] = "Código de verificación"
    msg["From"] = remitente
    msg["To"] = correo_destino
    msg.set_content(f"Tu código de verificación es: {codigo}")

    try:
        with smtplib.SMTP_SSL("smtp.gmail.com", 465) as smtp:
            smtp.login(remitente, contraseña)
            smtp.send_message(msg)
        return jsonify({"estatus": True, "mensaje": "Correo enviado correctamente", "codigo": codigo})
    except Exception as e:
        return jsonify({"estatus": False, "error": str(e)}), 500



@app.route("/login", methods=["POST"])
def login():
    data = request.get_json()
    correo = data.get("correo")
    contra = data.get("contra")
    
    if not correo or not contra:
        return jsonify({"estatus": False, "error": "Faltan datos"}), 400

    conexion = conectar_bd("EDDO")
    if not conexion:
        return jsonify({"estatus": False, "error": "No se pudo conectar a la base de datos"}), 500

    docente_id = validarLogin(conexion, correo, contra)
    conexion.close()

    if docente_id:
        return jsonify({"estatus": True, "id_docente": docente_id})
    else:
        return jsonify({"estatus": False, "error": "Credenciales inválidas"}), 401
    

@app.route("/expedient", methods=["POST"])
def expediente():
    data = request.get_json()
    idUsuario = data.get("idUsuario")

    if not idUsuario:
        return jsonify({"estatus": False, "error": "Faltan datos"}), 400

    conexion = conectar_bd("EDDO")
    if not conexion:
        return jsonify({"estatus": False, "error": "No se pudo conectar a la base de datos"}), 500

    expediente = traerExpediente(conexion, idUsuario)
    conexion.close()

    if expediente:
        return jsonify({"estatus": True, "expediente": expediente})
    else:
        return jsonify({"estatus": False, "error": "No se encontró expediente"}), 404
    
@app.route("/todosDocumentos", methods=["POST"])
def todosDocu():
    conexion = conectar_bd("EDDO")
    if not conexion:
        return jsonify({"estatus": False, "error": "No se pudo conectar a la base de datos"}), 500

    documentos = todosDocumentos(conexion)
    conexion.close()

    if documentos:
        return jsonify({"estatus": True, "Documentos": documentos})
    else:
        return jsonify({"estatus": False, "error": "No se encontró expediente"}), 404

@app.route("/reclamos", methods=["POST"])
def reclamos():
    data = request.get_json()
    idUsuario = data.get("idUsuario")

    if not idUsuario:
        return jsonify({"estatus": False, "error": "Faltan datos"}), 400
    
    conexion = conectar_bd("EDDO")
    if not conexion:
        return jsonify({"estatus": False, "error": "No se pudo conectar a la base de datos"}), 500
    
    reclamos = traerReclamos(conexion, idUsuario)
    conexion.close()
    
    if reclamos:
        return jsonify({"estatus": True, "reclamos": reclamos})
    else:
        return jsonify({"estatus": False, "error": "No se encontraron reclamos"}), 404
    
@app.route("/registrarDocente", methods =["POST"])
def registrarDocente():
    data = request.get_json()
    correo = data.get("CORREO")
    contra = data.get("CONTRA")

    if not  correo  or not contra:
        return jsonify({"estatus": False, "error": "Faltan datos"}), 400
    
    conexion2 = conectar_bd("BDTEC")

    if not conexion2:
        return jsonify({"estatus": False, "error": "No se pudo conectar a la base de datos TEC"}), 500
    
    if not validarDocenteTEC(conexion2, correo):
        return jsonify({"estatus": False, "error": "El correo no pertenece a un docente del TEC"}), 400
    
    datos = traerEmpleados(conexion2, correo, idDocente = 0)

    if not datos:
        return jsonify({"estatus": False, "error": "No se encontraron datos del docente en TEC"}), 404
    
    if isinstance(datos, list) and len(datos) > 0:
        datos = datos[0]
    id_empleado = datos["ID_EMPLEADO"]
    nombre = datos["NOMBRE"] 
    telefono = datos["TELEFONO"]
    apellido_pat = datos["APELLIDO_PAT"]
    apellido_mat = datos["APELLIDO_MAT"]
    campus = datos["CAMPUS"]

    conexion2.close()
    
    conexion = conectar_bd("EDDO")
    if not conexion:
        return jsonify({"estatus": False, "error": "No se pudo conectar a la base de datos1"}), 500
    
    respuesta = registrarDoc(conexion,id_empleado,nombre,apellido_pat,apellido_mat, campus,correo,telefono,contra)
    conexion.close()

    llenadoDocumentos(correo)

    if respuesta["estatus"]:
        return jsonify({"estatus": True, "cuenta": respuesta})
    else:
        return jsonify({"estatus": False, "error": respuesta["error"]}), 404 
    
def llenadoDocumentos(correo):
    try:
        conexion1 = conectar_bd("BDTEC")
        if not conexion1:
            print("No se pudo conectar a la base de datos TEC")
            return
        
        datos = traerDocumentosTEC(conexion1,correo)
        conexion1.close()

        conexion = conectar_bd("EDDO")
        if not conexion:
            print("No se pudo conectar a la base de datos")
            return
        
        for doc in datos:
            llenadoDoc(conexion,correo,doc["NOMBRE"])
        conexion.close()
        
        return {"estatus": True}
    
    except Exception as e:
        print("❌ Error al llenar documentos:", e)
        return {"estatus": False, "error": str(e)}
    

@app.route("/cuenta", methods=["POST"])
def cuenta():
    data = request.get_json()
    idUsuario = data.get("idUsuario")

    if not idUsuario:
        return jsonify({"estatus": False, "error": "Faltan datos"}), 400

    conexion = conectar_bd("BDTEC")
    if not conexion:
        return jsonify({"estatus": False, "error": "No se pudo conectar a la base de datos"}), 500
    correo = ""
    cuenta = traerEmpleados(conexion, correo, idUsuario)
    conexion.close()

    if cuenta:
        return jsonify({"estatus": True, "cuenta": cuenta})
    else:
        return jsonify({"estatus": False, "error": "No se encontraron datos de la cuenta"}), 404 
    
@app.route("/verificarCorreo", methods=["GET"])
def verificarCorreo():
    correo = request.args.get("correo")

    if not correo:
        return jsonify({"estatus": False, "error": "Faltan datos"}), 400

    conexion = conectar_bd("EDDO")
    if not conexion:
        return jsonify({"estatus": False, "error": "No se pudo conectar a la base de datos"}), 500
    
    cursor = conexion.cursor()
    cursor.execute("SELECT COUNT(*) FROM Docente WHERE correo = ?", (correo,))
    resultado = cursor.fetchone()
    conexion.close()

    if resultado and resultado[0] > 0:
        return jsonify({"estatus": True})
    else:
        return jsonify({"estatus": False})

    
@app.route("/cambiar-contrasena", methods=["POST"])
def cambiarContrasena():
    data = request.get_json()
    docente_id = data.get("correo")
    contraNueva = data.get("contraNueva")

    if not docente_id or not contraNueva:
        return jsonify({"estatus": False, "error": "Faltan datos"}), 400

    conexion = conectar_bd("EDDO")
    if not conexion:
        return jsonify({"estatus": False, "error": "No se pudo conectar a la base de datos"}), 500

    cuenta = cambiarContra(conexion, docente_id, contraNueva)
    conexion.close()

    if cuenta:
        return jsonify(True)
    else:
        return jsonify(False), 404 
    
@app.route("/cambiarContraActual", methods=["POST"])
def cambiarContraseñaActual():
    data = request.get_json()
    idUsuario = data.get("idUsuario")
    contraActual = data.get("contraActual")
    contraNueva = data.get("contraNueva")

    if not contraNueva or not contraActual:
        return jsonify({"estatus": False, "error": "Faltan datos"}), 400

    conexion = conectar_bd("EDDO")
    if not conexion:
        return jsonify({"estatus": False, "error": "No se pudo conectar a la base de datos"}), 500

    respuesta = cambiarContraActual(conexion, idUsuario, contraActual,contraNueva)
    conexion.close()

    if respuesta["estatus"]:
        return jsonify({"estatus": True})
    else:
        return jsonify({"estatus": False, "error": respuesta["error"]}), 401
    
@app.route("/guardar-mensaje", methods=["POST"])
def guardarMsj():
    data = request.get_json()
    idUsuario = data.get("idUsuario")
    idReclamo= data.get("idReclamo")
    mensaje = data.get("mensaje")
    nombreDoc = data.get("nombreDoc")

    if not idUsuario or not mensaje:
        return jsonify({"estatus": False, "error": "Faltan datos"}), 400

    conexion = conectar_bd("EDDO")
    if not conexion:
        return jsonify({"estatus": False, "error": "No se pudo conectar a la base de datos"}), 500

    respusta = guardarMensaje(conexion, idUsuario, idReclamo , mensaje, nombreDoc);
    conexion.close()
    if respusta:
        return jsonify({"estatus": True})
    else:
        return jsonify({"estatus": False, "error": "No se pudo guardar el mensaje"}), 500
    
from flask import jsonify, request

@app.route("/traer-mensajes", methods=["POST"])
def traerMensajes():
    data = request.get_json()
    idUsuario = data.get("idUsuario")
    idReclamo = data.get("nombreDoc")
    nombreDoc = data.get("documentoSeleccionado")


    try:
        conexion = conectar_bd("EDDO")
        if not conexion:
            return jsonify({"error": "No se pudo conectar a la base de datos"}), 500

        filas = traerMsjs(conexion, idReclamo, idUsuario,nombreDoc)

        if filas:
            mensajes = []
            for fila in filas:
                remitente, fecha, descripcion,NOMBRE = fila
                mensajes.append({
                    "remitente": remitente,
                    "fecha": fecha.strftime("%Y-%m-%d %H:%M:%S"),
                    "descripcion": descripcion,
                    "nombreDoc": NOMBRE 
                })
            return jsonify({"estatus":True,"msjs":mensajes})
        else:
            return jsonify([])

    except Exception as e:
        print("❌ Error al consultar mensajes:", e)
        return jsonify({"error": str(e)}), 500

@app.route("/validarRequisito", methods=["POST"])
def validarRequisitos():
    data = request.get_json()
    idUsuario = data.get("idUsuario")

    if not idUsuario:
        return jsonify({"estatus": False, "error": "Faltan datos"}), 400

    conexion = conectar_bd("BDEDD")
    if not conexion:
        return jsonify({"estatus": False, "error": "No se pudo conectar a la base de datos"}), 500

    cumple_requisitos = validarRequisito(conexion, idUsuario)

    conexion2 = conectar_bd("BDTEC")
    if not conexion2:
        return jsonify({"estatus": False, "error": "No se pudo conectar a la base de datos"}), 500
    
    cumple_requisito_plaza = traerPlaza(conexion2, idUsuario)

    if cumple_requisito_plaza != "Tiempo Completo":
        cumple_requisitos = False

    conexion2.close()
    conexion.close()

    return jsonify({"estatus": True, "cumpleRequisito": cumple_requisitos})

@app.route('/traerDepartamentos', methods=['GET'])
def traerDepartamentos():
    try:
        conexion = conectar_bd("EDDO")
        if not conexion:
            return jsonify({"estatus": False, "error": "No se pudo conectar a la base de datos"}), 500
        
        cursor = conexion.cursor()
        cursor.execute("""
            SELECT NOMBRE FROM DEPARTAMENTO
        """ )
        filas = cursor.fetchall()
        conexion.close()

        departamentos = []
        for fila in filas:
            (NOMBRE,) = fila
            departamentos.append({
                "NOMBRE": NOMBRE
            })
        return jsonify({"estatus": True, "departamentos": departamentos})
    
    except Exception as e:
        print("❌ Error al traer departamentos:", e)
        return []


@app.route('/generar-constancia', methods=['POST'])
def generar():
    data = request.get_json()
    nombreDoc = data.get("nombreDoc")
    idUsuario = data.get("idUsuario")

    conexion = conectar_bd("BDTEC")
    if not conexion:
        return jsonify({"estatus": False, "error": "No se pudo conectar a la base de datos"}), 500

    cursor = conexion.cursor()
    cursor.execute("""select ed.DATOS_JSON
                    from EMPLEADO e
                    inner join EMPLEADOSXDOCUMENTO ed on e.ID_EMPLEADO = ed.ID_EMPLEADO
                    inner join DOCUMENTO d on d.ID_DOCUMENTO = ed.ID_DOCUMENTO
                    where d.NOMBRE = ? and e.ID_EMPLEADO = ?""", (nombreDoc, idUsuario))
    print(nombreDoc)
    row = cursor.fetchone()
    print("Fila obtenida de la base de datos:", row)
    conexion.close()
    if row:
        datos_json = row[0]
        print("Datos JSON obtenidos:", datos_json)
        try:
            import json
            datos = json.loads(datos_json)
            datos,datos2 = llenarCampoFirma(datos)
            print("Datos después de llenar firmas:", datos)
        except Exception as e:
            print("❌ Error al convertir datos JSON:", e)
            return jsonify({"estatus": False, "error": "Error al procesar los datos"}), 500
    else:
        return jsonify({"estatus": False, "error": "No se encontraron datos para el documento"}), 404
    # Aquí llamas tu función que genera el PDF
    path_pdf = generar_constancia(datos,nombreDoc,datos2)

    # Enviar PDF al frontend
    return send_file(path_pdf, mimetype="application/pdf")

def llenarCampoFirma(datos):
    conexion = conectar_bd("EDDO")
    if not conexion:
        print("No se pudo conectar a la base de datos")
        return

    cursor = conexion.cursor()
    cursor.execute("SELECT JEFE_ID, NOMBRE FROM DEPARTAMENTO")
    filas = cursor.fetchall()

    datos2 = []  # <- evita error

    for jefeId, nombreDep in filas:

        # Convertir "Juan Perez" -> "JUAN_PEREZ"
        variableEsperada = "VAR_JEFE_" + nombreDep.replace(" ", "_").upper()

        # Verificar si esa variable existe en los datos JSON
        if variableEsperada in datos:
            cursor.execute("SELECT NOMBRE FROM JEFE WHERE JEFE_ID = ?", (jefeId,))
            fila = cursor.fetchone()

            if fila:
                nombreJefe = fila[0]
                datos[variableEsperada] = nombreJefe
                datos2.append({variableEsperada: nombreJefe})

                print("Asignado valor:", nombreJefe, "a la variable:", variableEsperada)

    conexion.close()

    print("Datos finales con firmas:", datos)
    print("Nombre del jefe asignado:", datos2)

    return datos, datos2








@app.route('/traerIdDoce', methods=['GET'])
def traerIdDoce():

    conexion = conectar_bd("BDTEC")
    if not conexion:
        return jsonify({"estatus": False, "error": "No se pudo conectar a la base de datos"}), 500

    cursor = conexion.cursor()
    cursor.execute("SELECT ID_EMPLEADO, NOMBRE,APELLIDO_PAT,APELLIDO_MAT FROM empleado")
    filas = cursor.fetchall()   # ← CAMBIO IMPORTANTE
    conexion.close()
    
    if not filas:
        return jsonify({"estatus": False, "error": "No se encontraron docentes"}), 404

    docentes = []
    for fila in filas:
        ID_EMPLEADO, NOMBRE,APELLIDO_PAT,APELLIDO_MAT = fila
        NOMBRE = f"{NOMBRE} {APELLIDO_PAT} {APELLIDO_MAT}"
        docentes.append({
            "ID_EMPLEADO": ID_EMPLEADO,
            "NOMBRE": NOMBRE
        })

    return jsonify({"estatus": True, "docentes": docentes})

@app.route('/traerDocumentos', methods=['POST'])
def traerDocumentos():
    data = request.get_json()
    idDocente = data.get("idDocente")
    conexion = conectar_bd("BDTEC")
    if not conexion:
        return jsonify({"estatus": False, "error": "No se pudo conectar a la base de datos"}), 500

    cursor = conexion.cursor()
    cursor.execute("""SELECT D.ID_DOCUMENTO ,D.NOMBRE FROM DOCUMENTO D
                   inner join EMPLEADOSXDOCUMENTO ED ON ED.ID_DOCUMENTO = D.ID_DOCUMENTO
                   inner join EMPLEADO E ON ED.ID_EMPLEADO = E.ID_EMPLEADO
                   WHERE E.ID_EMPLEADO = ?""", (idDocente,))
    filas = cursor.fetchall()   # ← CAMBIO IMPORTANTE
    conexion.close()

    
    if not filas:
        return jsonify({"estatus": False, "error": "No se encontraron documentos"}), 404

    documentos = []
    for fila in filas:
        ID_DOCUMENTO,NOMBRE = fila
        documentos.append({
            "ID_DOCUMENTO": ID_DOCUMENTO,
            "NOMBRE": NOMBRE
        })

    return jsonify({"estatus": True, "documentos": documentos})

@app.route('/traerDocumentoLlenado', methods=['GET'])
def traerDocumentoLlenado():

    conexion = conectar_bd("BDTEC")
    if not conexion:
        return jsonify({"estatus": False, "error": "No se pudo conectar a la base de datos"}), 500

    cursor = conexion.cursor()

    cursor.execute("SELECT ID_DOCUMENTO,NOMBRE FROM DOCUMENTO")
    filas = cursor.fetchall()   # ← CAMBIO IMPORTANTE
    conexion.close()

    if not filas:
        return jsonify({"estatus": False, "error": "No se encontraron documentos"}), 404
    datos_json = []
    for fila in filas:
        (ID_DOCUMENTO,NOMBRE) = fila 
        datos_json.append({
            "ID_DOCUMENTO": ID_DOCUMENTO,
            "NOMBRE": NOMBRE
        })

    return jsonify({"estatus": True, "datos_json": datos_json})

@app.route('/traerDocumento', methods=['POST'])
def traerDocumento():
    id_documento = request.json.get('idDocumento')
    id_docente = request.json.get('idDocente')
    conexion = conectar_bd("BDTEC")
    if not conexion:
        return jsonify({"estatus": False, "error": "No se pudo conectar a la base de datos"}), 500

    cursor = conexion.cursor()
    print(id_documento)
    print(id_docente)
    cursor.execute("SELECT DATOS_JSON FROM EMPLEADOSXDOCUMENTO WHERE ID_DOCUMENTO = ? and ID_EMPLEADO = ?",(id_documento,id_docente))
    filas = cursor.fetchone()   # ← CAMBIO IMPORTANTE
    conexion.close()
    print(filas)

    if not filas:
        return jsonify({"estatus": False, "error": "No se encontraron documentos"}), 404
    datos_json = filas[0]
    return jsonify({"estatus": True, "datos_json": datos_json})

@app.route('/actualizarDocumentos', methods=['POST'])
def actualizarDocumentos():
    try:
        data = request.get_json()
        id_empleado = data.get("idEmpleado")
        id_documento = data.get("idDocumento")
        datos_json = data.get("datosJson")
        conexion = conectar_bd("BDTEC")
        import json
        datos_json_str = json.dumps(datos_json)

        if not conexion:
            print("No se pudo conectar a la base de datos TEC")
        
        cursor = conexion.cursor()
        print("Datos a actualizar:", datos_json)
        cursor.execute("UPDATE EMPLEADOSXDOCUMENTO SET DATOS_JSON = ? WHERE ID_EMPLEADO = ? AND ID_DOCUMENTO = ?", (datos_json_str,id_empleado, id_documento))
        conexion.commit()
        conexion.close()
        return jsonify({"estatus": True})
    
    except Exception as e:
        print("❌ Error al actualizar documentos:", e)
        return jsonify({"estatus": False, "error": str(e)}), 500
    
@app.route('/insertarDocumento', methods=['POST']) 
def insertarDocumento():
    try:
        data = request.get_json()
        id_empleado = data.get("idEmpleado")
        id_documento = data.get("idDocumento")
        datos_json = data.get("datosJson")
        
        conexion = conectar_bd("BDTEC")
        if not conexion:
            print("No se pudo conectar a la base de datos TEC")
            return
        
        import json
        datos_json_str = json.dumps(datos_json)

        cursor = conexion.cursor()
        cursor.execute("SELECT COUNT(*) FROM EMPLEADOSXDOCUMENTO WHERE ID_EMPLEADO = ? AND ID_DOCUMENTO = ? ", (id_empleado, id_documento))
        resultado = cursor.fetchone()
        if resultado and resultado[0] > 0:
            conexion.close()
            return {"estatus": False, "error": "El registro ya existe."}

        cursor.execute("INSERT INTO EMPLEADOSXDOCUMENTO (ID_EMPLEADO, ID_DOCUMENTO, DATOS_JSON) VALUES (?, ?, ?)", (id_empleado, id_documento, datos_json_str))
        cursor.execute("SELECT NOMBRE FROM DOCUMENTO WHERE ID_DOCUMENTO = ?", (id_documento,))
        fila = cursor.fetchone()
        nombreDoc    = fila[0] if fila else ""
        conexion.commit()
        conexion.close()

        conexion = conectar_bd("EDDO")
        if not conexion:
            print("No se pudo conectar a la base de datos")
            return
        
        cursor = conexion.cursor()
        cursor.execute("SELECT CORREO FROM DOCENTE WHERE ID_DOCENTE  = ?", (id_empleado,))
        fila = cursor.fetchone()
        correo = fila[0] if fila else ""
        print("Correo obtenido:", correo)
        print("Nombre del documento:", nombreDoc)
        llenadoDoc(conexion,correo,nombreDoc)
        
        conexion.close()
        return {"estatus": True}
    
    except Exception as e:
        print("❌ Error al insertar documento:", e)
        return {"estatus": False, "error": str(e)}
    
@app.route('/traerDatosDocumento', methods=['POST'])
def traerDatosDocumento():
    try:
        data = request.get_json()
        id_documento = data.get("idDocumento")

        conexion = conectar_bd("BDTEC")
        if not conexion:
            return jsonify({"estatus": False, "error": "No se pudo conectar a la base de datos"}), 500

        cursor = conexion.cursor()
        cursor.execute("SELECT DATOS_JSON FROM DOCUMENTO WHERE ID_DOCUMENTO = ?", (id_documento,))
        fila = cursor.fetchone()
        conexion.close()

        if fila:  # ← extraer el string del JSON
            datos_json = fila[0]
            return jsonify({
                "estatus": True,
                "datos_json":datos_json 
            })

        else:
            return jsonify({
                "estatus": False,
                "error": "No se encontraron datos del documento"
            }), 404

    except Exception as e:
        print("❌ Error al consultar datos del documento:", e)
        return jsonify({"estatus": False, "error": str(e)}), 500

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000, debug=False, use_reloader=False)






