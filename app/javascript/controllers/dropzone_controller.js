import { Controller } from '@hotwired/stimulus'
import { DirectUpload } from '@rails/activestorage'
import Dropzone from 'dropzone'
import {
  getMetaValue,
  findElement,
  removeElement,
  insertAfter,
} from '../helpers/dropzone'
Dropzone.autoDiscover = false
export default class extends Controller {
  static values = { existingImages: Array }
  static targets = ['input', 'previewImage', 'message']

  connect() {
    this.dropZone = createDropZone(this)
    this.hideFileInput()
    this.bindEvents()
    this.addExistingFiles()
  }

  // Private
  hideFileInput() {
    this.inputTarget.disabled = true
    this.inputTarget.style.display = 'none'
  }

  addExistingFiles() {
    if (!this.existingImagesValue) return

    this.existingImagesValue.forEach((imageData, index) => {
      fetch(imageData.url)
        .then((response) => response.blob())
        .then((blob) => {
          const file = new File(
            [blob],
            imageData.filename || `image-${index}.jpg`,
            { type: blob.type }
          )
          file.status = Dropzone.SUCCESS
          file.isExisting = true
          file.imageId = imageData.id
          this.dropZone.addFile(file)

          // Create hidden inputs for existing images
          const idInput = document.createElement('input')
          idInput.type = 'hidden'
          idInput.setAttribute('data-sortable-target', 'hiddenInput')
          idInput.name = `ramen_review[review_images_attributes][${index}][id]`
          idInput.value = imageData.id
          idInput.dataset.positionIndex = index
          file.previewElement.dataset.positionIndex = index
          insertAfter(idInput, this.inputTarget)

          const positionInput = document.createElement('input')
          positionInput.type = 'hidden'
          positionInput.setAttribute('data-sortable-target', 'hiddenInput')
          positionInput.name = `ramen_review[review_images_attributes][${index}][position]`
          positionInput.value = index
          positionInput.dataset.positionIndex = index
          insertAfter(positionInput, idInput)

          file.hiddenInputs = [idInput, positionInput]

          file.status = Dropzone.SUCCESS
          this.dropZone.emit('complete', file)
          this.dropZone.emit('success', file)
        })
    })
  }

  bindEvents() {
    this.dropZone.on('addedfile', (file) => {
      file.previewElement.setAttribute('data-sortable-target', 'previewImage')
      setTimeout(() => {
        file.accepted && createDirectUploadController(this, file).start()
      }, 500)
    })

    this.dropZone.on('removedfile', (file) => {
      if (file.isExisting && file.imageId) {
        const destroyInput = document.createElement('input')
        destroyInput.type = 'hidden'
        destroyInput.name = `ramen_review[review_images_attributes][${file.previewElement.dataset.positionIndex}][_destroy]`
        destroyInput.value = '1'
        insertAfter(destroyInput, this.inputTarget)

        if (file.hiddenInputs) {
          if (file.hiddenInputs.length > 1) {
            removeElement(file.hiddenInputs[1])
          }
        }
      } else {
        if (file.hiddenInputs) {
          file.hiddenInputs.forEach((input) => removeElement(input))
        }
      }
    })

    this.dropZone.on('canceled', (file) => {
      file.controller && file.controller.xhr.abort()
    })

    this.dropZone.on('processing', (file) => {
      this.submitButton.disabled = true
    })

    this.dropZone.on('queuecomplete', (file) => {
      this.submitButton.disabled = false
    })

    this.dropZone.on('success', (file, response) => {
      if (response && response.turbo_stream) {
        Turbo.renderStreamMessage(response.turbo_stream)
      }
    })
  }

  messageTargetConnected() {
    if (this.previewImageTargets.length > 0) {
      this.messageTarget.style.display = 'none'
    }
  }

  get headers() {
    return { 'X-CSRF-Token': getMetaValue('csrf-token') }
  }

  get url() {
    return this.inputTarget.getAttribute('data-direct-upload-url')
  }

