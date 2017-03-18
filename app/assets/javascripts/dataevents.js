export default function() {
  document.addEventListener('click', (e) => {
    Object.keys(actions).forEach((action) => {
      const target = e.target && e.target.closest(`[data-click-${action}]`),
            data   = target && target.getAttribute(`data-click-${action}`);

      target && actions[action](target, data);
    });
  });
}

const actions = {
  toggle(element, targetSelector) {
    const toggleClass = element.getAttribute('data-toggle-class') || 'hidden';

    document.querySelector(targetSelector).classList.toggle(toggleClass);
  },

  show(element, targetSelector) {
    document.querySelector(targetSelector).classList.remove('hidden');
  },

  hide(element, targetSelector) {
    document.querySelector(targetSelector).classList.add('hidden');
  }
};
