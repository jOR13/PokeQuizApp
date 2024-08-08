import { Controller } from "@hotwired/stimulus"


export default class extends Controller {
  static targets = ["level"]

  connect() {
    this.updateSelectedButton(this.levelTarget.value)
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
      button.classList.add('bg-yellow-500', 'hover:bg-yellow-700')

      if (button.dataset.level === selectedLevel) {
        button.classList.add('bg-yellow-700', 'text-white')
        button.classList.remove('hover:bg-yellow-700')
      }
    })
  }

  submitForm(event) {
    const level = this.levelTarget.value
    sessionStorage.setItem('quizLevel', level)
  }
}
