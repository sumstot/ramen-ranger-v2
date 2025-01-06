import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log('sortable controller connected')
  }
  static targets = ['previewImage']

  previewImageTargetConnected() {
    console.log(this.previewImageTargets)
  }
}
