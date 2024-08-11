import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["level", "submitBtn", "loader", "name", "error"]

  connect() {
    this.updateSelectedButton(this.levelTarget.value)
  }

  showLoader() {
    this.submitBtnTarget.classList.add("hidden")
    this.loaderTarget.classList.remove("hidden")
  }

  validateAndSubmit(event) {
    // Validar el campo de nombre
    if (this.nameTarget.value.trim() === "") {
      event.preventDefault()
      this.showError("The user name is required.")
    } else {
      this.clearError()
      this.showLoader()
      this.submitForm(event)
    }
  }

  submitForm(event) {
    const level = this.levelTarget.value
    sessionStorage.setItem('quizLevel', level)
  }

  selectLevel(event) {
    const level = event.currentTarget.dataset.level
    this.levelTarget.value = level
    this.updateSelectedButton(level)
    sessionStorage.setItem('quizLevel', level)
  }

  updateSelectedButton(selectedLevel) {
    this.element.querySelectorAll('button[data-action="click->quiz-level#selectLevel"]').forEach(button => {
      button.classList.remove('bg-yellow-700', 'text-white')
      button.classList.add('bg-pokemonYellow', 'hover:bg-yellow-700')

      if (button.dataset.level === selectedLevel) {
        button.classList.add('bg-yellow-700', 'text-white')
        button.classList.remove('hover:bg-yellow-700')
      }
    })
  }

  showError(message) {
    this.errorTarget.textContent = message
    this.errorTarget.classList.remove("hidden")

    setTimeout(() => {
      this.clearError()
    }, 3000)
  }

  clearError() {
    this.errorTarget.textContent = ""
    this.errorTarget.classList.add("hidden")
  }
}
