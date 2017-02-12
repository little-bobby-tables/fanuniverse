export default function() {
  const userMenuToggle = document.querySelector('.js-header-user-toggle');

  userMenuToggle.addEventListener('click', (e) => {
    e.preventDefault();
    e.stopPropagation();

    toggleMenu();

    if (userMenuToggle.classList.contains('active')) {
      document.addEventListener('click', hideMenuOnClick);
    }
  });
}

function toggleMenu() {
  document.querySelector('.js-header-user').classList.toggle('hidden');
  document.querySelector('.js-header-user-toggle').classList.toggle('active');
}

function hideMenuOnClick(e) {
  if (!e.target.closest('.js-header-user')) {
    document.removeEventListener('click', hideMenuOnClick);
    toggleMenu();
  }
}
