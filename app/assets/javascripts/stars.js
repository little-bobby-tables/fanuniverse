import { post } from './utils/requests'

export default function() {
  showStars(document);

  document.addEventListener('click', (e) => {
    const star = e.target && e.target.closest('[data-starrable]');

    star && toggleStar(star);
  });
}

export function showStars(container) {
  const datasets = container.querySelectorAll('[data-starrable-dataset]');

  [].slice.call(datasets).forEach(dataset => {
    const interactions = JSON.parse(dataset.getAttribute('data-starrable-dataset'));

    Object.keys(interactions).forEach(starrable => {
      interactions[starrable].forEach(starrableId => show(starElement(starrable, starrableId)));
    });
  })
}

function toggleStar(star) {
  const { starrable, starrableId } = star.dataset;

  post('/api/stars/toggle', { starrable_type: starrable, starrable_id: starrableId })
      .then(data => {
        const star = starElement(starrable, starrableId);

        if (data['status'] === 'added') show(star);
        else remove(star);

        setStarCount(star, data['stars']);
      });
}

function starElement(type, id) {
  return document.querySelector(`[data-starrable="${type}"][data-starrable-id="${id}"]`);
}

function show(star) { star.classList.add('star--active'); }

function remove(star) { star.classList.remove('star--active'); }

function setStarCount(star, count) { star.querySelector('.star__count').textContent = count; }
