import consumer from "./consumer"

consumer.subscriptions.create("TopPlayersChannel", {
  connected() {
    console.log("Connected to TopPlayersChannel")
  },

  disconnected() {
  },

  received(data) {
    const topPlayersList = document.getElementById("top-players-list")
    if (topPlayersList) {
      topPlayersList.innerHTML = data
    }
  }
})
