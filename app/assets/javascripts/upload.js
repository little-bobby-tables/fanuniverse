export default function() {
  const form = document.querySelector('.js-upload');

  if (form) {
    imageUpload(form);
    tagHelpers(form);
  }
}

function imageUpload(form) {
  const fileInput = form.querySelector('.file-upload__input');

  const reader = new FileReader();

  fileInput.addEventListener('change', () => {
    fileInput.files[0] && reader.readAsDataURL(fileInput.files[0]);
  });

  reader.addEventListener('load', (e) => {
    showImage(e.target.result);
    proceedToSecondStep();
  });
}

function showImage(data) {
  const image = document.querySelector('.js-upload-image-preview');
  image.classList.remove('hidden');
  image.src = data;
}

function proceedToSecondStep() {
  document.querySelector('.js-upload-image').classList.add('hidden');
  document.querySelector('.js-upload-second-step').classList.remove('hidden');
}

function tagHelpers(form) {
  form.addEventListener('click', (e) => {
    const tagLink  = e.target && e.target.closest('[data-tag]'),
          tag      = tagLink && tagLink.getAttribute('data-tag');

    if (tag) {
      const tagInput = document.getElementById('image_tags');

      if (tagInput.value === '') tagInput.value = `${tag}, `;
      else tagInput.value += `, ${tag}, `;

      tagInput.focus();
    }
  });
}
