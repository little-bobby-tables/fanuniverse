import { timeago } from './timeago';

export default function() {
  const commentable = document.querySelector('[data-commentable]');

  if (commentable) {
    loadCommentable(commentable);
    setupAjaxPosting(commentable);
  }
}

const endpoint = (type, id) => `/comments?commentable_type=${type}&commentable_id=${id}`;

function loadCommentable(container) {
  const { commentable, commentableId } = container.dataset;

  fetch(endpoint(commentable, commentableId), { credentials: 'same-origin' })
      .then(response => response.text())
      .then(comments => displayComments(container, comments));
}

function displayComments(container, comments) {
  container.innerHTML = comments;
  timeago(container);
}

function setupAjaxPosting(container) {
  /* Form submission is handled by rails.js, we only need to display the new comments. */
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
    displayComments(container, responseBody);
  }
  else {
    /* Error message will be displayed on reload at the top of the page (flash). */
    window.location.reload();
    window.scrollTo(0, 0);
  }
}
