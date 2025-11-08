from flask import Flask, request, jsonify
import smtplib, random
from email.message import EmailMessage
from flask_cors import CORS

app = Flask(__name__)
CORS(app)
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

if __name__ == "__main__":
    app.run(debug=True)
