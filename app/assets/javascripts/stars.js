import { post } from './utils/requests';
import { signedIn } from './utils/users';

export default function() {
  loadStarrable(document);

  document.addEventListener('click', (e) => {
    const star = e.target && e.target.closest('[data-starrable]');

    star && signedIn(e) && toggleStar(star);
  });
}

export function loadStarrable(container) {
  const datasets = container.querySelectorAll('[data-starrable-ids]');

  [].slice.call(datasets).forEach((dataset) => {
    const starrable = dataset.getAttribute('data-starrable-type'),
          ids = JSON.parse(dataset.getAttribute('data-starrable-ids'));

    ids.forEach((starrableId) => show(starElement(starrable, starrableId)));
  });
}

function toggleStar(star) {
  const { starrable, starrableId } = star.dataset;

  post('/api/stars/toggle', { starrable_type: starrable, starrable_id: starrableId })
      .then((data) => {
        const star = starElement(starrable, starrableId);

        if (data['status'] === 'added') show(star);
        else remove(star);

        setStarCount(star, data['stars']);
      });
}

function starElement(type, id) {
  return document.querySelector(`[data-starrable="${type}"][data-starrable-id="${id}"]`);
}

function show(star) {
  star.classList.add('active'); 
}

function remove(star) {
  star.classList.remove('active'); 
}

function setStarCount(star, count) {
  star.querySelector('.meta__count').textContent = count; 
}
