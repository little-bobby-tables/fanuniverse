export default function() {
  const upload = document.querySelector('.js-upload-image');

  if (upload) {
    const fileInput = upload.querySelector('.file-upload__input');

    const reader = new FileReader();

    fileInput.addEventListener('change', () => {
      fileInput.files[0] && reader.readAsDataURL(fileInput.files[0]);
    });

    reader.addEventListener('load', (e) => {
      showImage(e.target.result);
      proceedToSecondStep();
    });
  }
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
