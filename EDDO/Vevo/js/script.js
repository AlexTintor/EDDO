
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
    modal.style.display = "none"; // Ocultar modal
  });

  btnConfirmar.addEventListener("click", () => {
    localStorage.clear();
    window.location.href = "login.html";
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
                window.location.href = "principal.html";
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

function pagina(){
  const links = document.querySelectorAll(".sidebar a");
  const content = document.getElementById("content");

  // Cargar por defecto la página de inicio
  console.log("Cargando página de inicio por defecto");
  loadPage("inicio.html");
  console.log("Página de inicio cargada");

  links.forEach(link => {
    link.addEventListener("click", e => {
      e.preventDefault();
      const page = e.target.getAttribute("data-page");
      loadPage(page);

    });
  });
  
  const botonCuenta = document.querySelector(".cuenta");

  loadPage("inicio.html");

  botonCuenta.addEventListener("click", () => {
    const page = botonCuenta.getAttribute("data-page");
    loadPage(page);
  });



    /*Funciones para rellenar los datos de la interfaz Cuenta*/
  function actualizarDatosCuenta(){
      // 👇 Ahora sí existe el elemento textNombre
      const datos = traerDatos();
      const textNombre = document.getElementById("textNombre");
      if (textNombre) {
        textNombre.textContent = datos["nombre"];
      }

      const textCorreo = document.getElementById("textCorreo");
      if (textCorreo) {
        textCorreo.textContent = datos["correo"];
      }

      const textTelefono = document.getElementById("textTelefono");
      if(textTelefono){
        textTelefono.textContent = datos["telefono"];
      }

      const textDepa = document.getElementById("textDepa");
      if(textDepa){
        textDepa.textContent = datos["depa"];
      }

      const textCampus = document.getElementById("textCampus");
      if(textCampus){
        textCampus.textContent = datos["campus"];
      }

  }

  function traerDatos(){
    const nombre = "Irvin Jair Carrillo Beltran";
    const correo = "Irvin@culiacan.tecnm.mx";
    const telefono = "66745968258";
    const depa = "Ciencias de la computacion";
    const campus = "Culiacan";
    const datos = {
      "nombre":nombre,
      "campus":campus,
      "correo":correo,
      "depa":depa,
      "telefono":telefono};
    return datos;
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


  /* Funcion para agregar un nuevo documento a la tabla de expediente */
async function agregarRegistroDocumento() {
  const datos = await traerDatosExpediente();
  const tbody = document.querySelector("#tablaDocumentos tbody");


  if (!datos || !datos.expediente) {
    console.error("No se pudieron obtener los datos del expediente.");
    return;
  }

    datos.expediente.forEach(doc => {
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
function agregarReclamo() {
    const tbody = document.querySelector("#tablaReclamos tbody");

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




/* Funcion que cambia de html dependiendo la page*/ 
function loadPage(page) {
  fetch(`pages/${page}`)
  .then(response => response.text())
  .then(html => {
      content.innerHTML = html;

      if (page === "expediente.html") {
        agregarRegistroDocumento(); 
        guardarNombreDoc();
      }


      if(page === "verDocumento.html"){
        regresarPaginaExpediente();
      }
    })

    .catch(() => {
      content.innerHTML = "<h2>Error al cargar la página</h2>";
    });
  }
}
