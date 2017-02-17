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
  toggle(element, targetSelector) { document.querySelector(targetSelector).classList.toggle('hidden'); },
  /* show and hide allow a single link to toggle multiple elements. */
  show(element, targetSelector) { document.querySelector(targetSelector).classList.remove('hidden'); },
  hide(element, targetSelector) { document.querySelector(targetSelector).classList.add('hidden'); }
};
