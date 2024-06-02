import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static targets = ['navlinks']

  toggleDropdown() {
    this.navlinksTarget.classList.toggle('is-hidden')
  }

  closeDropdown(e) {
    if (!this.element.contains(e.target) && !this.navlinksTarget.classList.contains('is-hidden')) {
      this.navlinksTarget.classList.add('is-hidden');
    }
  }
}
