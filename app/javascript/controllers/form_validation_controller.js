import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["name", "error"]

  connect() {
    this.form = this.element
    this.nameField = this.nameTarget
    this.errorField = this.errorTarget
  }

  validate(event) {
    if (this.nameField.value.trim() === "") {
      event.preventDefault()
      this.showError("The user name is required.")
    } else {
      this.clearError()
    }
  }

  showError(message) {
    this.errorField.textContent = message
    this.errorField.classList.remove("hidden")

    setTimeout(() => {
      this.clearError()
    }, 3000)
  }

  clearError() {
    this.errorField.textContent = ""
    this.errorField.classList.add("hidden")
  }
}
