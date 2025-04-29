window.initMap = function initMap() {
  const event = new CustomEvent('initMap')
  window.dispatchEvent(event)
}
