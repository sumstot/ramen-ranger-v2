import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="navbar"
export default class extends Controller {
  static targets = ['dropdown']
  connect() {
    console.log(this.dropdownTarget)
  }
}
