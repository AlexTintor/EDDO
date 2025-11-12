document.addEventListener("DOMContentLoaded", () => {
  login();
});

/*Funcion que se encarga de desplegar la ventana de cerrar Sesion y mandarte al login */
function desplegarInterfazSalir(){
  const modal = document.getElementById("modalSalida");
  const btnConfirmar = document.getElementById("confirmarSalir");
  const btnCancelar = document.getElementById("cancelarSalir");

    modal.style.display = "flex"; 

  btnCancelar.addEventListener("click", () => {
    modal.style.display = "none"; 
  });

  btnConfirmar.addEventListener("click", () => {
    localStorage.clear();
    window.location.href = "inicioSesion.html";
  });
}


function login(){
  const input = document.getElementById('password');
  const btn = document.getElementById('btnVerContrasea');
  const btniniciar = document.getElementById('btnIniciarSesion');

  if (btniniciar) {
    btniniciar.addEventListener('click', (event) => {
      event.preventDefault();
      const correo = document.getElementById('email').value;
      const contra = document.getElementById('password').value;
      fetch("http://localhost:5000/login", {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify({ correo: correo, contra: contra})
        })
        .then(response => response.json())
        .then(data => {
            if (data.estatus) {
                localStorage.setItem("idDocente", data.id_docente);
                if(data.id_docente < 1000)
                  window.location.href = "principal.html";
                else
                  window.location.href = "EddoJefe.html";
            } else {
                alert("Error: " + data.error);
            }
        })
        .catch(error => {
            console.error("Error:", error);
        });
    });
  }


  if (btn && input) {
    btn.addEventListener('click', () => {
      const visible = input.type === 'text';
      input.type = visible ? 'password' : 'text';
    });
  }
}

async function pagina(){
  const links = document.querySelectorAll(".sidebar a");
  const resultado = await traerDatosCuenta();
  if (resultado && resultado.estatus) {
    localStorage.setItem("nombreDocente", resultado.cuenta[0].NOMBRE);
    localStorage.setItem("datosCuenta", JSON.stringify(resultado.cuenta));
  }
  
  loadPage("inicio.html");

  links.forEach(link => {
    const liPadre = link.parentElement;
    link.addEventListener("click", e => {
      e.preventDefault();

      liPadre.classList.add("active");

      links.forEach(otherLink => {
        if (otherLink !== link) {
          otherLink.parentElement.classList.remove("active");
          opcionActual = link; 
        }
      }
    );

      const page = e.target.getAttribute("data-page");
      loadPage(page);

    });
  });
  const btnSalir = document.getElementById("btnCerrarSesion");
  btnSalir.addEventListener("click", desplegarInterfazSalir);

  const botonCuenta = document.querySelector(".cuenta");

  loadPage("inicio.html");

  botonCuenta.addEventListener("click", () => {

    links.forEach(link => {
      link.parentElement.classList.remove("active"); 
    });

    const page = botonCuenta.getAttribute("data-page");
    loadPage(page);
  });

}

    /*Funciones para rellenar los datos de la interfaz Cuenta*/
async function actualizarDatosCuenta(){
    const datos1 = localStorage.getItem("datosCuenta");
    const datos2 = JSON.parse(datos1);
    const datos = datos2[0];
    const textNombre = document.getElementById("textNombre");
    if (textNombre) {
      textNombre.textContent = datos["NOMBRE"];
    }

    const textCorreo = document.getElementById("textCorreo");
    if (textCorreo) {
      textCorreo.textContent = datos.CORREO;
    }
    

    const textTelefono = document.getElementById("textTelefono");
    if(textTelefono){
      textTelefono.textContent = datos.TELEFONO;
    }

    const textDepa = document.getElementById("textDepa");
    if(textDepa){
      textDepa.textContent = datos.DEPARTAMENTO;
    }

    const textCampus = document.getElementById("textCampus");
    if(textCampus){
      textCampus.textContent = datos.CAMPUS;
    }
}


  /* Funcion para agregar un nuevo documento a la tabla de expediente */
async function agregarRegistroDocumento(expediente) {
  const tbody = document.querySelector("#tablaDocumentos tbody");


  if (!expediente || !expediente.expediente) {
    console.error("No se pudieron obtener los datos del expediente.");
    return;
  }

    expediente.expediente.forEach(doc => {
    const tr = document.createElement("tr");
    const estado = doc.Aprovacion ? "Generada" : "Pendiente";

    tr.innerHTML = `
      <td><i></i> ${doc.Nombre_documento}</td>
      <td class="status ${estado}"><i></i> ${estado}</td>
      <td><button class="btn descargar">Descargar</button></td>
      <td><button class="btn ver" data-section="ver-documento">Ver</button></td>
      <td><button class="btn abrir">Abrir</button></td>
    `;
    tbody.appendChild(tr);
  });
}

