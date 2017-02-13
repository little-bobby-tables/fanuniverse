import stars from './stars';
import upload from './upload';
import timeago from './timeago';
import header from './header';
import comments from './comments';

function load() {
  stars();
  upload();
  timeago();
  header();
  comments();
}

if (document.readyState !== 'loading') load();
else document.addEventListener('DOMContentLoaded', load);
