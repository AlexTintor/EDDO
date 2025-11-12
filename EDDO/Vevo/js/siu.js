document.addEventListener("DOMContentLoaded", () => {
    mandarMsj();
});
function mandarMsj() {
  const btnEnviarMsj = document.getElementById('btnEnviarMsj');
  const inputMsj = document.getElementById('inputMensaje');
    const ventanaMensajes = document.getElementById('ventanaMensajes');

  btnEnviarMsj.addEventListener('click', () => {
    const msj = inputMsj.value.trim(); // obtenemos el texto actual

    if (msj === "") return; // evita mensajes vacíos

    const tr = document.createElement("div");
    tr.innerHTML = `
        <div class="divMsj uno">
            <div class="msj uno">
                <p>${msj}</p>
            </div>
        </div>
    `;

    ventanaMensajes.appendChild(tr);
    inputMsj.value = ""; // limpia el input
  });
    inputMsj.addEventListener("keypress", (e) => {
    if (e.key === "Enter") {
        e.preventDefault();
        btnEnviarMsj.click();
    }
    });
}
