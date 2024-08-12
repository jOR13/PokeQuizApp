import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["audio"]

  connect() {
    this.audio = this.audioTarget
    this.isPlaying = sessionStorage.getItem("isPlaying") === "true"

    document.addEventListener('click', () => {
      if (this.isPlaying && !this.audio.paused) {
        this.audio.play().catch(error => {
          console.warn("Reproducción de audio evitada por el navegador:", error);
        });
      }
    });

    this.updateIcon()
  }

  playAudio() {
    this.audio.play().catch(error => {
      console.warn("Reproducción de audio evitada por el navegador:", error);
    });
    this.isPlaying = true
    sessionStorage.setItem("isPlaying", "true")
    this.updateIcon()
  }

  toggle() {
    if (this.isPlaying) {
      this.audio.pause()
      sessionStorage.setItem("isPlaying", "false")
    } else {
      this.audio.play().catch(error => {
        console.warn("Reproducción de audio evitada por el navegador:", error);
      });
      sessionStorage.setItem("isPlaying", "true")
    }
    this.isPlaying = !this.isPlaying
    this.updateIcon()
  }

  updateIcon() {
    const musicIcon = document.getElementById("music-icon")
    
    if (this.isPlaying) {
      musicIcon.classList.remove("fa-volume-mute")
      musicIcon.classList.add("fa-volume-up")
    } else {
      musicIcon.classList.remove("fa-volume-up")
      musicIcon.classList.add("fa-volume-mute")
    }
  }
}
