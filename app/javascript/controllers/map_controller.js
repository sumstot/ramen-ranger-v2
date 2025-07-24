import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['form', 'field', 'map']
  static values = {
    markers: Array,
  }

  connect() {
    this.markerInstances = []
    this.markerClusterer = null
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
    if (this.markerClusterer) {
      this.markerClusterer.clearMarkers()
    }
    window.removeEventListener('initMap', this.initializeMap.bind(this))
  }

  initializeMap() {
    if (!this.hasMapTarget) return

    const mapOptions = {
      center: { lat: 34.672314, lng: 135.484802 },
      zoom: 10,
      mapId: '5aa4719e81f42be2',
      styles: [
        {
          featureType: 'poi',
          elementType: 'labels',
          stylers: [{ visibility: 'off' }],
        },
      ],
    }
    this.map = new google.maps.Map(this.mapTarget, mapOptions)
    this.addMarkersToMap()
  }

  createAlternativeMarker(marker) {
    const markerElement = document.createElement('div')
    markerElement.className = 'modern-marker'
    markerElement.innerHTML = `
      <div class="modern-marker-container" style="
        position: relative;
        display: flex;
        flex-direction: column;
        align-items: center;
        cursor: pointer;
        transition: transform 0.2s ease;
      ">
        <div class="modern-marker-badge" style="
          background: ${marker.color};
          color: white;
          padding: 6px 10px;
          border-radius: 16px;
          font-size: 13px;
          font-weight: 600;
          box-shadow: 0 3px 10px rgba(0,0,0,0.25);
          display: flex;
          align-items: center;
          gap: 4px;
          border: 2px solid white;
          position: relative;
          z-index: 2;
          white-space: nowrap;
        ">
          <span>🍜</span>
          <span>${parseFloat(marker.average_score || 0).toFixed(1)}</span>
        </div>
        <div class="modern-marker-arrow" style="
          width: 0;
          height: 0;
          border-left: 6px solid transparent;
          border-right: 6px solid transparent;
          border-top: 10px solid ${marker.color};
          margin-top: -2px;
          filter: drop-shadow(0 2px 4px rgba(0,0,0,0.2));
        "></div>
      </div>
    `

    markerElement.addEventListener('mouseenter', () => {
      markerElement.querySelector('.modern-marker-container').style.transform =
        'scale(1.05) translateY(-2px)'
    })

    markerElement.addEventListener('mouseleave', () => {
      markerElement.querySelector('.modern-marker-container').style.transform =
        'scale(1) translateY(0)'
    })

    return markerElement
  }

  addMarkersToMap() {
    this.clearMarkers()
    this.markerInstances = []

    this.markersValue.forEach((marker) => {
      const infowindow = new google.maps.InfoWindow({
        content: marker.infowindow,
        ariaLabel: 'restaurant',
        pixelOffset: new google.maps.Size(0, -10),
      })

      const markerElement = this.createAlternativeMarker(marker)

      const markerInstance = new google.maps.marker.AdvancedMarkerElement({
        map: this.map,
        position: { lat: parseFloat(marker.lat), lng: parseFloat(marker.lng) },
        content: markerElement,
        title: marker.name,
      })

      markerInstance.addListener('click', () => {
        if (this.currentInfoWindow) {
          this.currentInfoWindow.close()
        }

        this.currentInfoWindow = infowindow
        infowindow.open({
          anchor: markerInstance,
          map: this.map,
        })
      })

      this.markerInstances.push(markerInstance)
    })

    this.initializeMarkerClusterer()
  }

  updateMarkers(newMarkers) {
    this.markersValue = newMarkers
    this.addMarkersToMap()
  }

  clearMarkers() {
    if (this.markerClusterer) {
      this.markerClusterer.clearMarkers()
    }

    this.markerInstances.forEach((marker) => {
      marker.map = null
    })
    this.markerInstances = []

    if (this.currentInfoWindow) {
      this.currentInfoWindow.close()
    }
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
