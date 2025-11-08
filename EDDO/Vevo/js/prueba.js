document.addEventListener('DOMContentLoaded', () => {
  const input = document.getElementById('password');
  const btn = document.getElementById('btnVerContrasea');

  if (btn && input) {
    btn.addEventListener('click', () => {
      const visible = input.type === 'text';
      input.type = visible ? 'password' : 'text';
    });
  }
});