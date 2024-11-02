window.initMap = function() {
  const event = new CustomEvent('initMap')
  window.dispatchEvent(event)
}
