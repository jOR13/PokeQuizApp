import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["timer"]

  connect() {
    this.timeLeft = 5;
    this.updateTimer();
    this.startTimer();
  }

  startTimer() {
    this.interval = setInterval(() => {
      if (this.timeLeft <= 0) {
        clearInterval(this.interval);
        this.submitForm();
      } else {
        this.timeLeft -= 1;
        this.updateTimer();
      }
    }, 1000);
  }

  updateTimer() {
    this.timerTarget.textContent = `${this.timeLeft} seconds remaining`;
  }

  submitForm() {
    this.element.querySelector("form").requestSubmit();
  }
}

