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
    const inputsByIndex = new Map()

    this.hiddenInputTargets.forEach(input => {
      const index = input.dataset.positionIndex
      if (!inputsByIndex.has(index)) {
        inputsByIndex.set(index, [])
      }
      inputsByIndex.get(index).push(input)
    })

    this.previewImageTargets.forEach((previewImage, newIndex) => {
      const currentIndex = previewImage.dataset.positionIndex
      const relatedInputs = inputsByIndex.get(currentIndex) || []

      relatedInputs.forEach(input => {
        input.name = input.name.replace(/\[\d+\]/, `[${newIndex}]`)

        if (input.name.includes('[position]')) {
          input.value = newIndex
        }

        input.dataset.positionIndex = newIndex
      })

      previewImage.dataset.positionIndex = newIndex
    })
  }
}
