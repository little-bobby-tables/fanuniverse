import stars from './stars';
import upload from './upload';
import timeago from './timeago';
import comments from './comments';

import dataevents from './dataevents';
import dropdowns from './dropdowns';
import masonry from './masonry';

import ga from './googleanalytics';

function load() {
  stars();
  upload();
  timeago();
  comments();

  dataevents();
  dropdowns();
  masonry();

  ga();
}

if (document.readyState !== 'loading') load();
else document.addEventListener('DOMContentLoaded', load);
