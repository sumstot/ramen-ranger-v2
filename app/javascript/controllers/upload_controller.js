// app/javascript/controllers/upload_controller.js
import { Controller } from '@hotwired/stimulus'
import { DirectUpload } from '@rails/activestorage'

export default class extends Controller {
  static targets = ['input', 'container', 'preview', 'template']

  connect() {
    console.log('Upload controller connected')
    // Start new indices after existing images
    this.newImageIndex = this.previewTargets.length
  }

  handleFiles(event) {
    Array.from(event.target.files).forEach((file) => {
      this.uploadFile(file)
    })

    event.target.value = null
  }

  uploadFile(file) {
    const currentIndex = this.newImageIndex++
    const preview = this.createPreview(file, currentIndex)

    const upload = new DirectUpload(
      file,
      this.inputTarget.dataset.directUploadUrl,
      {
        directUploadWillStoreFileWithXHR: (xhr) => {
          this.bindProgressToPreview(xhr, preview)
        },
      }
    )

    upload.create((error, blob) => {
      if (error) {
        preview.classList.add('upload-error')
        console.error(error)
      } else {
        const hiddenField = document.createElement('input')
        hiddenField.type = 'hidden'
        hiddenField.name = `ramen_review[review_images_attributes][${currentIndex}][blob_signed_id]`
        hiddenField.value = blob.signed_id
        preview.appendChild(hiddenField)

        const positionField = document.createElement('input')
        positionField.type = 'hidden'
        positionField.name = `ramen_review[review_images_attributes][${currentIndex}][position]`
        positionField.value = this.previewTargets.indexOf(preview)
        positionField.dataset.sortableTarget = 'position'
        preview.appendChild(positionField)

        preview.classList.add('upload-complete')
        this.dispatch('imageAdded', { detail: { preview } })
      }
    })
  }

  createPreview(file, index) {
    const template = this.templateTarget.content.cloneNode(true)
    const preview = template.querySelector('.preview')

    // Set data attribute for the index
    preview.dataset.index = index

    const image = preview.querySelector('img')
    image.src = URL.createObjectURL(file)

    this.containerTarget
      .querySelector('.preview-container')
      .appendChild(preview)

    return preview
  }

  bindProgressToPreview(xhr, preview) {
    const progressBar = preview.querySelector('.progress-bar')

    xhr.upload.addEventListener('progress', (event) => {
      if (event.lengthComputable) {
        const progress = Math.round((event.loaded / event.total) * 100)
        progressBar.style.width = `${progress}%`
      }
    })
  }

  removeImage(event) {
    event.preventDefault();
    const preview = event.target.closest('.preview');

    // Find destroy field if this is an existing image
    const destroyField = preview.querySelector('[data-upload-target="destroyField"]');

    if (destroyField) {
      // This is an existing image, mark it for destruction
      destroyField.value = "1";

      // Hide the preview but don't remove it
      preview.style.display = 'none';
    } else {
      // This is a new upload, just remove it
      preview.remove();
    }

    this.dispatch('imageRemoved');
  }
}
