document.addEventListener("DOMContentLoaded", ()=>{
    const pagina = window.location.pathname.split("/").pop();
    if(pagina === "ingresarCodigo.html"){
        validarCodigo();
    } else if (pagina === "recuperarContra.html"){
        enviarCodigo();
    }else if(pagina === "restablecerContra.html"){
        const input = document.getElementById('password');
        const btn = document.getElementById('btnVerContrasea');
          if (btn && input) {
            btn.addEventListener('click', () => {
            const visible = input.type === 'text';
            input.type = visible ? 'password' : 'text';
            });
        }
        const input1 = document.getElementById('password1');
        const btn1 = document.getElementById('btnVerContrasea1');
          if (btn1 && input1) {
            btn1.addEventListener('click', () => {
            const visible = input1.type === 'text';
            input1.type = visible ? 'password' : 'text';
            });
        }
    }
});
function enviarCodigo() {
    btnEnviarCodigo = document.getElementById("btnEnviarCodigo");
    lblError = document.getElementById("lblError");
    inputEmail = document.getElementById("email");

    inputEmail.addEventListener("click", () => {
        lblError.hidden = true;
    });
    btnEnviarCodigo.addEventListener("click", () => {
        const correo = inputEmail.value;
        
        if(!validarCorreo(correo)){
            lblError.hidden = false;
            return;
        }
        fetch("http://localhost:5000/enviar-codigo", {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify({ correo: correo })
        })
        .then(response => response.json())
        .then(data => {
            if (data.estatus) {
                window.location.href = "ingresarCodigo.html";
                localStorage.setItem("codigo", data.codigo);
            } else {
                alert("Error: " + data.error);
            }
        })
        .catch(error => {
            console.error("Error:", error);
        });


    });
}

function validarCorreo(email){
    const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

    if(email !== "" && re.test(email)){
        return true;
    }
    return false;
}

function validarCodigo(){
    const cells = [...document.querySelectorAll('.inputCelda')];
    const btnEnviarCodigo = document.getElementById('btnEnviarCodigo');
    let codigo = localStorage.getItem('codigo');
    
    btnEnviarCodigo.addEventListener('click', (e) => {
        e.preventDefault();
        const codigoIngresado = cells.map(c => c.value).join('');
        if(codigoIngresado === codigo){
            alert("Código verificado.");
        } else {
            alert("Código inválido.");
        }
    });

    cells.forEach((cell, index) => {
        cell.addEventListener('input', () => {
            if (cell.value.length === 1 && index < cells.length - 1) {
                cells[index + 1].focus();
            }
        });

    cell.addEventListener('keydown', (e) => {
    if (e.key === 'Backspace' && cell.value === '' && index > 0) {
        cells[index - 1].focus();
    }
    });
});
}