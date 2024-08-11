import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["menu"];

  toggle(event) {
    event.stopPropagation();
    
    const currentLocale = this.getCookie('locale');
    
    const newLocale = currentLocale === 'en' ? 'es' : 'en';
    
    document.cookie = `locale=${newLocale}; path=/`;
    localStorage.setItem('locale', newLocale);
    
    location.reload();
  }

  closeMenu(event) {
    if (!this.element.contains(event.target)) {
      this.menuTarget.classList.add("hidden");
    }
  }

  getCookie(name) {
    const value = `; ${document.cookie}`;
    const parts = value.split(`; ${name}=`);
    if (parts.length === 2) return parts.pop().split(';').shift();
  }
}
