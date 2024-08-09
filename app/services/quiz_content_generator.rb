# frozen_string_literal: true

class QuizContentGenerator
  LEVEL_QUESTIONS = {
    'easy' => 3,
    'medium' => 5,
    'hard' => 7
  }.freeze

  def initialize(level, ai_mode)
    @level = level
    @ai_mode = ai_mode
  end

  def generate
    questions = Array.new(number_of_questions) do
      pokemon = fetch_random_pokemon
      generate_question_for_pokemon(pokemon)
    end

    { questions: }
  end

  private

  def fetch_random_pokemon
    response = HTTParty.get("https://pokeapi.co/api/v2/pokemon/#{rand(1..151)}")
    JSON.parse(response.body)
  rescue JSON::ParserError, HTTParty::Error => e
    Rails.logger.error("Error fetching or parsing Pokémon data: #{e.message}")
    {}
  end

  def generate_question_for_pokemon(pokemon)
    return { error: 'Failed to fetch Pokémon data' } if pokemon.empty?

    question_generator = QuestionGenerator.new(pokemon, @level, @ai_mode)
    question_generator.generate_question
  end

  def number_of_questions
    LEVEL_QUESTIONS.fetch(@level, LEVEL_QUESTIONS['easy'])
  end
end
