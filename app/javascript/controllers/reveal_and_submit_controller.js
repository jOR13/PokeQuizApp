import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["image", "form", "submitButton"]

  revealAndSubmit() {
    this.imageTarget.classList.remove("hide-pokemon")
    
    setTimeout(() => {
      this.submitButtonTarget.click();
    }, 700)
  }
}
