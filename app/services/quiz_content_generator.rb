# frozen_string_literal: true

class QuizContentGenerator
  def initialize(level, ai_mode)
    @level = level
    @ai_mode = ai_mode
  end

  def generate
    questions = []

    number_of_questions.times do
      pokemon = fetch_random_pokemon
      question_generator = QuestionGenerator.new(pokemon, @level, @ai_mode)
      questions << question_generator.generate_question
    end

    { questions: }
  end

  private

  def fetch_random_pokemon
    response = HTTParty.get("https://pokeapi.co/api/v2/pokemon/#{rand(1..151)}")
    JSON.parse(response.body)
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
