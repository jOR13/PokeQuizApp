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
    const soundIcon = document.getElementById("sound-icon")
    if (this.isPlaying) {
      soundIcon.innerHTML = `
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19V6l-6 6h4v7h2zm10 0a7.993 7.993 0 0 0 2-5.5 7.993 7.993 0 0 0-2-5.5M19 10l-2 2m0 0l-2 2m2-2l2-2m-2 2l-2 2" />
      `
    } else {
      soundIcon.innerHTML = `
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 10h4v4h-4z" />
      `
    }
  }
}
