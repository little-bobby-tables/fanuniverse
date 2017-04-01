export default function() {
  const containers = [].slice.call(document.querySelectorAll('.js-video')),
        autoplayed = [].slice.call(document.querySelectorAll('.js-video__autoplayed'));

  containers.forEach((m) => m.addEventListener('click', toggleMedia));

  autoplayed.forEach((v) => v.addEventListener('play', hideControls));
}

function toggleMedia(e) {
  e.preventDefault();

  const container = e.target.closest('.js-video'),
        state     = container.querySelector('.js-video__state'),
        video     = container.querySelector('video');

  container.classList.remove('interactable');

  container.removeEventListener('click', toggleMedia);

  state.textContent = 'loading';

  video.addEventListener('play', hideControls);

  video.play();
}

function hideControls(e) {
  const container = e.target.closest('.js-video'),
        controls  = container.querySelector('.js-video__controls');

  controls.classList.add('fade-out');
}
