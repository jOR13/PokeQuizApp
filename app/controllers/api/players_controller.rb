# frozen_string_literal: true

module Api
  class PlayersController < ApplicationController
    include Api::PlayersDocumentation

    def index
      players = Player.includes(:quizzes)
                      .page(params[:page])
                      .per(params[:per_page] || 10)

      render json: {
        data: players.as_json(include: :quizzes),
        meta: pagination_meta(players)
      }
    end

    private

    def pagination_meta(collection)
      {
        current_page: collection.current_page,
        next_page: collection.next_page,
        prev_page: collection.prev_page,
        total_pages: collection.total_pages,
        total_count: collection.total_count
      }
    end
  end
end
