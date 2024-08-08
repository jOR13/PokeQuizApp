import { Controller } from "@hotwired/stimulus"
export default class extends Controller {
  static targets = ["timer"]

  connect() {
    this.level = sessionStorage.getItem('quizLevel') || 'sencillo'
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
    
    this.timerTarget.textContent = `Tiempo restante: ${timeLeft} segundos`

    this.interval = setInterval(() => {
      timeLeft -= 1
      this.timerTarget.textContent = `Tiempo restante: ${timeLeft} segundos`

      if (timeLeft <= 0) {
        clearInterval(this.interval)
        this.submitForm()
      }
    }, 1000)
  }

  submitForm() {
    this.element.querySelector("form").requestSubmit();
  }

  disconnect() {
    clearInterval(this.interval)
  }
}

