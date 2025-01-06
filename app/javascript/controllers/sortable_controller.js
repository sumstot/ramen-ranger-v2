import { Controller } from '@hotwired/stimulus'
import Sortable from 'sortablejs'

export default class extends Controller {
  static targets = ['previewImage']

  connect() {
    this.initSortable()
  }

  initSortable() {
    this.sortable = new Sortable(this.element, {
      animation: 150,
      onEnd: (event) => this.updatePositions(event),
    })
  }

  updatePositions() {
    this.previewImageTargets.forEach((previewImage, index) => {
      const positionInput = previewImage.querySelector(
        'input[name*="[position]"]'
      )
      if (positionInput) {
        positionInput.value = index
      }
    })
  }
}
