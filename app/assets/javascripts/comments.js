import { timeago } from './timeago';

export default function() {
  const commentable = document.querySelector('[data-commentable]');

  commentable && loadCommentable(commentable);
}

const endpont = (type, id) => `/comments?commentable_type=${type}&commentable_id=${id}`;

function loadCommentable(element) {
  const { commentable, commentableId } = element.dataset;

  fetch(endpont(commentable, commentableId), { credentials: 'same-origin' })
      .then(response => response.text())
      .then(comments => {
        element.innerHTML = comments;
        timeago(element);
      });
}
