import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['searchForm', 'searchResults', 'selectedRestaurantContainer', 'restaurantId', 'restaurantName']

  connect() {
  }

  selectRestaurant(e) {
    this.restaurantIdTarget.value = e.currentTarget.dataset.restaurantId
    this.selectedRestaurantContainerTarget.innerHTML = e.currentTarget.innerHTML
    const restaurantOption =
      this.selectedRestaurantContainerTarget.querySelector(
        '.restaurant-search-result__info'
      )
    if (restaurantOption) {
      restaurantOption.classList.add('is-selected')
    }
    this.clearSearch()
  }

  clearSearch() {
    const searchInput = this.searchFormTarget.querySelector('input')
    if (searchInput) searchInput.value = ''
    this.searchResultsTarget.innerHTML = ''
    window.history.replaceState({}, '', window.location.pathname)
  }
}
