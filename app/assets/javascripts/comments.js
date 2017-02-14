import { timeago } from './timeago';

export default function() {
  const commentable = document.querySelector('[data-commentable-url]');

  if (commentable) {
    load(commentable, commentable.getAttribute('data-commentable-url'));
    pagination(commentable);
    ajaxPosting(commentable);
  }
}

function load(container, endpoint) {
  fetch(endpoint, { credentials: 'same-origin' })
      .then(response => response.text())
      .then(comments => display(container, comments));
}

function display(container, comments) {
  container.innerHTML = comments;
  timeago(container);
}

function pagination(container) {
  container.addEventListener('click', (e) => {
    if (e.target && e.target.closest('.page')) {
      e.preventDefault();
      load(container, e.target.getAttribute('href'));
    }
  });
}

function ajaxPosting(container) {
  /* Form submission is handled by rails-ujs, we just need to display the comments we get as a response. */
  document.addEventListener('ajax:success', (e) => {
    if (e.target.id === 'js-commentable-form') commentPosted(container, e.detail);
  });
}

function commentPosted(container, response) {
  const commentEditArea = document.querySelector('#js-commentable-form textarea'),
        ajaxRequestOk   = response[2].status === 200,
        responseBody    = response[2].responseText;

  commentEditArea.value = '';

  if (ajaxRequestOk) {
    display(container, responseBody);
  }
  else {
    /* Error message will be displayed on reload at the top of the page (flash). */
    window.location.reload();
    window.scrollTo(0, 0);
  }
}
