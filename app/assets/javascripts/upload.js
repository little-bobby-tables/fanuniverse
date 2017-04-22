export default function() {
  const form = document.querySelector('.js-upload');
  form && setup(form);
}

function setup(form) {
  const reader = new FileReader();

  form.querySelector('.js-upload__fetch').addEventListener('click', scrapeUrl);

  form.querySelector('.file-upload__input').addEventListener('change', (e) => {
    e.target.files[0] && reader.readAsDataURL(e.target.files[0]);
  });

  reader.addEventListener('load', (e) => {
    showImage(e.target.result); proceedToSecondStep(); 
  });

  return true;
}

function scrapeUrl(e) {
  const url = document.querySelector('.js-upload__url').value;

  if (url) {
    document.querySelector('.js-upload__fetch').setAttribute('disabled', '');

    fetch(`https://scraper.fanuniverse.org/?url=${url}`)
        .then((response) => response.json())
        .then((data) => {
          insertScraped(data); proceedToSecondStep(); 
        });
  }
  else e.stopPropagation();
}

function showImage(src) {
  const image = document.querySelector('.js-upload__preview');
  image.classList.remove('hidden');
  image.src = src;
}

function insertScraped(data) {
  data.imageUrl     && (document.getElementById('image_remote_image_url').value =
                         data.imageUrl);
  data.pageUrl      && (document.getElementById('image_source').value =
                         data.pageUrl);
  data.artist       && (document.getElementById('image_tags').value =
                         `artist:${data.artist.toLowerCase()}, `);
  data.thumbnailUrl && showImage(data.thumbnailUrl);
}

function proceedToSecondStep() {
  document.querySelector('.js-upload__file').classList.add('hidden');
  document.querySelector('.js-upload__meta').classList.remove('hidden');

  document.querySelector('#image_tags').focus();
}
