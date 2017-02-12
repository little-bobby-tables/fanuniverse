import { data } from './utils/datastore';
import { post } from './utils/requests'

export default function() {
  const stars = data('stars');

  if (stars) {
    stars.forEach(resource => show(resource));

    document.addEventListener('click', (e) => {
      const star = e.target && e.target.closest('.star');

      if (star) {
        const resourceId = star.getAttribute('data-resource-id');
        toggleStar(resourceId);
      }
    });
  }
}

function toggleStar(resourceId) {
  post('/api/stars/toggle', { resource_id: resourceId })
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
