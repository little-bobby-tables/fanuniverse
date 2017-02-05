import { data } from './utils/datastore';
import { post } from './utils/requests'

export default function() {
  const interactions = data('stars');

  if (interactions) {
    interactions.forEach(id => show(id));

    document.addEventListener('click', (e) => {
      const resourceId = e.target && e.target.closest('.star').getAttribute('data-resource-id');
      resourceId && toggleStar(resourceId);
    });
  }
}

function toggleStar(resourceId) {
  post('api/rating_stars/toggle', { resource_id: resourceId })
      .then(data => {
        if (data['status'] === 'added') show(resourceId);
        else remove(resourceId);

        setStarCount(resourceId, data['stars']);
      });
}

function show(id) {
  document.querySelector(`.star[data-resource-id="${id}"]`).classList.add('star--active');
}

function remove(id) {
  document.querySelector(`.star[data-resource-id="${id}"]`).classList.remove('star--active');
}

function setStarCount(id, count) {
  document.querySelector(`.star[data-resource-id="${id}"] .star__count`).textContent = count;
}
