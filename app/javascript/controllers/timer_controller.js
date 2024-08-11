import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["timer", "image"]

  connect() {
    this.level = sessionStorage.getItem('quizLevel') || 'easy'
    this.startTimer()
  }

  startTimer() {
    let timeLeft
    switch (this.level) {
      case 'hard':
        timeLeft = 10
        break
      case 'medium':
        timeLeft = 20
        break
      case 'easy':
      default:
        timeLeft = 30
        break
    }
    
    this.timerTarget.textContent = timeLeft

    this.interval = setInterval(() => {
      timeLeft -= 1
      this.timerTarget.textContent = timeLeft

      if (timeLeft <= 0) {
        clearInterval(this.interval)
        this.revealAndSubmit()
      }
    }, 1000)
  }

  revealAndSubmit() {
    this.imageTarget.classList.remove("hide-pokemon")

    setTimeout(() => {
      this.element.querySelector("form").requestSubmit()
    }, 700)
  }

  disconnect() {
    clearInterval(this.interval)
  }
}
