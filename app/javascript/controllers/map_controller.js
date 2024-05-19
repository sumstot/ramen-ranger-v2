// app/javascript/controllers/map_controller.js
import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['map']

  connect() {
    window.addEventListener('initMap', this.initializeMap.bind(this))
    if (typeof google !== 'undefined' && typeof google.maps !== 'undefined') {
      this.initializeMap()
    }
  }

  disconnect() {
    window.removeEventListener('initMap', this.initializeMap.bind(this))
  }

  initializeMap() {
    if (!this.hasMapTarget) return

    const mapOptions = {
      center: { lat: 34.672314, lng: 135.484802 },
      zoom: 10
    }

    new google.maps.Map(this.mapTarget, mapOptions)
  }
}
