document.addEventListener('DOMContentLoaded', () => {
  const input = document.getElementById('password');
  const btn = document.querySelector('.toggle-password');
  if (btn && input) {
    btn.addEventListener('click', () => {
      const visible = input.type === 'text';
      input.type = visible ? 'password' : 'text';
      btn.setAttribute('aria-pressed', String(!visible));
      btn.setAttribute('aria-label', visible ? 'Mostrar contraseña' : 'Ocultar contraseña');
    });
  }
});