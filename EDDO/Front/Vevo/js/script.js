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
    sessionStorage.clear();
    window.location.href = "inicioSesion.html";
  });
}


function login(){
  const input = document.getElementById('password');
  const btn = document.getElementById('btnVerContrasea');
  const btniniciar = document.getElementById('btnIniciarSesion');
  const lblError = document.getElementById("lblError");
  if (btniniciar) {
    enterEnviar();
    btniniciar.addEventListener('click', (event) => {

      if (!validarLogin()) return;
      btniniciar.innerHTML = "Cargando...";
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
                sessionStorage.setItem("idUsuario", data.id_docente);
                if(data.id_docente < 1000)
                  window.location.href = "principal.html";
                else
                  window.location.href = "EddoJefe.html";
                btniniciar.innerHTML = "Iniciar Sesión";
              } else {
                lblError.hidden = false;
                lblError.textContent = data.error;
                alert("Error: " + data.error);
                btniniciar.innerHTML = "Iniciar Sesión";
              }
            }).catch(error => {
              lblError.hidden = false;
              lblError.textContent = "Error de conexión.";
              btniniciar.innerHTML = "Iniciar Sesión";
        });
    });
  }

  if (btn && input) {
    ver("password", "btnVerContrasea");
  }

  function  validarLogin(){
    const correo = document.getElementById('email').value;
    const contra = document.getElementById('password').value;
    if(correo === "" || contra === ""){
      lblError.hidden = false;
      lblError.textContent = "Ambos campos son obligatorios.";
      return false;
    }
    lblError.hidden = true;
    return true;
  }

  function enterEnviar(){
    const inputContra = document.getElementById("password");
    inputContra.addEventListener("keypress", (e) => {
      if (e.key === "Enter") {
          e.preventDefault();
          btniniciar.click();
      }
    });
  }


}

