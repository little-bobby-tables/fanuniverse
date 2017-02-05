import stars from './stars';

function load() {
  stars();
}

if (document.readyState !== 'loading') load();
else document.addEventListener('DOMContentLoaded', load);
