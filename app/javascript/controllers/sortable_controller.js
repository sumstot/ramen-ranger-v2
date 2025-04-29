import { Controller } from '@hotwired/stimulus'
import Sortable from 'sortablejs'

export default class extends Controller {
  static targets = ['container', 'item', 'position']

  containerTargetConnected() {
    this.initializeSortable()
  }

  initializeSortable() {
    this.sortable = Sortable.create(this.containerTarget, {
      animation: 150,
      draggable: '[data-sortable-target="item"]',
      ghostClass: 'sortable-ghost',
      chosenClass: 'sortable-chosen',
      dragClass: 'sortable-drag',
      onEnd: this.updateOrder.bind(this),
    })
  }

  updateOrder() {
    this.itemTargets.forEach((item, index) => {
      const positionInput = item.querySelector(
        '[data-sortable-target="position"]'
      )
      if (positionInput) {
        positionInput.value = index + 1
      }
    })

    this.dispatch('orderUpdated', { detail: { items: this.itemTargets } })
  }
}
