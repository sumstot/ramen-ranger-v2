import { Controller } from '@hotwired/stimulus'
import { MarkerClusterer } from '@googlemaps/markerclusterer'
export default class extends Controller {
  static targets = ['form', 'field', 'map']

  static values = {
    markers: Array,
  }

 connect() {
    this.markerInstances = []
    console.log('Element dataset:', this.element.dataset)
    if (typeof google !== 'undefined' && typeof google.maps !== 'undefined') {
      this.initializeMap()
    } else {
      window.addEventListener('initMap', this.initializeMap.bind(this))

      setTimeout(() => {
        if (!this.map) {
          console.warn('Map not initialized, retrying...')
          this.initializeMap()
        }
      }, 2000)
    }
  }

  disconnect() {
    window.removeEventListener('initMap', this.initializeMap.bind(this))
  }

  initializeMap() {
    if (!this.hasMapTarget) return

    const mapOptions = {
      center: { lat: 34.672314, lng: 135.484802 },
      zoom: 10,
      mapId: '5aa4719e81f42be2',
    }
    this.map = new google.maps.Map(this.mapTarget, mapOptions)
    this.addMarkersToMap()
  }

  addMarkersToMap() {
    this.markerInstances = []
    const parser = new DOMParser()
    this.markersValue.forEach((marker) => {
      const glyphSvgString = '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" style="fill: rgba(255, 255, 255, 1);transform: scaleX(-1);msFilter:progid:DXImageTransform.Microsoft.BasicImage(rotation=0, mirror=1);"><path d="M21 10H3a1 1 0 0 0-1 1 10 10 0 0 0 5 8.66V21a1 1 0 0 0 1 1h8a1 1 0 0 0 1-1v-1.34A10 10 0 0 0 22 11a1 1 0 0 0-1-1zm-5.45 8.16a1 1 0 0 0-.55.9V20H9v-.94a1 1 0 0 0-.55-.9A8 8 0 0 1 4.06 12h15.88a8 8 0 0 1-4.39 6.16zM9 9V7.93a4.53 4.53 0 0 0-1.28-3.15A2.49 2.49 0 0 1 7 3V2H5v1a4.53 4.53 0 0 0 1.28 3.17A2.49 2.49 0 0 1 7 7.93V9zm4 0V7.93a4.53 4.53 0 0 0-1.28-3.15A2.49 2.49 0 0 1 11 3V2H9v1a4.53 4.53 0 0 0 1.28 3.15A2.49 2.49 0 0 1 11 7.93V9zm4 0V7.93a4.53 4.53 0 0 0-1.28-3.15A2.49 2.49 0 0 1 15 3V2h-2v1a4.53 4.53 0 0 0 1.28 3.15A2.49 2.49 0 0 1 15 7.93V9z"></path></svg>'
      const glyphSvg = parser.parseFromString(
      glyphSvgString,
      'image/svg+xml',
      ).documentElement
      const pinBackground = new google.maps.marker.PinElement({
        background: marker.color,
        borderColor: marker.color,
        glyphColor: '#fff',
        glyph: glyphSvg
      })

      const infowindow = new google.maps.InfoWindow({
        content: marker.infowindow,
        ariaLabel: 'restaurant',
      })

      const markerInstance = new google.maps.marker.AdvancedMarkerElement({
        map: this.map,
        position: { lat: parseFloat(marker.lat), lng: parseFloat(marker.lng) },
        content: pinBackground.element,
      })

      markerInstance.addListener('click', () => {
        infowindow.open({
          anchor: markerInstance,
          map: this.map,
        })
      })

      this.markerInstances.push(markerInstance)
    })
  }

  updateMarkers(newMarkers) {
    this.clearMarkers()
    this.markersValue = newMarkers
    this.addMarkersToMap()
  }

  clearMarkers() {
    this.markerInstances.forEach(marker => {
      marker.map = null
    })
    this.markerInstances = []
  }

  search() {
    if (this.timeout) {
      clearTimeout(this.timeout)
    }

    this.timeout = setTimeout(() => {
      this.performSearch()
    }, 300)
  }

  async performSearch() {
    const formData = new FormData(this.formTarget)
    const params = new URLSearchParams(formData)

    const response = await fetch(`${this.formTarget.action}?${params}`, {
      headers: {
        Accept: 'application/json',
        'X-Requested-With': 'XMLHttpRequest',
      },
    })

    if (response.ok) {
      const data = await response.json()
      console.log(data.markers)
      this.updateMarkers(data.markers)
    }
  }
}
