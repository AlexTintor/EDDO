export function validadarContra(password01, password02){
  const lblError = document.getElementById("lblError");
  const password1 = document.getElementById(password01).value;
  const password2 = document.getElementById(password02).value;
  if(password1 === "" || password2 === ""){
    lblError.hidden = false;
    lblError.textContent = "Ambos campos son obligatorios.";
    return false; 
  }
  if(password1 != password2){
    lblError.hidden = false;
    lblError.textContent = "Ingresa la misma contraseña"
    return false;
  }
  if(password1 === password2){
    lblError.hidden = true;
    return true;
  }
  return false;
}