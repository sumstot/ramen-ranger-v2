import { Controller } from '@hotwired/stimulus'
import Swiper from 'swiper/bundle'

export default class extends Controller {
  static targets = [ 'swiper', 'pagination']

  connect() {
    this.swiperTargets.forEach((swiperElement, index) => {
      new Swiper (swiperElement, {
        pagination: {
          el: this.paginationTarget,
          clickable: true,
        }
      })
    })
  }
}
