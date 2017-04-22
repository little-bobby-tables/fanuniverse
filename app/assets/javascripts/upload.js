export default function() {
  const form = document.querySelector('.js-upload');
  form && (restore(form) || setup(form));
}

function restore(form) {
  const previousSubmission = form.querySelector('.js-model-errors');

  return previousSubmission && proceedToNextStep();
}

function setup(form) {
  const reader = new FileReader();

  form.querySelector('.js-upload__fetch').addEventListener('click', scrapeUrl);

  form.querySelector('.file-upload__input').addEventListener('change', (e) =>
    e.target.files[0] && reader.readAsDataURL(e.target.files[0]));

  reader.addEventListener('load', (e) =>
    showImage(e.target.result) && proceedToNextStep());

  return true;
}

function scrapeUrl(e) {
  const url = document.querySelector('.js-upload__url').value;

  if (url) {
    toggleFetchButton();

    fetch(`https://scraper.fanuniverse.org/?url=${url}`)
        .then((response) => {
          if (!response.ok) throw Error();
          return response;
        })
        .then((response) => response.json())
        .then((data) => insertScraped(data) && proceedToNextStep())
        .catch(() => {
          toggleFetchButton();
          document.querySelector('.js-upload__fetch-error').classList.remove('hidden');
        });
  }
  else e.stopPropagation();
}

function toggleFetchButton() {
  const button = document.querySelector('.js-upload__fetch'),
        oldState = button.textContent;
  button.textContent = button.getAttribute('data-toggle-text');
  button.setAttribute('data-toggle-text', oldState);
}

function showImage(src) {
  const image = document.querySelector('.js-upload__preview');
  image.classList.remove('hidden');
  image.src = src;

  return true;
}

function insertScraped(data) {
  data.imageUrl && (document.getElementById('image_remote_image_url').value = data.imageUrl);
  data.pageUrl  && (document.getElementById('image_source').value = data.pageUrl);
  data.artist   && (document.getElementById('image_tags').value = `artist:${data.artist.toLowerCase()}, `);

  data.thumbnailUrl && showImage(data.thumbnailUrl);

  return true;
}

function proceedToNextStep() {
  document.querySelector('.js-upload__file').classList.add('hidden');
  document.querySelector('.js-upload__meta').classList.remove('hidden');
  document.querySelector('#image_tags').focus();

  return true;
}
