# frozen_string_literal: true

module PlayerHandling
  extend ActiveSupport::Concern

  included do
    helper_method :top_players
  end

  def find_or_create_player
    player = Player.find_or_initialize_by(name: player_params[:name])
    player.save ? player : nil
  end

  def fetch_top_players
    @players = top_players
  end

  def top_players
    Player.joins(:quizzes)
          .select('players.id, players.name, SUM(quizzes.score) AS total_score, MAX(quizzes.level) AS max_level')
          .group('players.id, players.name')
          .having('SUM(quizzes.score) > 0')
          .order('total_score DESC')
          .limit(10)
  end

  def broadcast_top_players
    ActionCable.server.broadcast 'top_players', turbo_stream.replace(
      'top-players-list',
      partial: 'players/top_players',
      locals: { players: top_players }
    )
  end
end
