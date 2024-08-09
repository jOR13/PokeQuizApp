# frozen_string_literal: true

class QuestionGeneratorService
  INCORRECT_ANSWERS = %w[water fire grass flying psychic dark ground rock electric].map(&:downcase)

  def initialize(pokemon_info, level, ai_mode)
    @pokemon_info = pokemon_info
    @level = level
    @ai_mode = ai_mode
  end

  def generate_question
    if @ai_mode
      generate_ai_question || generate_backup_question(@pokemon_info)
    else
      generate_backup_question(@pokemon_info)
    end
  end

  private

  def generate_ai_question
    prompt = build_prompt(@pokemon_info)
    OpenaiService.generate_question(prompt)
  end

  def build_prompt(pokemon_info)
    <<~PROMPT
      You are a quiz master who generates questions about Pokémon. Generate multiple-choice questions with the level of difficulty as: #{@level}, along with the correct answer and three incorrect answers based on the following Pokémon: #{pokemon_info['name']}.

      Provide the question and options that can be answered by studying the PokeAPI, in the following JSON format:
      {
        "question": "What is the type of <pokemon name>? or What is the color of <pokemon name>? or What is the evolution of <pokemon name>?, etc.",
        "options": ["option1", "option2", "option3", "option4"],
        "answer": "correct option"
      }
    PROMPT
  end

  def generate_backup_question(pokemon_info)
    question_types.sample.call(pokemon_info)
  end

  def question_types
    [
      method(:generate_type_question),
      method(:generate_color_question),
      method(:generate_ability_question)
    ]
  end

  def generate_type_question(pokemon_info)
    correct_answer = pokemon_info['types'].first['type']['name'].downcase
    {
      question: "What is the type of #{pokemon_info['name']}?",
      options: generate_options(correct_answer),
      answer: correct_answer
    }
  end

  def generate_color_question(pokemon_info)
    correct_answer = fetch_pokemon_color(pokemon_info['name']).downcase
    {
      question: "What is the color of #{pokemon_info['name']}?",
      options: generate_options(correct_answer),
      answer: correct_answer
    }
  end

  def generate_ability_question(pokemon_info)
    correct_answer = pokemon_info['abilities'].sample['ability']['name'].downcase
    {
      question: "What is one of the abilities of #{pokemon_info['name']}?",
      options: generate_options(correct_answer),
      answer: correct_answer
    }
  end

  def generate_options(correct_answer)
    (INCORRECT_ANSWERS - [correct_answer]).sample(3) << correct_answer
  end

  def fetch_pokemon_color(pokemon_name)
    response = HTTParty.get("https://pokeapi.co/api/v2/pokemon-species/#{pokemon_name}")
    species_info = JSON.parse(response.body)
    species_info['color']['name']
  end
end