async function pagina(){
  const links = document.querySelectorAll(".sidebar a");
  const botonCuenta = document.getElementById("btnCuenta");
  
  loadPage("inicio.html");

  links.forEach(link => {
    const liPadre = link.parentElement;
    link.addEventListener("click", e => {
      e.preventDefault();

      liPadre.classList.add("active");
      botonCuenta.classList.remove("active");
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


  loadPage("inicio.html");

  botonCuenta.addEventListener("click", () => {
    botonCuenta.classList.add("active");
    links.forEach(link => {
      link.parentElement.classList.remove("active"); 
    });
    const page = botonCuenta.getAttribute("data-page");
    loadPage(page);
  });

}

    /*Funciones para rellenar los datos de la interfaz Cuenta*/
async function actualizarDatosCuenta(datos1){
    const datos = datos1[0];
    const textNombre = document.getElementById("textNombre");
    if (textNombre) {
      textNombre.textContent = datos["NOMBRE"] + " " + datos["APELLIDO_PAT"] + " " + datos["APELLIDO_MAT"];
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
async function agregarRegistroDocumento(expediente, documentos) {
  const tbody = document.querySelector("#tablaDocumentos tbody");

  if (!expediente || !expediente.expediente) {
    console.error("No se pudieron obtener los datos del expediente.");
    const lblError = document.getElementById("lblError");
    lblError.hidden = false;
    lblError.textContent = "No se pudieron obtener los datos del expediente.";
    return;
  }
  

  tbody.innerHTML = "";

  // Ordenar: primero Generada, luego Pendiente
  const docsOrdenados = documentos.Documentos.sort((a, b) => {
    const existeA = expediente.expediente.some(item => item.Nombre_documento === a.NOMBRE);
    const existeB = expediente.expediente.some(item => item.Nombre_documento === b.NOMBRE);

    // Queremos que Generada (true) vaya antes → ordenar descendente
    return (existeA === existeB) ? 0 : existeA ? -1 : 1;
  });

  // Ya recorremos la lista ordenada
  docsOrdenados.forEach(doc => {
    const existe = expediente.expediente.some(item => item.Nombre_documento === doc.NOMBRE);
    const estado = existe ? "Generada" : "Pendiente";

    const tr = document.createElement("tr");

    tr.innerHTML = `
      <td><i></i> ${doc.NOMBRE}</td>
      <td class="status ${estado}"><i></i> ${estado}</td>
      <td><a id = "btnDescargar" class="btn descargar" ${existe ? "" : "hidden"}>Descargar</a></td>
      <td><button type="button" class="btn ver" data-section="ver-documento" ${existe ? "" : "hidden"}>Ver</button></td>
      <td><button type="button" class="btn abrir">Abrir</button></td>
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
        const lblError = document.getElementById("lblErrorReclamo");
        lblError.hidden = false;
        lblError.textContent = "No se pudieron obtener los datos de los reclamos.";
        return;
    }
    reclamos.reclamos.forEach(rec => {
      const nombreDoc = rec.nombre_documento;
      const idReclamo = rec.id_reclamo;
      const folioDoc = rec.folio;
      const fecha = new Date(rec.fecha).toLocaleDateString();
      const estado = "sale";
      if (rec.id_reclamo) {
      const tr = document.createElement("tr");
        tr.innerHTML = `
                <td><i></i>${idReclamo}</td>
                <td class=""><i></i> ${nombreDoc}</td>
                <td class=""><i></i> ${folioDoc}</td>
                <td class=""><i></i> ${fecha}</td>
                <td class="status ${estado}"><i></i> ${estado}</td>
                <td><button class="btn abrir" id = "btn abrir">Abrir</button></td>`;
        tbody.appendChild(tr);
      }
  });
}

async function traerDatosReclamo() {
  try {
    console.log("📄 Solicitando reclamos para:", sessionStorage.getItem("idUsuario"));
    const response = await fetch("http://localhost:5000/reclamos", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ idUsuario: sessionStorage.getItem("idUsuario") })
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

function btnsAbrirReclamo(){
  const botonesVer = document.querySelectorAll(".btn.abrir");
  
  
  botonesVer.forEach(btn => {
    btn.addEventListener("click", () => {
      const fila = btn.closest("tr");

      const idReclamo = fila.querySelector("td").innerText.trim();

      sessionStorage.setItem("idReclamo", idReclamo);
      if(sessionStorage.getItem("documentoSeleccionado")){
        sessionStorage.removeItem("documentoSeleccionado", 0);
      }
      console.log("Reclamo:", idReclamo);
      loadPage("chat.html");
    });
    
  });
}

async function descargarDocumento(nombreDoc){
  fetch("http://localhost:5000/generar-constancia", {
    method: "POST",
    headers: {
      "Content-Type": "application/json"
    },
    body: JSON.stringify({
      nombreDoc: nombreDoc,
      idUsuario: sessionStorage.getItem("idUsuario")
    })
  })
  .then(res => res.blob())  // <--- AQUÍ RECIBES EL PDF
  .then(blob => {
      const url = window.URL.createObjectURL(blob);
      const link = document.getElementById("linkDescarga");
      link.href = url;
      link.download = nombreDoc + ".pdf";
      link.addEventListener("click", () => {
            setTimeout(() => {
              window.URL.revokeObjectURL(link.href);
            }, 5000); // 5 segundos después de descargar
          });
          link.click(); 
          console.log("Descarga iniciada para:", nombreDoc);
  }).catch(err => console.log(err));
}
function descargarTodosDocumentos(){
  const btnDescargarTodos = document.getElementById("btnDescargarTodos");
  btnDescargarTodos.addEventListener("click", async () => {
    console.log("Iniciando descarga de todos los documentos...");
    const documentos1 = await traerDatosExpediente();
    const documentos = documentos1.expediente;
    console.log("Descargando todos los documentos:", documentos);
    for (const doc of documentos) {
      const nombreDoc = doc.Nombre_documento;
      console.log("Descargando documento:", nombreDoc);
      await descargarDocumento(nombreDoc);
    }
  });
}

async function mostrarDocumento(nombreDoc){
  fetch("http://localhost:5000/generar-constancia", {
    method: "POST",
    headers: {
      "Content-Type": "application/json"
    },
    body: JSON.stringify({
      nombreDoc: nombreDoc,
      idUsuario: sessionStorage.getItem("idUsuario")
    })
  })
  .then(res => res.blob())  // <--- AQUÍ RECIBES EL PDF
  .then(blob => {
    const url = window.URL.createObjectURL(blob);
      const framDoc = document.getElementById("framDoc");
      const btnDescargar = document.getElementById("btnDescargar");

      btnDescargar.href = url;
      btnDescargar.download = nombreDoc + ".pdf";
      framDoc.src = url;
      const lblError = document.getElementById("lblCargando");
      lblError.hidden = true;
      btnDescargar.addEventListener("click", () => {
        setTimeout(() => {
          window.URL.revokeObjectURL(btnDescargar.href);
        }, 5000); // 5 segundos después de descargar
      });
  }).catch(err => console.log(err));

}

function guardarNombreDoc(){
  const botonesVer = document.querySelectorAll(".btn.ver");
  
  botonesVer.forEach(btn => {
    btn.addEventListener("click", () => {
      const fila = btn.closest("tr");
      
      const nombreDoc = fila.querySelector("td").innerText.trim();

      sessionStorage.setItem("documentoSeleccionado", nombreDoc);


      loadPage("verDocumento.html");
      mostrarDocumento(nombreDoc);
    });

  });
    const botonesAbir= document.querySelectorAll(".btn.abrir");
    botonesAbir.forEach(btn => {
    btn.addEventListener("click", () => {
      const fila = btn.closest("tr");
      
      const nombreDoc = fila.querySelector("td").innerText.trim();
      sessionStorage.removeItem("idReclamo", 0);

      sessionStorage.setItem("documentoSeleccionado", nombreDoc);
      console.log("📄 Documento guardado:", nombreDoc);
      if(sessionStorage.getItem("idReclamo")){
        sessionStorage.removeItem("idReclamo", 0);
      }
      loadPage("chat.html");
    });
  });

    const botonesDescargar = document.querySelectorAll(".btn.descargar");
    botonesDescargar.forEach(btn => {
    btn.addEventListener("click", async () => {
      const fila = btn.closest("tr");
      
      const nombreDoc = fila.querySelector("td").innerText.trim();
      await descargarDocumento(nombreDoc);
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
      body: JSON.stringify({ idUsuario: sessionStorage.getItem("idUsuario") })
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
    const response = await fetch("http://localhost:5000/expedient", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ idUsuario: sessionStorage.getItem("idUsuario") })
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

async function todosDocumentos() {
  try {
    const response = await fetch("http://localhost:5000/todosDocumentos", {
      method: "POST",
      headers: { "Content-Type": "application/json" }
    });

    const data = await response.json();

    if (data.estatus) {
      console.log("Datos de los documentos:", data);
      return data;
    } else {
      console.error("Error:", data.error);
      return null;
    }
  } catch (error) {
    console.error("Error en todos los documentos:", error);
    return null;
  }
}

function registro(){
  const btnRegistro = document.getElementById("btnRegistro");
  const lblError = document.getElementById("lblError");
  ver("password1","btnVerContrasea")
  ver("password2","btnVerContrasea2")

  btnRegistro.addEventListener("click",async ()=>{
    lblError.hidden = true;
    const correo = document.getElementById("email").value;
    const contra1 = document.getElementById("password1").value;
    const contra2 = document.getElementById("password2").value;


    if (contra1 != contra2){
      lblError.textContent = "La contraseña no es la misma, pon la misma en los dos campos";
      lblError.hidden = false;
    }else{
      const data = await registrarDocente(correo,contra1);
      console.log(data);
      if(data.estatus){
          window.location.href = "inicioSesion.html";
      }else{
        lblError.textContent = data.error;
        lblError.hidden = false;
      }
    } 

  });
  const btnRegresar = document.getElementById("btnRegresar");
  btnRegresar.addEventListener("click", () => {
    window.location.href = "inicioSesion.html";
  });
  
}

async function registrarDocente(correo,contra){
    try {
    const response = await fetch("http://localhost:5000/registrarDocente", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({CORREO:correo,  CONTRA: contra })
    });

    const data = await response.json();

    if (data.estatus) {
      return data;
    } else {
      console.error("Error:", data.error);
      return data;
    }
  } catch (error) {
    console.error("Error al registrar:", error);
    return null;
  }
}

async function validarRequi(){
  fetch("http://localhost:5000/validarRequisito", {
          method: "POST",
          headers: {
              "Content-Type": "application/json"
          },
          body: JSON.stringify({ idUsuario: sessionStorage.getItem("idUsuario")})
      })
      .then(response => response.json())
      .then(data => {
          return data.estatus;
          }).catch(error => {
            lblError.hidden = false;
            lblError.textContent = "Error de conexión.";
            btniniciar.innerHTML = "Iniciar Sesión";
      });
}

/* Funcion que cambia de html dependiendo la page*/ 
function loadPage(page) {
  fetch(`pages/${page}`)
  .then(response => response.text())
  .then(async html => {
      content.innerHTML = html;

    if (page === "expediente.html") {
      const expediente = await traerDatosExpediente();
      const documentos = await todosDocumentos();
      const btnBuscar = document.getElementById("btnBuscar");
      const inputFiltro = document.getElementById("inputBuscar");
      btnBuscar.addEventListener("click", () => {
        const expediente2 = {};
        const listaFiltrada = [];
        const filtro = inputFiltro.value.toLowerCase();
        if(filtro !== ""){
            documentos.Documentos.forEach(doc => {
              if(doc.NOMBRE.toLowerCase().includes(filtro)){
                listaFiltrada.push(doc);
              }
            });
          expediente2.Documentos = listaFiltrada;
          agregarRegistroDocumento(expediente, expediente2);
        }else{
          agregarRegistroDocumento(expediente,documentos);
        }
        guardarNombreDoc();
        descargarDocumentos();
      });
      inputFiltro.addEventListener("input", () => {
        if(inputFiltro.value === ""){
          agregarRegistroDocumento(expediente,documentos);
        }else{
          btnBuscar.click();
        }
      });
      agregarRegistroDocumento(expediente,documentos);

      guardarNombreDoc();
      descargarTodosDocumentos();

    }
    if(page === "inicio.html"){
      //const validarRequitos = await validarRequi();
      const validarRequitos = true;
      const resultado = await traerDatosCuenta();

      if (validarRequitos){
        const nombreDocente = resultado.cuenta[0].NOMBRE+" "+resultado.cuenta[0].APELLIDO_PAT+" "+resultado.cuenta[0].APELLIDO_MAT;
        const saludoElemento = document.getElementById("saludoDocente");
        if (saludoElemento && nombreDocente) {
          saludoElemento.textContent = `${nombreDocente}`;
        }
      }else {
        const btnExpediente = document.getElementById("btnExpediente");
        const btnReclamo = document.getElementById("btnReclamo");
        btnExpediente.style.display = "none";
        btnReclamo.style.display = "none";
        loadPage("noCumple.html");
      }
    }

    if(page === "verDocumento.html"){
      regresarPaginaExpediente();
    }

    if (page === "reclamo.html") {
      /*if(sessionStorage.getItem("reclamos")){
        const expediente = JSON.parse(sessionStorage.getItem("reclamos"));
        agregarReclamo(expediente);
      }else {
        const expediente = await traerDatosReclamo();
        if (expediente) {
          sessionStorage.setItem("reclamos", JSON.stringify(expediente));
          agregarReclamo(expediente);
        }
      }*/
      const expediente = await traerDatosReclamo();
      if (expediente) {
        agregarReclamo(expediente);
        btnsAbrirReclamo();
      }
    }

    if (page === "cuenta.html") {
        const resultado = await traerDatosCuenta();
        if (resultado && resultado.estatus) {
          actualizarDatosCuenta(resultado.cuenta);
        }
        const btncambiarContra = document.getElementById("btnCambiarContra");
        btncambiarContra.addEventListener("click", () => {
          loadPage("cambiarContra.html");
        });
    }
    if (page === "chat.html"){
      actualizarChat();
      mandarMsj();
    }
    if (page === "cambiarContra.html") {
      cambiarContraActual();
    }
  }).catch((error) => {
    console.error("Error al cargar la página:", page, error);
    content.innerHTML = "<h2>Error al cargar la página</h2>";
  });
}

async function traerMensajes() {
  try {
    console.log("📨 Solicitando mensajes para:", sessionStorage.getItem("idUsuario"), sessionStorage.getItem("idReclamo"), sessionStorage.getItem("documentoSeleccionado"));
    const response = await fetch("http://localhost:5000/traer-mensajes", {
      method: "POST",
      headers: {
        "Content-Type": "application/json"
      },
      body: JSON.stringify({
        idUsuario: sessionStorage.getItem("idUsuario"),
        nombreDoc: sessionStorage.getItem("idReclamo"),
        documentoSeleccionado: sessionStorage.getItem("documentoSeleccionado")
      })
    });

    const data = await response.json();
    console.log("📨 Mensajes recibidos:", data);

    // Si el backend devuelve directamente un array
    if (Array.isArray(data)) {
      return data;
    }

    // Si el backend devuelve un objeto con estatus/mensajes
    if (data.estatus) {
      return data;
    }

    return [];

  } catch (error) {
    console.error("❌ Error al traer mensajes:", error);
    return [];
  }
}

async function actualizarChat(){
  const mensajes = await traerMensajes();
  const ventanaMensajes = document.getElementById('ventanaMensajes');

  ventanaMensajes.innerHTML = '';
  if (!mensajes || !mensajes.estatus) {
    console.error("No se pudieron obtener los mensajes.");
    return;
  }

  console.log("Mensajes para actualizar el chat:", mensajes);
  const tipo = sessionStorage.getItem("idUsuario") <= 999 ? "DOCENTE" : "JEFE";
  console.log("Tipo de usuario:", tipo);
  console.log("Mensajes recibidos:", sessionStorage.getItem("idUsuario"));

  mensajes.msjs.forEach(msj => {
    const fecha = msj["fecha"];
    const horaMin = fecha.split(" ")[1].slice(0, 5);
    actualizarMsjVentana(msj["descripcion"],msj["remitente"] === tipo ? "uno" : "dos", horaMin);
  });

}

function actualizarMsjVentana(msj,tipo,horaMin="00:00"){ 
    const ventanaMensajes = document.getElementById('ventanaMensajes');
    const inputMsj = document.getElementById('inputMensaje');
    const tr = document.createElement("div");

    tr.innerHTML = `
    <div class="divMsj ${tipo}">
    <div class="msj ${tipo}">
                <p>${msj}</p>
                <p class = "horaMsj">${horaMin}</p>
            </div>
        </div>
    `;

    ventanaMensajes.appendChild(tr);
    inputMsj.value = "";
}

function mandarMsj() {
  const btnEnviarMsj = document.getElementById('btnEnviarMsj');
  const inputMsj = document.getElementById('inputMensaje');

  btnEnviarMsj.addEventListener('click', () => {
    const msj = inputMsj.value.trim(); 

    if (msj === "") return; 
    
    
    if(mandarMsjAlBackend(msj)){
      alert("Error al enviar el mensaje.");
    }
    actualizarMsjVentana(msj, "uno");
  });
    inputMsj.addEventListener("keypress", (e) => {
    if (e.key === "Enter") {
        e.preventDefault();
        btnEnviarMsj.click();
    }
    });
}

function mandarMsjAlBackend(mensaje) {
  fetch("http://localhost:5000/guardar-mensaje", {
    method: "POST",
    headers: {
      "Content-Type": "application/json"
    },
    body: JSON.stringify({ idUsuario: sessionStorage.getItem("idUsuario"), idReclamo: sessionStorage.getItem("idReclamo"), mensaje: mensaje,  nombreDoc: sessionStorage.getItem("documentoSeleccionado") })
  })
  .then(response => response.json())
  .then(data => {
    if (data.estatus) {
      console.log("Mensaje enviado con éxito.");
      return true;
    } else {  
      console.error("Error al enviar el mensaje:", data.error);
      return false;
    }
  }).catch(error => {
    console.error("Error:", error);
    return false;
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
      if(validadarContra('passwordNueva', 'passwordConfirmar')){
          fetch("http://localhost:5000/cambiarContraActual", {
          method: "POST",
          headers: {
              "Content-Type": "application/json"
          },
          body: JSON.stringify({ idUsuario: sessionStorage.getItem("idUsuario"), contraActual: passwordActual, contraNueva: passwordNueva})
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
    const btnRegresar = document.getElementById('btnRegresarContra');
    btnRegresar.addEventListener('click', () => {
      loadPage('cuenta.html');
    } );
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
        btnEnviarCodigo.innerHTML = "ENVIANDO...";
        if(!await verificarCorreo(correo)){
            lblError.hidden = false;
            lblError.textContent = "El correo no está registrado.";
            btnEnviarCodigo.innerHTML = "ENVIAR CODIGO";
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
                sessionStorage.setItem("correo", correo);
                sessionStorage.setItem("codigo", data.codigo);
                window.location.href = "ingresarCodigo.html";
                btnEnviarCodigo.innerHTML = "Enviar Código";
            } else {
                alert("Error: " + data.error);
                btnEnviarCodigo.innerHTML = "ENVIAR CODIGO";
            }
        })
        .catch(error => {
          console.error("Error:", error);
          btnEnviarCodigo.innerHTML = "ENVIAR CODIGO";
        });
      });
    regresar('btnRegresar', 'inicioSesion.html');
  
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
    const lblError = document.getElementById("lblError");
    let codigo = sessionStorage.getItem('codigo');
    
    btnEnviarCodigo.addEventListener('click', (e) => {
        e.preventDefault();
        const codigoIngresado = cells.map(c => c.value).join('');
        if(codigoIngresado === codigo){
            window.location.href = "restablecerContra.html";
        } else {
            lblError.hidden = false;
            lblError.textContent = "Código incorrecto. Inténtalo de nuevo.";
        }
    });
    regresar('btnRegresar', 'recuperarContra.html');

    if (cells.length > 0) {
      setTimeout(() => cells[0].focus(), 0);
    }

    cells.forEach((cell, index) => {
        cell.addEventListener('input', () => {
            lblError.hidden = true;
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

function regresar(btnId, page){
  const btnRegresar = document.getElementById(btnId);
  btnRegresar.addEventListener("click", () => {
    window.location.href = page;
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
          body: JSON.stringify({ correo: sessionStorage.getItem("correo"), contraNueva: password})
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
    const btnRegresar = document.getElementById("btnRegresar");
    btnRegresar.addEventListener("click", () => {
      window.location.href = "inicioSesion.html";
    }); 
}
