document.addEventListener('DOMContentLoaded', () => {
  const form = document.getElementById('recover-form');
  const email = document.getElementById('recover-email');
  const errorMsg = document.getElementById('email-error');

  const isValidEmail = v => /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(v);

  email.addEventListener('blur', () => {
    const v = email.value.trim();
    if (v && !isValidEmail(v)) {
      showError();
    } else {
      hideError();
    }
  });

  form.addEventListener('submit', e => {
    e.preventDefault();
    const v = email.value.trim();
    if (!isValidEmail(v)) {
      showError();
      email.focus();
      return;
    }
    hideError();
    const code = generateCode(6);
    sessionStorage.setItem('eddo_recover_email', v);
    sessionStorage.setItem('eddo_recover_code', code);
    window.location.href = './verificar.html';
  });

  function showError(){
    errorMsg.hidden = false;
    email.setAttribute('aria-invalid','true');
  }
  function hideError(){
    errorMsg.hidden = true;
    email.removeAttribute('aria-invalid');
  }
  function generateCode(n){
    return Array.from({length:n},()=>Math.floor(Math.random()*10)).join('');
  }
});