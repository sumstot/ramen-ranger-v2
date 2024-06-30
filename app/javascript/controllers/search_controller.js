import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="search"
export default class extends Controller {
  static targets = ['searchForm', 'clearSearchButton']

  clearSearchButtonTargetConnected() {
    console.log(this.clearSearchButtonTarget)
  }

  clearSearch(e) {
    console.log(e)
    console.log('clear search')
    this.formTarget.querySelectorAll("input[type='text'], select").forEach((input) => (input.value = ''))

    this.searchFormTarget.requestSubmit()
  }
}
