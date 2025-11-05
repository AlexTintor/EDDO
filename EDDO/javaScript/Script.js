// Cambiar entre secciones
const menuItems = document.querySelectorAll('.sidebar li, .bottom button');
const sections = document.querySelectorAll('.section');

menuItems.forEach(item => {
  item.addEventListener('click', () => {
    const sectionId = item.getAttribute('data-section');
    if (!sectionId) return;

    // Quitar 'active' del menú
    menuItems.forEach(btn => btn.classList.remove('active'));
    item.classList.add('active');

    // Mostrar sección seleccionada
    sections.forEach(sec => {
      sec.classList.remove('visible');
      if (sec.id === sectionId) sec.classList.add('visible');
    });
  });
});
