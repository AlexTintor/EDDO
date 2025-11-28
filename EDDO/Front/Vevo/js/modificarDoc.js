document.addEventListener("DOMContentLoaded", () => {
    cargarComboDocentes();
});

async function cargarComboDocentes() {
    const data = await traerDocentes();
    if (!data) return;

    console.log(data);

    const comboDocentes = document.getElementById("comboDocentes");
    
    // Si tu backend devuelve un array como data.docentes
    data.docentes.forEach(doc => {
        const option = document.createElement("option");
        option.value = doc.ID_EMPLEADO;   // value que usarás para backend
        option.textContent = doc.NOMBRE; // lo que ve el usuario
        comboDocentes.appendChild(option);
    });


    comboDocentes.addEventListener("change", async function() {
        const lblAviso = document.querySelector(".lblAviso");
        lblAviso.hidden = true;
        const formDatos = document.getElementById("formDatosJson");
        formDatos.innerHTML = "";
        const idDocenteSeleccionado = comboDocentes.value;
        console.log(idDocenteSeleccionado);
        const documento = await traerDocumentos(idDocenteSeleccionado);
        llenarComboDocumentos(documento);
    });


    const comboDocumento = document.getElementById("comboDocumento");

    function llenarComboDocumentos(documentos){
        comboDocumento.innerHTML = ""; 
        if (!documentos){
            const option = document.createElement("option");
            option.textContent = "Sin documentos"; // lo que ve el usuario
            comboDocumento.appendChild(option);
        }


        console.log(documentos);
        documentos.documentos.forEach(doc => {
            const option = document.createElement("option");
            option.class = "optionDocumento";
            option.value = doc.ID_DOCUMENTO;   // value que usarás para backend
            option.textContent = doc.NOMBRE; // lo que ve el usuario
            comboDocumento.appendChild(option);
        });
    }

    const btnInsertar = document.getElementById("btnInsertar");
    btnInsertar.addEventListener("click", async () => {
        const lblAviso = document.querySelector(".lblAviso");
        lblAviso.hidden = true;
        mandarDocumento(datosJsonObj);
    });

    let datosJsonObj;

    comboDocumento.addEventListener("change", async function() {
        const ID_DOCUMENTO = comboDocumento.value;
        const idDocente = idDocentes();
        const datosJsonResponse = await traerDatosJson(ID_DOCUMENTO, idDocente);
        const lblAviso = document.querySelector(".lblAviso");
        lblAviso.hidden = true;
        let datosJson = datosJsonResponse.datos_json;
        try {
            datosJsonObj = (typeof datosJson === "string") ? JSON.parse(datosJson) : datosJson;
            console.log(datosJsonObj);
            agregarVariables(datosJsonObj);
        } catch (err) {
            console.error("Error parseando datos_json:", err);
            return;
        }
    });


    function idDocentes(){
        let combo = document.getElementById("comboDocentes");
        let textoVisible = combo.options[combo.selectedIndex];
        console.log( textoVisible.value);
        return textoVisible.value;
    }
    function idDocumentos(){
        let combo = document.getElementById("comboDocumento");
        let textoVisible = combo.options[combo.selectedIndex];
        console.log( textoVisible.value);
        return textoVisible.value;
    }
    function mandarDocumento(datosJson){
      const lblAviso = document.querySelector(".lblAviso");
        for (const key in datosJson) {
            if (datosJson.hasOwnProperty(key)) {
                const value = datosJson[key];
                console.log(`Clave: ${key}, Valor: ${value}`);
                const input = document.getElementById(key);
                if (input) {

                    datosJson[key] = input.value;
                } else {
                    console.warn(`No se encontró el input para la clave: ${key}`);
                }
            }
        }
        const idDocente = idDocentes();
        const idDocumento = idDocumentos();
        actualizarDatos(idDocente, idDocumento, datosJson);
    }
}


function agregarVariables(datosJsonObj) {
    const formDatos = document.getElementById("formDatosJson");
    // Limpiar contenido previo
    formDatos.innerHTML = "";
    for (const key in datosJsonObj) {
      if (datosJsonObj.hasOwnProperty(key)) {
          const div = document.createElement("div");
          div.className = "divDatosJson";
            const value = datosJsonObj[key];
            console.log(`Clave: ${key}, Valor: ${value}`);

            // Crear label
            const label = document.createElement("label");
            label.setAttribute("for", key);
            label.textContent = key + ":";

            // Crear input
            const input = document.createElement("input");
            input.type = "text";
            input.className = "inputDatosJson";
            input.id = key;
            input.value = value;
            div.appendChild(label);
            div.appendChild(input);
            formDatos.appendChild(div);


            // Salto de línea
            formDatos.appendChild(document.createElement("br"));
        }
    }
}



async function traerDocentes(){
      try{
    const response = await fetch("http://localhost:5000/traerIdDoce", {
      method: "GET",
      headers: { "Content-Type": "application/json" }
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

async function traerDocumentos(idDocente){
    try{
    const response = await fetch("http://localhost:5000/traerDocumentos", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ idDocente: idDocente })
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

async function traerDatosJson(ID_DOCUMENTO,id_docente){
        try{
    const response = await fetch("http://localhost:5000/traerDocumento", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ idDocumento: ID_DOCUMENTO, idDocente: id_docente })
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
    console.error("Error en traerDatosJson:", error);
    return null;
  }
}

async function actualizarDatos(id_empleado,id_documento, datos_json){
    try{
    const response = await fetch("http://localhost:5000/actualizarDocumentos", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ idEmpleado: id_empleado, idDocumento: id_documento, datosJson    : datos_json })
    });
    const data = await response.json();

    if (data.estatus) {
        console.log("Datos de cuenta:", data);
        const lblAviso = document.querySelector(".lblAviso");
        lblAviso.hidden = false;
        lblAviso.textContent = "Documento insertado correctamente";
        lblAviso.style.color = "#16a34a"; // Color verde para éxito
      return;
    } else {
      console.log("Error:", data.error);
      return null;
    }
  } catch (error) {
    console.error("Error en actualizarDatos:", error);
    return null;
  } 
}