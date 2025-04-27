import { Controller } from '@hotwired/stimulus'
import Sortable from 'sortablejs'

export default class extends Controller {
  static targets = ['container', 'item', 'position']

  connect() {
    console.log('Sortable controller connected')
    this.initializeSortable()
  }

  initializeSortable() {
    if (!this.hasContainerTarget) {
      console.warn('No container target found for Sortable')
      return
    }

    console.log('Initializing sortable on', this.containerTarget)
    console.log(`Found ${this.itemTargets.length} sortable items`)

    this.sortable = Sortable.create(this.containerTarget, {
      animation: 150,
      draggable: '[data-sortable-target="item"]',
      ghostClass: 'sortable-ghost',
      chosenClass: 'sortable-chosen',
      dragClass: 'sortable-drag',
      onEnd: this.updateOrder.bind(this),
    })
  }

  updateOrder(event) {
    console.log('Updating order after sort')
    this.itemTargets.forEach((item, index) => {
      const positionInput = item.querySelector(
        '[data-sortable-target="position"]'
      )
      if (positionInput) {
        console.log(`Setting position for item ${index} to ${index}`)
        positionInput.value = index + 1
      }
    })

    // Ensure this event is triggered
    this.dispatch('orderUpdated', { detail: { items: this.itemTargets } })
  }
}
