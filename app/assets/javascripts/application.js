import stars from './stars';
import upload from './upload';
import timeago from './timeago';
import header from './header';
import comments from './comments';

import masonry from './masonry';

function load() {
  stars();
  upload();
  timeago();
  header();
  comments();

  masonry();
}

if (document.readyState !== 'loading') load();
else document.addEventListener('DOMContentLoaded', load);