/*Fumcopm para agregar reclamos de forma dinamica*/
function agregarReclamo(reclamos) {
    const tbody = document.querySelector("#tablaReclamos tbody");
    console.log("Reclamos recibidos para agregar:", reclamos);
    if (!reclamos || reclamos.reclamos.length === 0) {
        console.error("No se pudieron obtener los datos de los reclamos.");
        return;
    }
    reclamos.reclamos.forEach(rec => {
      const nombreDoc = rec.nombre_documento;
      const folioRec = rec.id_reclamo;
      const folioDoc = rec.folio;
      const fecha = new Date(rec.fecha).toLocaleDateString();
      const estado = "sale";
      if (rec.id_reclamo) {
      const tr = document.createElement("tr");
        tr.innerHTML = `
                <td><i></i>${folioRec}</td>
                <td class=""><i></i> ${nombreDoc}</td>
                <td class=""><i></i> ${folioDoc}</td>
                <td class=""><i></i> ${fecha}</td>
                <td class="status ${estado}"><i></i> ${estado}</td>
                <td><button class="btn abrir">Abrir</button></td>`;
        tbody.appendChild(tr);
      }
  });
}


/* Al presionar el btnVer de expediente guardara el nombre del archivo para cargarlo*/ 
function guardarNombreDoc(){
  const botonesVer = document.querySelectorAll(".btn.ver");

  botonesVer.forEach(btn => {
    btn.addEventListener("click", () => {
      const fila = btn.closest("tr");
      
      const nombreDoc = fila.querySelector("td").innerText.trim();

      localStorage.setItem("documentoSeleccionado", nombreDoc);

      console.log("📄 Documento guardado:", nombreDoc);
      loadPage("verDocumento.html");
    });
  });
}


/*cambia de ver el documento a el apartado de expediente */
function regresarPaginaExpediente(){
  const botonRegresar = document.getElementById("regresarPDF");
  if(botonRegresar){
    botonRegresar.addEventListener("click", () => {
      loadPage("expediente.html");
    });
  }
}






async function traerDatosCuenta(){
  try{
    const response = await fetch("http://localhost:5000/cuenta", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ idDocente: localStorage.getItem("idDocente") })
    });
    const data = await response.json();

    if (data.estatus) {
      console.log("Datos de cuenta:", data);
      return data;
    } else {
      console.log("Error:", data.error);
      return null;
    }
  } catch (error) {
    console.error("Error en traerDatosCuenta:", error);
    return null;
  }
}


async function traerDatosExpediente() {
  try {
    const response = await fetch("http://localhost:5000/expediente", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ idDocente: localStorage.getItem("idDocente") })
    });

    const data = await response.json();

    if (data.estatus) {
      console.log("Datos del expediente:", data);
      return data;
    } else {
      console.error("Error:", data.error);
      return null;
    }
  } catch (error) {
    console.error("Error en traerDatosExpediente:", error);
    return null;
  }
}

async function traerDatosReclamo() {
  try {
    const response = await fetch("http://localhost:5000/reclamos", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ idDocente: localStorage.getItem("idDocente") })
    });

    const data = await response.json();

    if (data.estatus) {
      console.log("Datos de la cuenta:", data);
      return data;
    } else {
      console.error("Error:", data.error);
      return null;
    }
  } catch (error) {
    console.error("Error en :", error);
    return null;
  }
}








/* Funcion que cambia de html dependiendo la page*/ 
function loadPage(page) {
  fetch(`pages/${page}`)
  .then(response => response.text())
  .then(async html => {
      content.innerHTML = html;

    if (page === "expediente.html") {
      if(localStorage.getItem("expediente")){
        const datos = JSON.parse(localStorage.getItem("expediente"));
        agregarRegistroDocumento(datos);
        guardarNombreDoc();
      } else {
        const datos = await traerDatosExpediente();
        if (datos) {
          localStorage.setItem("expediente", JSON.stringify(datos));
          agregarRegistroDocumento(datos);
          guardarNombreDoc();
        }
      }
    }
    if(page === "inicio.html"){
      const nombreDocente = localStorage.getItem("nombreDocente");
      const saludoElemento = document.getElementById("saludoDocente");
      if (saludoElemento && nombreDocente) {
        saludoElemento.textContent = ` ${nombreDocente}`;
      }
    }

    if(page === "verDocumento.html"){
      regresarPaginaExpediente();
    }

    if (page === "reclamo.html") {
      if(localStorage.getItem("reclamos")){
        const datos = JSON.parse(localStorage.getItem("reclamos"));
        agregarReclamo(datos);
      }else {
        const datos = await traerDatosReclamo();
        if (datos) {
          localStorage.setItem("reclamos", JSON.stringify(datos));
          agregarReclamo(datos);
        }
      }
    }

    if (page === "cuenta.html") {
      actualizarDatosCuenta();
        const btncambiarContra = document.getElementById("btnCambiarContra");
        btncambiarContra.addEventListener("click", () => {
          loadPage("cambiarContra.html");
        });
    }
    if (page === "cambiarContra.html") {
      cambiarContraActual();
    }
  }).catch((error) => {
    console.error("Error al cargar la página:", page, error);
    content.innerHTML = "<h2>Error al cargar la página</h2>";
  });
}


