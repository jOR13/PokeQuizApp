import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["audio"]

  connect() {
    this.audio = this.audioTarget
    this.isPlaying = sessionStorage.getItem("isPlaying") === "true"

    if (this.isPlaying) {
      this.audio.play()
    }

    this.updateIcon()
  }

  playAudio() {
    this.audio.play()
    this.isPlaying = true
    sessionStorage.setItem("isPlaying", "true")
    this.updateIcon()
  }

  toggle() {
    if (this.isPlaying) {
      this.audio.pause()
      sessionStorage.setItem("isPlaying", "false")
    } else {
      this.audio.play()
      sessionStorage.setItem("isPlaying", "true")
    }
    this.isPlaying = !this.isPlaying
    this.updateIcon()
  }

  updateIcon() {
    const musicToggleButton = document.getElementById("music-toggle")
    if (this.isPlaying) {
      musicToggleButton.textContent = "Music Off"
    } else {
      musicToggleButton.textContent = "Music On"
    }
  }
}
