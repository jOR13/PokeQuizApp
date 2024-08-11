# frozen_string_literal: true

module Api
  module PlayersDocumentation
    extend Apipie::DSL::Concern

    included do
      resource_description do
        short 'API for showing players and their quizzes'
        description 'This API allows you to list all players and their quizzes played'
      end

      api :GET, '/players', 'List all players'
      param :page, :number, desc: 'Page number'
      param :per_page, :number, desc: 'Number of players per page'
      example <<-JSON_EXAMPLE
        ENDPOINT: #{ENV.fetch('API_URL', nil)}/api/players
        {
          "data": [
            {
              "id": 15,
              "name": "jesus",
              "created_at": "2024-08-09T00:09:23.588Z",
              "updated_at": "2024-08-09T00:09:23.588Z",
              "quizzes": [
                {
                  "id": 15,
                  "content": {
                    "questions": [
                      {
                        "answer": "flame-body",
                        "options": [
                          "flying",
                          "rock",
                          "electric",
                          "flame-body"
                        ],
                        "question": "What is one of the abilities of magmar?",
                        "player_answer": null
                      },
                      {
                        "answer": "intimidate",
                        "options": [
                          "flying",
                          "dark",
                          "intimidate",
                          "ground"
                        ],
                        "question": "What is one of the abilities of growlithe?",
                        "player_answer": null
                      },
                      {
                        "answer": "rock",
                        "options": [
                          "rock",
                          "grass",
                          "fire",
                          "psychic"
                        ],
                        "question": "What is the type of omanyte?",
                        "player_answer": null
                      },
                      {
                        "answer": "rock",
                        "options": [
                          "flying",
                          "water",
                          "rock",
                          "grass"
                        ],
                        "question": "What is the type of geodude?",
                        "player_answer": null
                      },
                      {
                        "answer": "bug",
                        "options": [
                          "bug",
                          "water",
                          "ground",
                          "flying"
                        ],
                        "question": "What is the type of venomoth?",
                        "player_answer": null
                      }
                    ]
                  },
                  "created_at": "2024-08-09T00:09:25.767Z",
                  "updated_at": "2024-08-09T00:09:33.237Z",
                  "level": "medium",
                  "ai_mode": null,
                  "score": 0
                }
              ]
            }
          ]
        }
      JSON_EXAMPLE
      returns code: 200, desc: 'List of players' do
        property :data, Array do
          property :id, :number, desc: 'Player ID'
          property :name, String, desc: 'Player name'
          property :created_at, String, desc: 'Player creation timestamp'
          property :updated_at, String, desc: 'Player update timestamp'
          property :quizzes, Array do
            property :id, :number, desc: 'Quiz ID'
            property :content, Hash do
              property :questions, Array do
                property :answer, String, desc: 'Correct answer for the question'
                property :options, Array, of: String, desc: 'Available options for the question'
                property :question, String, desc: 'Question text'
                property :player_answer, String, desc: 'Player\'s answer, null if not answered'
              end
            end
            property :created_at, String, desc: 'Quiz creation timestamp'
            property :updated_at, String, desc: 'Quiz update timestamp'
            property :level, String, desc: 'Quiz difficulty level'
            property :ai_mode, String, desc: 'AI mode, if any'
            property :score, :number, desc: 'Quiz score'
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
    end
  end
end
