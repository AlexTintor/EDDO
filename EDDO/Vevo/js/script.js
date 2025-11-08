
document.addEventListener("DOMContentLoaded", () => {
  const links = document.querySelectorAll(".sidebar a");
  const content = document.getElementById("content");

  // Cargar por defecto la página de inicio
  loadPage("inicio.html");

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

  /* Funcion para agregar un nuevo documento a la tabla de expediente */
function agregarRegistroDocumento(nombre,estado) {
    const tbody = document.querySelector("#tablaDocumentos tbody");

    const tr = document.createElement("tr");

    tr.innerHTML = `
            <td><i></i> ${nombre}</td>
            <td class="status ${estado}"><i></i> ${estado}</td>
            <td><button class="btn descargar">Descargar</button></td>
            <td><button class="btn ver" data-section="ver-documento">Ver</button></td>
            <td><button class="btn abrir">Abrir</button></td>`;

    tbody.appendChild(tr);
}


/*Fumcopm para agregar reclamos de forma dinamica*/
function agregarReclamo(folioRec,nombreDoc,folioDoc,fecha,estado) {
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
      // 👇 Aquí el contenido ya se inserta correctamente
      content.innerHTML = html;
      actualizarDatosCuenta();


      if (page === "expediente.html") {
        agregarRegistroDocumento("Constancia de Servicios","Pendiente");
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
});

/*Agregando un evento al btn CerrarSesion */
const btnCerrarSesion = document.getElementById("btnCerrarSesion");
if (btnCerrarSesion) {
  btnCerrarSesion.addEventListener("click", () => {
    desplegarInterfazSalir();
  });
}

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
