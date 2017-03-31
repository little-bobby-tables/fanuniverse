export default function() {
  const mediaLinks = [].slice.call(document.querySelectorAll('.js-media-link'));

  (mediaLinks.length > 0) &&
    mediaLinks.forEach((l) => l.addEventListener('click', toggleMedia));
}

function toggleMedia(e) {
  e.preventDefault();

  const link     = e.target.closest('.js-media-link'),
        state    = link.querySelector('.js-media-state'),
        video    = link.querySelector('video'),
        controls = link.querySelector('.js-media-controls');

  link.removeEventListener('click', toggleMedia);

  state.textContent = 'loading';

  video.addEventListener('canplay', () => controls.classList.add('hidden'));

  video.play();
}
