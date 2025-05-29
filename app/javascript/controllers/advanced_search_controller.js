import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['panel', 'toggleButton', 'soupCheckbox']

  connect() {
    console.log('controller connected')
  }

  toggleAdvancedSearch() {
    this.panelTarget.classList.toggle('show');
    this.toggleButtonTarget.classList.toggle('active');
  }

  clearFilters(event) {
    event.preventDefault();
    this.soupCheckboxTargets.forEach(cb => cb.checked = false);
    if (this.panelTarget) {
      const form = this.element.querySelector('form');
      if (form) form.requestSubmit();
    }
  }
}
