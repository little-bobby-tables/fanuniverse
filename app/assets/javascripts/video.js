export default function() {
  const containers = [].slice.call(document.querySelectorAll('.js-video')),
        videos =     [].slice.call(document.querySelectorAll('.js-video video'));

  containers.forEach((c) => c.addEventListener('click', playVideo));

  videos.forEach((v) => v.addEventListener('play', hideControls));
}

function playVideo(e) {
  e.preventDefault();

  const container = e.target.closest('.js-video'),
        state     = container.querySelector('.js-video__state'),
        video     = container.querySelector('video');

  container.classList.remove('interactable');

  container.removeEventListener('click', playVideo);

  state.textContent = 'loading';

  video.play();
}

function hideControls(e) {
  const container = e.target.closest('.js-video'),
        controls  = container.querySelector('.js-video__controls');

  controls.classList.add('fade-out');
}
