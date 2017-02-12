import stars from './stars';
import upload from './upload';
import header from './header';

function load() {
  stars();
  upload();
  header();
}

if (document.readyState !== 'loading') load();
else document.addEventListener('DOMContentLoaded', load);