  get maxFiles() {
    return this.data.get('maxFiles') || 1
  }

  get maxFileSize() {
    return this.data.get('maxFileSize') || 256
  }

  get acceptedFiles() {
    return this.data.get('acceptedFiles')
  }

  get addRemoveLinks() {
    return this.data.get('addRemoveLinks') || true
  }

  get form() {
    return this.element.closest('form')
  }

  get submitButton() {
    return findElement(this.form, 'input[type=submit], button[type=submit]')
  }
}
class DirectUploadController {
  constructor(source, file) {
    this.directUpload = createDirectUpload(file, source.url, this)
    this.source = source
    this.file = file
    this.index = this.source.dropZone.files.indexOf(file)
  }

  start() {
    this.file.controller = this
    this.createHiddenInputs()

    this.directUpload.create((error, attributes) => {
      if (error) {
        this.removeHiddenInputs()
        this.emitDropzoneError(error)
      } else {
        this.imageInput.value = attributes.signed_id
        this.emitDropzoneSuccess()
      }
    })
  }

  // Private
  createHiddenInputs() {
    this.imageInput = document.createElement('input')
    this.imageInput.setAttribute('data-sortable-target', 'hiddenInput')
    this.imageInput.type = 'hidden'
    this.imageInput.name = `ramen_review[review_images_attributes][${this.index}][image]`
    this.imageInput.dataset.positionIndex = this.index
    this.file.previewElement.dataset.positionIndex = this.index

    this.positionInput = document.createElement('input')
    this.positionInput.type = 'hidden'
    this.positionInput.setAttribute('data-sortable-target', 'hiddenInput')
    this.positionInput.name = `ramen_review[review_images_attributes][${this.index}][position]`
    this.positionInput.value = this.index
    this.positionInput.dataset.positionIndex = this.index

    insertAfter(this.imageInput, this.source.inputTarget)
    insertAfter(this.positionInput, this.imageInput)

    this.file.hiddenInputs = [this.imageInput, this.positionInput]
    // this.file.controller = this // Store controller reference
  }

  removeHiddenInputs() {
    removeElement(this.imageInput)
    removeElement(this.positionInput)
  }

  directUploadWillStoreFileWithXHR(xhr) {
    this.bindProgressEvent(xhr)
    this.emitDropzoneUploading()
  }

  bindProgressEvent(xhr) {
    this.xhr = xhr
    this.xhr.upload.addEventListener('progress', (event) =>
      this.uploadRequestDidProgress(event)
    )
  }

  uploadRequestDidProgress(event) {
    const progress = (event.loaded / event.total) * 100
    findElement(
      this.file.previewTemplate,
      '.dz-upload'
    ).style.width = `${progress}%`
  }

  emitDropzoneUploading() {
    this.file.status = Dropzone.UPLOADING
    this.source.dropZone.emit('processing', this.file)
  }

  emitDropzoneError(error) {
    this.file.status = Dropzone.ERROR
    this.source.dropZone.emit('error', this.file, error)
    this.source.dropZone.emit('complete', this.file)
  }

  emitDropzoneSuccess() {
    this.file.status = Dropzone.SUCCESS
    this.source.dropZone.emit('success', this.file)
    this.source.dropZone.emit('complete', this.file)
  }
}

// Top level...
function createDirectUploadController(source, file) {
  return new DirectUploadController(source, file)
}

function createDirectUpload(file, url, controller) {
  return new DirectUpload(file, url, controller)
}

function createDropZone(controller) {
  return new Dropzone(controller.element, {
    url: controller.url,
    headers: controller.headers,
    maxFiles: controller.maxFiles,
    maxFilesize: controller.maxFileSize,
    acceptedFiles: controller.acceptedFiles,
    addRemoveLinks: controller.addRemoveLinks,
    autoQueue: false,
    resizeWidth: 416,
    resizeHeight: 520,
    thumbnailWidth: 120,
    thumbnailHeight: 150,
    thumbnailMethod: 'contain',
    resizeQuality: 1,
  })
}
