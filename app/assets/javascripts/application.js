import stars from './stars';
import upload from './upload';

function load() {
  stars();
  upload();
}

if (document.readyState !== 'loading') load();
else document.addEventListener('DOMContentLoaded', load);
