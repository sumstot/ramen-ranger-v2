import { Controller } from '@hotwired/stimulus'
import Sortable from 'sortablejs'

export default class extends Controller {
  static targets = ['previewImage', 'positionInput']

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
     const previews = Array.from(
       this.element.querySelectorAll('[data-dropzone-preview]')
     )

     previews.forEach((preview, newPosition) => {
       // Find the matching position input using targets
       const positionInput =
         this.positionInputTargets[parseInt(preview.dataset.imageIndex)]
       if (positionInput) {
         positionInput.value = newPosition
       }
     })
  }
}
