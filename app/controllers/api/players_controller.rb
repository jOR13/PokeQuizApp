module Api
    class PlayersController < ApplicationController
      def index
        players = Player.includes(:quizzes).all
        render json: players.to_json(include: :quizzes)
      end
    end
  end
  