# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'json'

class QuestionGenerator
  OPENAI_API_URL = 'https://api.openai.com/v1/chat/completions'
  OPENAI_API_KEY = ENV.fetch('OPENAI_API_KEY', nil)

  def initialize(pokemon_info, level, ai_mode)
    @pokemon_info = pokemon_info
    @level = level
    @ai_mode = ai_mode
  end

  def generate_question
    if @ai_mode
      prompt = build_prompt(@pokemon_info)
      response = make_request(prompt)
      question = parse_response(response)

      question = generate_backup_question(@pokemon_info) if question[:error]
    else
      question = generate_backup_question(@pokemon_info)
    end

    question
  end

  private

  def build_prompt(pokemon_info)
    <<~PROMPT
      You are a quiz master who generates questions about Pokémon. Generate multiple-choice questions with this level of difficulty #{@level} along with the correct answer and three incorrect answers based on the following Pokémon #{pokemon_info['name']}.

      Provide the question and options in the following JSON format, for example:
      {
        "question": "What is the type of <pokemon name>? or What is the color of <pokemon name>? or What is the evolution of <pokemon name>?, etc.",
        "options": ["option1", "option2", "option3", "option4"],
        "answer": "correct option"
      }
    PROMPT
  end

  def make_request(prompt)
    uri = URI.parse(OPENAI_API_URL)
    request = Net::HTTP::Post.new(uri)
    request.content_type = 'application/json'
    request['Authorization'] = "Bearer #{OPENAI_API_KEY}"
    request.body = {
      model: 'gpt-3.5-turbo',
      messages: [
        {
          role: 'system',
          content: 'You are a quiz master who generates questions about Pokémon.'
        },
        {
          role: 'user',
          content: prompt
        }
      ],
      max_tokens: 150,
      temperature: 0.5
    }.to_json

    req_options = {
      use_ssl: uri.scheme == 'https'
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end

    JSON.parse(response.body)
  rescue JSON::ParserError => e
    Rails.logger.error("JSON::ParserError: #{e.message}")
    nil
  end

  def parse_response(response)
    return { error: 'Could not generate question' } unless response && response['choices']

    content = response['choices'].first['message']['content'].strip
    JSON.parse(content)
  rescue JSON::ParserError => e
    Rails.logger.error("JSON::ParserError: #{e.message}")
    { error: 'Could not parse generated question' }
  end

  def generate_backup_question(pokemon_info)
    question_types = [
      -> { generate_type_question(pokemon_info) },
      -> { generate_color_question(pokemon_info) },
      -> { generate_ability_question(pokemon_info) }
    ]

    question_types.sample.call
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
    incorrect_answers = %w[water fire grass flying psychic dark ground rock electric].map(&:downcase)
    incorrect_answers.delete(correct_answer)
    options = incorrect_answers.sample(3) << correct_answer
    options.shuffle
  end

  def fetch_pokemon_color(pokemon_name)
    response = HTTParty.get("https://pokeapi.co/api/v2/pokemon-species/#{pokemon_name}")
    species_info = JSON.parse(response.body)
    species_info['color']['name']
  end
end
