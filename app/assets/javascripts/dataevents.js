export default function() {
  document.addEventListener('click', (e) => {
    Object.keys(actions).forEach((action) => {
      const target = e.target && e.target.closest(`[data-click-${action}]`),
            data   = target && target.getAttribute(`data-click-${action}`);

      /* preventDefault unless the action returns true */
      target && (actions[action](target, data) ||
                 e.preventDefault());
    });
  });
}

const actions = {
  toggle(element, data) {
    const set = data.startsWith('{') && JSON.parse(data);

    if (set) {
      Object.entries(set).forEach(([selector, cls]) => {
        document.querySelector(selector).classList.toggle(cls);
      });
    }
    else {
      document.querySelector(data).classList.toggle('.hidden');
    }
  },

  show(element, data) {
    document.querySelector(data).classList.remove('hidden');
  },

  hide(element, data) {
    document.querySelector(data).classList.add('hidden');
  }
};
