import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="menu"
export default class extends Controller {
  static targets = ["menu"];

  connect() {
    console.log("Hello from menu_controller.js");
    console.log("Menu Target: ", this.menuTarget);
  }

  toggle() {
    console.log("Toggle called");
    console.log("Menu Target before toggle: ", this.menuTarget.classList);
    this.menuTarget.classList.toggle("hidden");
    console.log("Menu Target after toggle: ", this.menuTarget.classList);
  }
}
