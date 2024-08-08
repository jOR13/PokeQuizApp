# frozen_string_literal: true

class QuizContentGenerator
  def initialize(level)
    @level = level
  end

  def generate
    questions = []

    number_of_questions.times do
      pokemon = fetch_random_pokemon
      questions << generate_question(pokemon)
    end

    { questions: }
  end

  private

  def fetch_random_pokemon
    response = HTTParty.get("https://pokeapi.co/api/v2/pokemon/#{rand(1..151)}")
    JSON.parse(response.body)
  end

  def generate_question(pokemon)
    {
      question: "What is the type of #{pokemon['name']}?",
      options: pokemon['types'].map { |type| type['type']['name'] },
      answer: pokemon['types'][0]['type']['name'],
      player_answer: nil
    }
  end

  def number_of_questions
    levels = {
      'easy' => 3,
      'medium' => 5,
      'hard' => 7
    }
    levels.fetch(@level, 3)
  end
end
