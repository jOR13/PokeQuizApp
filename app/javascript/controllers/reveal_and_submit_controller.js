import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["image", "form"]

  revealAndSubmit() {
    this.imageTarget.classList.remove("hide-pokemon")
    
    setTimeout(() => {
      this.formTarget.submit()
    }, 700)
  }
}
