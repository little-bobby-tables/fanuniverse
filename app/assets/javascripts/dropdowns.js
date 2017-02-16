export default function() {
  document.addEventListener('click', (e) => {
    const toggle = e.target && e.target.closest('.js-dropdown__toggle');

    if (toggle) {
      e.preventDefault();
      e.stopPropagation();

      const container = toggle.parentNode,
            content   = container.querySelector('.js-dropdown__content');

      content.classList.toggle('hidden');
      toggle.classList.toggle('active');

      if (toggle.classList.contains('active')) document.addEventListener('click', hideMenuOnClick);
      else document.removeEventListener('click', hideMenuOnClick);
    }
  });
}

function hideMenuOnClick(e) {
  if (!e.target.closest('.js-dropdown__content')) {
    document.removeEventListener('click', hideMenuOnClick);

    document.querySelector('.js-dropdown__content:not(.hidden)').classList.add('hidden');
    document.querySelector('.js-dropdown__toggle.active').classList.remove('active');
  }
}
