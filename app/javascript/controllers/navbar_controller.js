import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static targets = ['navlinks']

  toggleDropdown() {
    this.navlinksTarget.classList.toggle('is-active')
  }

  closeDropdown(e) {
    if (!this.element.contains(e.target) && this.navlinksTarget.classList.contains('is-active')) {
      this.navlinksTarget.classList.remove('is-active')
    }
  }
}
