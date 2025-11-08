document.addEventListener('DOMContentLoaded', () => {
  const emailSpan = document.getElementById('code-email-value');
  const storedEmail = sessionStorage.getItem('eddo_recover_email');
  let storedCode = sessionStorage.getItem('eddo_recover_code');
  if(!storedEmail || !storedCode){ window.location.replace('./recuperar.html'); return; }
  emailSpan.textContent = storedEmail;

  const cells = [...document.querySelectorAll('.code-cell')];
  const btnVerify = document.getElementById('btn-verify');
  const btnResend = document.getElementById('btn-resend');
  const codeError = document.getElementById('code-error');
  if (cells[0]) cells[0].focus();

  cells.forEach((cell,i)=>{
    cell.addEventListener('input', e=>{
      // No limpiar si entra símbolo accidental: solo recorta a 1
      e.target.value = e.target.value.slice(0,1);
      // Si no es dígito, déjalo visible pero no se contará (decisión UX); si prefieres borrarlo: if(!/\d/.test(e.target.value)) e.target.value='';
      if(e.target.value && i < cells.length-1) cells[i+1].focus();
      updateState();
    });
    cell.addEventListener('keydown', e=>{
      if(e.key === 'Backspace' && !cell.value && i>0) cells[i-1].focus();
      if(e.key === 'ArrowLeft' && i>0){ e.preventDefault(); cells[i-1].focus(); }
      if(e.key === 'ArrowRight' && i<cells.length-1){ e.preventDefault(); cells[i+1].focus(); }
    });
    cell.addEventListener('paste', e=>{
      const t=(e.clipboardData.getData('text')||'').replace(/\s/g,'').slice(0,6);
      if(!t) return;
      e.preventDefault();
      cells.forEach((c,idx)=>c.value=t[idx]||'');
      updateState();
    });
  });

  document.getElementById('code-form').addEventListener('submit', e=>{
    e.preventDefault();
    const entered = cells.map(c=>c.value).join('');
    // Validar solo dígitos
    if(!/^\d{6}$/.test(entered) || entered !== storedCode){
      codeError.hidden = false;
      codeError.textContent = 'Código inválido.';
      cells[0].focus();
      return;
    }
    codeError.hidden = true;
    alert('Código verificado.');
  });

  btnResend.addEventListener('click', ()=>{
    if(btnResend.disabled) return;
    storedCode = generateCode(6);
    sessionStorage.setItem('eddo_recover_code', storedCode);
    cells.forEach(c=>c.value='');
    cells[0].focus();
    btnVerify.disabled = true;
    countdown = 30;
    startTimer();
  });

  let countdown = 30, timer = null;
  startTimer();

  function updateState(){
    const entered = cells.map(c=>c.value).join('');
    const ok = /^\d{6}$/.test(entered);
    btnVerify.disabled = !ok;
    if(ok) codeError.hidden = true;
  }
  function startTimer(){
    btnResend.disabled = true;
    btnResend.textContent = `Reenviar código (${countdown}s)`;
    clearInterval(timer);
    timer = setInterval(()=>{
      countdown--;
      if(countdown<=0){
        clearInterval(timer);
        btnResend.disabled=false;
        btnResend.textContent='Reenviar código';
      } else {
        btnResend.textContent=`Reenviar código (${countdown}s)`;
      }
    },1000);
  }
  function generateCode(n){
    return Array.from({length:n},()=>Math.floor(Math.random()*10)).join('');
  }
});