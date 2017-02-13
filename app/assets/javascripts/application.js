import stars from './stars';
import upload from './upload';
import timeago from './timeago';
import header from './header';

function load() {
  stars();
  upload();
  timeago();
  header();
}

if (document.readyState !== 'loading') load();
else document.addEventListener('DOMContentLoaded', load);
