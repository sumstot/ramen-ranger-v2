import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log('form controller connected')
  }
  static targets = ['restaurantId', 'restaurantName']

  selectRestaurant(e) {
    console.log(this.restaurantIdTarget)
    // console.log(this.restaurantNameTarget)
    console.log(
      (this.restaurantIdTarget.value = e.currentTarget.dataset.restaurantId)
    )
    this.restaurantIdTarget.value = e.currentTarget.dataset.restaurantId
    // this.restaurantNameTarget.value = e.currentTarget.dataset.restaurantNameTarget
  }
}
