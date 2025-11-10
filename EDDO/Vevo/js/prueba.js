document.addEventListener('DOMContentLoaded', () => {
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
                window.location.href = "index.html";
                localStorage.setItem("idDocente", data.id_docente);
                alert("IdDocente: " + data.id_docente);
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
});