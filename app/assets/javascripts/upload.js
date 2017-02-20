export default function() {
  const form = document.querySelector('.js-upload');
  form && fileUpload(form) && tagHelpers(form);
}

function fileUpload(form) {
  const reader = new FileReader();

  form.querySelector('.js-upload__fetch').addEventListener('click', scrapeUrl);

  form.querySelector('.file-upload__input').addEventListener('change', (e) => {
    e.target.files[0] && reader.readAsDataURL(e.target.files[0])
  });

  reader.addEventListener('load', (e) => { showImage(e.target.result); proceedToSecondStep() });

  return true;
}

function tagHelpers(form) {
  form.addEventListener('click', (e) => {
    const tagLink = e.target && e.target.closest('[data-tag]');

    tagLink && appendTag(tagLink.dataset.tag);
  });
}

function scrapeUrl() {
  const url = document.querySelector('.js-upload__url').value;

  if (url) {
    document.querySelector('.js-upload__fetch').setAttribute('disabled', '');

    fetch(`/api/image_scraping/scrape?url=${url}`, { credentials: 'same-origin' })
        .then(response => response.json())
        .then(data => { insertScraped(data); proceedToSecondStep() });
  }
}

function showImage(src) {
  const image = document.querySelector('.js-upload__preview');
  image.classList.remove('hidden');
  image.src = src;
}

function insertScraped(data) {
  data.image_url     && (document.getElementById('image_remote_image_url').value = data.image_url);
  data.url           && (document.getElementById('image_source').value = data.url);
  data.artist        && appendTag(`artist:${data.artist.toLowerCase()}`);
  data.thumbnail_url && showImage(data.thumbnail_url);
}

function proceedToSecondStep() {
  document.querySelector('.js-upload__file').classList.add('hidden');
  document.querySelector('.js-upload__meta').classList.remove('hidden');
}

function appendTag(tag) {
  const tagInput = document.getElementById('image_tags');

  if (!tagInput.value || tagInput.value.endsWith(', ')) tagInput.value += `${tag}, `;
  else tagInput.value += `, ${tag}, `;

  tagInput.focus();
}
