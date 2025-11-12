from flask import Flask, request, jsonify
import smtplib, random
from email.message import EmailMessage
from flask_cors import CORS
from traerDatos import validarLogin, traerExpediente, traerReclamos, cambiarContra,cambiarContraActual
from bdTec import  traerEmpleados

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
    

@app.route("/datos-cuenta", methods=["POST"])
def datos_cuenta():
    data = request.get_json()
    docente_id = data.get("docenteId")

    if not docente_id:
        return jsonify({"ok": False, "error": "Faltan datos"}), 400

    conexion = conectar_bd("EDDO")
    if not conexion:
        return jsonify({"ok": False, "error": "No se pudo conectar a la base de datos"}), 500

    cuenta = traerExpediente(conexion, docente_id)
    conexion.close()

    if cuenta:
        return jsonify({"ok": True, "cuenta": cuenta})
    else:
        return jsonify({"ok": False, "error": "No se encontraron datos de la cuenta"}), 404


@app.route("/expediente", methods=["POST"])
def expediente():
    data = request.get_json()
    docente_id = data.get("idDocente")

    if not docente_id:
        return jsonify({"estatus": False, "error": "Faltan datos"}), 400

    conexion = conectar_bd("EDDO")
    if not conexion:
        return jsonify({"estatus": False, "error": "No se pudo conectar a la base de datos"}), 500

    expediente = traerExpediente(conexion, docente_id)
    conexion.close()

    if expediente:
        return jsonify({"estatus": True, "expediente": expediente})
    else:
        return jsonify({"estatus": False, "error": "No se encontró expediente"}), 404

@app.route("/reclamos", methods=["POST"])
def reclamos():
    data = request.get_json()
    docente_id = data.get("idDocente")

    if not docente_id:
        return jsonify({"estatus": False, "error": "Faltan datos"}), 400
    
    conexion = conectar_bd("EDDO")
    if not conexion:
        return jsonify({"estatus": False, "error": "No se pudo conectar a la base de datos"}), 500
    
    reclamos = traerReclamos(conexion, docente_id)
    conexion.close()
    
    if reclamos:
        return jsonify({"estatus": True, "reclamos": reclamos})
    else:
        return jsonify({"estatus": False, "error": "No se encontraron reclamos"}), 404
    

@app.route("/cuenta", methods=["POST"])
def cuenta():
    data = request.get_json()
    docente_id = data.get("idDocente")

    if not docente_id:
        return jsonify({"estatus": False, "error": "Faltan datos"}), 400

    conexion = conectar_bd("BDTEC")
    if not conexion:
        return jsonify({"estatus": False, "error": "No se pudo conectar a la base de datos"}), 500

    cuenta = traerEmpleados(conexion, docente_id)
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
    idDocente = data.get("idDocente")
    contraActual = data.get("contraActual")
    contraNueva = data.get("contraNueva")

    if not contraNueva or not contraActual:
        return jsonify({"estatus": False, "error": "Faltan datos"}), 400

    conexion = conectar_bd("EDDO")
    if not conexion:
        return jsonify({"estatus": False, "error": "No se pudo conectar a la base de datos"}), 500

    respuesta = cambiarContraActual(conexion, idDocente, contraActual,contraNueva)
    conexion.close()

    if respuesta["estatus"]:
        return jsonify({"estatus": True})
    else:
        return jsonify({"estatus": False, "error": respuesta["error"]}), 401
    
if __name__ == "__main__":
    app.run(debug=True)




