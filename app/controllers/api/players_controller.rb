module Api
  class PlayersController < ApplicationController
    resource_description do
      short 'API for managing players'
      description 'This API show you the list of players and their quizzes'
    end

    api :GET, '/players', 'List all players'
    param :page, :number, desc: 'Page number'
    param :per_page, :number, desc: 'Number of players per page'
    example <<-EOS
    endpoint: /api/players?page=1&per_page=10
    {
      "data": [
        {
          "id": 1,
          "name": "Player 1",
          "quizzes": [
            {
              "id": 1,
              "name": "Quiz 1"
            }
          ]
        },
        {
          "id": 2,
          "name": "Player 2",
          "quizzes": [
            {
              "id": 2,
              "name": "Quiz 2"
            }
          ]
        }
      ],
      "meta": {
        "current_page": 1,
        "next_page": 2,
        "prev_page": null,
        "total_pages": 3,
        "total_count": 6
      }
    }
    EOS
    returns code: 200, desc: 'List of players' do
      property :data, Array do
        property :id, :number
        property :name, String
        property :quizzes, Array do
          property :id, :number
          property :name, String
        end
      end
      property :meta, Hash do
        property :current_page, :number
        property :next_page, :number
        property :prev_page, :number
        property :total_pages, :number
        property :total_count, :number
      end
    end
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
