import stars from './stars';
import upload from './upload';
import timeago from './timeago';
import comments from './comments';

import dataevents from './dataevents';
import dropdowns from './dropdowns';
import masonry from './masonry';

function load() {
  stars();
  upload();
  timeago();
  comments();

  dataevents();
  dropdowns();
  masonry();
}

if (document.readyState !== 'loading') load();
else document.addEventListener('DOMContentLoaded', load);