function cambiarContraActual(){
  ver('passwordActual', 'btnVerContraseña1');
  ver('passwordNueva', 'btnVerContraseña2');
  ver('passwordConfirmar', 'btnVerContraseña3');

  const btnCambiar = document.getElementById("btnCambiarContra");
  btnCambiar.addEventListener("click", () => {
      const passwordActual = document.getElementById("passwordActual").value;
      const passwordNueva = document.getElementById("passwordNueva").value;
      const lblError = document.getElementById("lblError");
      if(passwordActual === ""){
          lblError.hidden = false;
          lblError.textContent = "Ingresa tu contraseña actual.";
          return;
      }
      if(passwordNueva === passwordActual){
          lblError.hidden = false;
          lblError.textContent = "La nueva contraseña no puede ser igual a la actual.";
          return;
      }
      if(validadarContra('passwordNueva', 'passwordConfirmar')){
          fetch("http://localhost:5000/cambiarContraActual", {
          method: "POST",
          headers: {
              "Content-Type": "application/json"
          },
          body: JSON.stringify({ idDocente: localStorage.getItem("idDocente"), contraActual: passwordActual, contraNueva: passwordNueva})
          })
          .then(response => response.json())
          .then(data => {
              if (data.estatus) {
                  alert("Contraseña cambiada con éxito.");
                  loadPage("cuenta.html");
              } else {
                  lblError.hidden = false;
                  lblError.textContent = data.error;
              }
          })
          .catch(error => {
              console.error("Error:", error);
          });
      }

});
}



function enviarCodigo() {
    const btnEnviarCodigo = document.getElementById("btnEnviarCodigo");
    const lblError = document.getElementById("lblError");
    inputEmail = document.getElementById("email");

    inputEmail.addEventListener("click", () => {
        lblError.hidden = true;
    });
    btnEnviarCodigo.addEventListener("click", async () => {
        const correo = inputEmail.value;
        
        if(!validarCorreo(correo)){
            lblError.hidden = false;
            lblError.textContent = "Correo inválido.";
            return;
        }
        if(!await verificarCorreo(correo)){
            lblError.hidden = false;
            lblError.textContent = "El correo no está registrado.";
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
                localStorage.setItem("correo", correo);
                localStorage.setItem("codigo", data.codigo);
                window.location.href = "ingresarCodigo.html";
            } else {
                alert("Error: " + data.error);
            }
        })
        .catch(error => {
          console.error("Error:", error);
        });
      });
  
  function validarCorreo(email){
      const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

      if(email !== "" && re.test(email)){
          return true;
      }
      return false;
  }

  async function verificarCorreo(correo){
    const url = `http://localhost:5000/verificarCorreo?correo=${encodeURIComponent(correo)}`;

    return fetch(url, {
        method: "GET",
        headers: {
            "Content-Type": "application/json"
        }
    })
    .then(response => response.json())
    .then(data => {
        return data.estatus; // True o False según el backend
    })
    .catch(error => {
        console.error("Error:", error);
        return false;
    });
  }
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
            window.location.href = "restablecerContra.html";
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

function ver(inputId, btnId) {
  const input = document.getElementById(inputId);
  const btn = document.getElementById(btnId);
  if (btn && input) {
    btn.addEventListener('click', () => {
      input.type = input.type === 'text' ? 'password' : 'text';
    });
  }
}

function validadarContra(password01, password02){
  const lblError = document.getElementById("lblError");
  const password1 = document.getElementById(password01).value;
  const password2 = document.getElementById(password02).value;
  if(password1 === "" || password2 === ""){
    lblError.hidden = false;
    lblError.textContent = "Ambos campos son obligatorios.";
    return false; 
  }
  if(password1 != password2){
    lblError.hidden = false;
    lblError.textContent = "Ingresa la misma contraseña"
    return false;
  }
  if(password1 === password2){
    lblError.hidden = true;
    return true;
  }
  return false;
}

function restablecerContra(){
  ver('password2', 'btnVerContrasea');
  ver('password1', 'btnVerContrasea1');

  const btnRestablecer = document.getElementById("btnRestablecer");
  btnRestablecer.addEventListener("click", () => {

      if(validadarContra('password1', 'password2')){
          lblError.hidden = true;

          fetch("http://localhost:5000/cambiar-contrasena", {
          method: "POST",
          headers: {
              "Content-Type": "application/json"
          },
          body: JSON.stringify({ correo: localStorage.getItem("correo"), contraNueva: password})
          })
          .then(response => response.json())
          .then(data => {
              if (data) {
                  alert("Contraseña cambiada con éxito.");
                  window.location.href = "inicioSesion.html";
              } else {
                  alert("Error: " + data);
              }
          })
          .catch(error => {
              console.error("Error:", error);
          });
        }
    });
}
