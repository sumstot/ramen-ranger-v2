// app/javascript/controllers/upload_controller.js
import { Controller } from '@hotwired/stimulus'
import { DirectUpload } from '@rails/activestorage'

export default class extends Controller {
  static targets = ['input', 'container', 'preview', 'template']

  connect() {
    console.log('Upload controller connected')
  }

  handleFiles(event) {
    Array.from(event.target.files).forEach((file) => {
      this.uploadFile(file)
    })

    event.target.value = null
  }

  uploadFile(file) {
    const preview = this.createPreview(file)
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
        hiddenField.name =
          'ramen_review[review_images_attributes][][blob_signed_id]'
        hiddenField.value = blob.signed_id
        preview.appendChild(hiddenField)

        const positionField = document.createElement('input')
        positionField.type = 'hidden'
        positionField.name =
          'ramen_review[review_images_attributes][][position]'
        positionField.value = this.previewTargets.indexOf(preview)
        positionField.dataset.sortableTarget = 'position'
        preview.appendChild(positionField)
        preview.classList.add('upload-complete')
        this.dispatch('imageAdded', { detail: { preview } })
      }
    })
  }

  createPreview(file) {
    const template = this.templateTarget.content.cloneNode(true)
    const preview = template.querySelector('.preview')

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
    const preview = event.target.closest('.preview')
    const idField = preview.querySelector('input[name*="[id]"]')
    if (idField) {
      const destroyField = document.createElement('input')
      destroyField.type = 'hidden'
      destroyField.name = idField.name.replace('[id]', '[_destroy]')
      destroyField.value = '1'
      this.element.appendChild(destroyField)
    }

    preview.remove()

    this.dispatch('imageRemoved')
  }
}
