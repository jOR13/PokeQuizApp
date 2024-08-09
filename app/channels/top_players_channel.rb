# frozen_string_literal: true

class TopPlayersChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'top_players'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
