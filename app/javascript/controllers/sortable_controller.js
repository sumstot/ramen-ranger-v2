import { Controller } from '@hotwired/stimulus'
import Sortable from 'sortablejs'

export default class extends Controller {
  static targets = ['previewImage', 'hiddenInput']

  connect() {
    this.initSortable()
  }

  initSortable() {
    this.sortable = new Sortable(this.element, {
      animation: 150,
      onEnd: (event) => this.updatePositions(event),
    })
  }

  updatePositions(event) {
    this.previewImageTargets.forEach((previewImage, index) => {
      const hiddenInput = this.hiddenInputTargets.find(input => input.dataset.positionIndex === previewImage.dataset.positionIndex)

      hiddenInput.dataset.positionIndex = index
      previewImage.dataset.positionIndex = index
    })
  }
}
