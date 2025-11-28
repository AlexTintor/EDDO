document.addEventListener("DOMContentLoaded", () => {
    cargarComboDocentes();
});

async function cargarComboDocentes() {
    const data = await traerDocentes();

    if (!data) return;

    const combo = document.getElementById("comboDocentes");
    
    // Si tu backend devuelve un array como data.docentes
    data.docentes.forEach(doc => {
        const option = document.createElement("option");
        option.value = doc.ID_EMPLEADO;   // value que usarás para backend
        option.textContent = doc.NOMBRE; // lo que ve el usuario
        combo.appendChild(option);
    });
    
    const comboDocumento = document.getElementById("comboDocumento");
    const documento = await traerDocumentos();
    if (!documento) return;
    console.log(documento);
    documento.documentos.forEach(doc => {
        const option = document.createElement("option");
        option.value = doc.ID_DOCUMENTO;   // value que usarás para backend
        option.textContent = doc.NOMBRE; // lo que ve el usuario
        comboDocumento.appendChild(option);
    });
    

    const btnInsertar = document.getElementById("btnInsertar");
    btnInsertar.addEventListener("click", async () => {
    });
    comboDocumento.addEventListener("change", async function() {
        const ID_DOCUMENTO = comboDocumento.value;
        const datosJsonResponse = await traerDatosJson(ID_DOCUMENTO);
        
        let datosJson = datosJsonResponse.datos_json;
        let datosJsonObj;
        try {
            datosJsonObj = (typeof datosJson === "string") ? JSON.parse(datosJson) : datosJson;
            console.log("Datos JSON (objeto):", datosJsonObj);
            agregarVariables(datosJsonObj);
        } catch (err) {
            console.error("Error parseando datos_json:", err);
            return;
        }
    });

}
function agregarVariables(datosJsonObj) {
    const formDatos = document.getElementById("formDatosJson");

    // Limpiar contenido previo
    formDatos.innerHTML = "";

    for (const key in datosJsonObj) {
        if (datosJsonObj.hasOwnProperty(key)) {
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
            input.name = key;

            // Agregar label e input al formulario
            formDatos.appendChild(label);
            formDatos.appendChild(input);

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

async function traerDocumentos(){
    try{
    const response = await fetch("http://localhost:5000/traerDocumentos", {
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

async function traerDatosJson(ID_DOCUMENTO){
        try{
    const response = await fetch("http://localhost:5000/traerDocumento", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ idDocumento: ID_DOCUMENTO })
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