# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'json'

class QuestionGenerator
  OPENAI_API_URL = 'https://api.openai.com/v1/chat/completions'
  OPENAI_API_KEY = ENV.fetch('OPENAI_API_KEY')
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
    response = make_request(prompt)
    parse_response(response)
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

  def make_request(prompt)
    uri = URI.parse(OPENAI_API_URL)
    request = Net::HTTP::Post.new(uri)
    request.content_type = 'application/json'
    request['Authorization'] = "Bearer #{OPENAI_API_KEY}"
    request.body = {
      model: 'gpt-3.5-turbo',
      messages: [
        { role: 'system', content: 'You are a quiz master who generates questions about Pokémon.' },
        { role: 'user', content: prompt }
      ],
      max_tokens: 150,
      temperature: 0.5
    }.to_json

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') { |http| http.request(request) }
    JSON.parse(response.body)
  rescue JSON::ParserError => e
    Rails.logger.error("JSON::ParserError: #{e.message}")
    nil
  rescue StandardError => e
    Rails.logger.error("Request failed: #{e.message}")
    nil
  end

  def parse_response(response)
    return { error: 'Could not generate question' } unless response&.dig('choices', 0, 'message', 'content')

    content = response['choices'][0]['message']['content'].strip
    JSON.parse(content)
  rescue JSON::ParserError => e
    Rails.logger.error("JSON::ParserError: #{e.message}")
    { error: 'Could not parse generated question' }
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
