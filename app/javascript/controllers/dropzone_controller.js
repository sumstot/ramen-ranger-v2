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
  static targets = ['input', 'previewImage', 'message', 'existingImages']

  connect() {
    this.dropZone = createDropZone(this)
    this.hideFileInput()
    this.bindEvents()
    // if (this.hasExisitingImagesTarget) {
    this.addExistingFiles()
    // }
  }

  // Private
  hideFileInput() {
    this.inputTarget.disabled = true
    this.inputTarget.style.display = 'none'
  }

  addExistingFiles() {
    const existingImages = JSON.parse(this.existingImagesTarget.value)
    existingImages.forEach((imageData, index) => {
      const mockFile = {
        accepted: true,
        status: Dropzone.SUCCESS,
      }

      this.dropZone.emit('addedfile', mockFile)
      this.dropZone.emit('thumbnail', mockFile, imageData.url)
      this.dropZone.emit('complete', mockFile)
      this.dropZone.emit('success', mockFile)
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
      console.log('inside removedfile')
      file.controller && removeElement(file.controller.hiddenInput)
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

    insertAfter(this.imageInput, this.source.inputTarget)
  }

  removeHiddenInputs() {
    removeElement(this.imageInput)
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
