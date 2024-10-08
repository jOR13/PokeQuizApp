# frozen_string_literal: true

require 'i18n'
require 'httparty'
require_relative 'question_constants'

class QuestionGeneratorService
  include QuestionConstants                                

  def initialize(pokemon_info, level, ai_mode)
    @pokemon_info = pokemon_info
    @level = level
    @ai_mode = ai_mode
    @locale = I18n.locale
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
    ai_response = OpenaiService.generate_question(prompt)

    if ai_response.present?
      ai_response = JSON.parse(ai_response, symbolize_names: true) if ai_response.is_a?(String)
      ai_response[:image_url] = fetch_pokemon_image(@pokemon_info['name'])
    end

    ai_response
  end

  def generate_backup_question(pokemon_info)
    question_type = select_question_type
    question = question_type.call(pokemon_info)
    
    question[:image_url] = fetch_pokemon_image(pokemon_info['name'])

    question
  end

  def select_question_type
    case @level
    when 'easy'
      easy_question_types.sample
    when 'medium'
      medium_question_types.sample
    when 'hard'
      hard_question_types.sample
    else
      easy_question_types.sample
    end
  end

  def easy_question_types
    [
      method(:generate_type_question),
      method(:generate_color_question)
    ]
  end

  def medium_question_types
    [
      method(:generate_ability_question),
      method(:generate_evolution_chain_question)
    ]
  end

  def hard_question_types
    [
      method(:generate_evolution_chain_question),
      method(:generate_advanced_ability_question)
    ]
  end

  def generate_type_question(pokemon_info)
    correct_answer = fetch_translated_name(pokemon_info['types'].first['type']['url'], @locale)
    pokemon_name = pokemon_info['name']
    {
      question: I18n.t('type_question', name: pokemon_name, locale: @locale),
      options: generate_options(correct_answer, :type),
      answer: correct_answer
    }
  end

  def generate_color_question(pokemon_info)
    correct_answer = fetch_translated_color(pokemon_info['name'], @locale)
    {
      question: I18n.t('color_question', name: fetch_translated_name(pokemon_info['species']['url'], @locale),
                                         locale: @locale),
      options: generate_options(correct_answer, :color),
      answer: correct_answer
    }
  end

  def generate_ability_question(pokemon_info)
    correct_answer = fetch_translated_name(pokemon_info['abilities'].sample['ability']['url'], @locale)
    {
      question: I18n.t('ability_question', name: fetch_translated_name(pokemon_info['species']['url'], @locale),
                                           locale: @locale),
      options: generate_options(correct_answer, :ability),
      answer: correct_answer
    }
  end


  def generate_evolution_chain_question(pokemon_info)
    evolutions = fetch_pokemon_evolutions(pokemon_info['name'], @locale)
    evolutions.last === pokemon_info['name'] ? evolutions[-1] = I18n.t('no_more_evolutions', locale: @locale) : nil
    extra_evolutions = []

    if evolutions.size < 4
      all_possible_evolutions = @locale == :es ? INCORRECT_EVOLUTIONS_ES : INCORRECT_EVOLUTIONS_EN
      extra_evolutions = (all_possible_evolutions - evolutions.map(&:downcase)).sample(4 - evolutions.size)
    end

    evolutions = evolutions.map(&:downcase).uniq
    extra_evolutions = extra_evolutions.map(&:downcase).uniq

    {
      question: I18n.t('evolution_chain_question',
                       name: fetch_translated_name(pokemon_info['species']['url'], @locale), locale: @locale),
      answer: evolutions.last,
      options: evolutions + extra_evolutions

    }
  end

  def generate_advanced_ability_question(pokemon_info)
    correct_answer = fetch_translated_name(pokemon_info['abilities'].last['ability']['url'], @locale)
    {
      question: I18n.t('advanced_ability_question',
                       name: fetch_translated_name(pokemon_info['species']['url'], @locale), locale: @locale),
      options: generate_options(correct_answer, :ability),
      answer: correct_answer
    }
  end

  def generate_options(correct_answer, category)
    incorrect_answers = case category
                        when :type
                          @locale == :es ? INCORRECT_ANSWERS_ES : INCORRECT_ANSWERS_EN
                        when :color
                          @locale == :es ? INCORRECT_COLORS_ES : INCORRECT_COLORS_EN
                        when :ability
                          @locale == :es ? INCORRECT_ABILITIES_ES : INCORRECT_ABILITIES_EN
                        when :evolution
                          @locale == :es ? INCORRECT_EVOLUTIONS_ES : INCORRECT_EVOLUTIONS_EN
                        else
                          []
                        end
    options = (incorrect_answers - [correct_answer&.downcase]).sample(3) << correct_answer
    options.shuffle
  end

  def fetch_translated_name(url, locale)
    response = HTTParty.get(url)
    data = JSON.parse(response.body)
    name_entry = data['names'].find { |n| n['language']['name'] == locale.to_s }
    name_entry ? name_entry['name']&.downcase : data['name']&.downcase
  end

  def fetch_translated_color(pokemon_name, locale)
    response = HTTParty.get("https://pokeapi.co/api/v2/pokemon-species/#{pokemon_name}")
    species_info = JSON.parse(response.body)
    color_url = species_info['color']['url']
    fetch_translated_name(color_url, locale)
  end

  def fetch_pokemon_evolutions(pokemon_name, locale)
    response = HTTParty.get("https://pokeapi.co/api/v2/pokemon-species/#{pokemon_name}")
    species_info = JSON.parse(response.body)
    evolution_chain_url = species_info['evolution_chain']['url']

    evolution_response = HTTParty.get(evolution_chain_url)
    evolution_chain_info = JSON.parse(evolution_response.body)

    extract_evolution_names(evolution_chain_info['chain'], locale)
  end

  def extract_evolution_names(chain, locale)
    names = [fetch_translated_name(chain['species']['url'], locale)]
    while chain['evolves_to'].any?
      chain = chain['evolves_to'].first
      names << fetch_translated_name(chain['species']['url'], locale)
    end
    names
  end

  def fetch_pokemon_image(pokemon_name)
    response = HTTParty.get("https://pokeapi.co/api/v2/pokemon/#{pokemon_name}")
    data = JSON.parse(response.body)
    data['sprites']['other']['official-artwork']['front_default']
  end

  def build_prompt(pokemon_info)
    prompt_template = <<-PROMPT
    You are a quiz master who generates multiple-choice questions about Pokémon. 
    Generate a question in #{I18n.locale} with the level of difficulty as: #{@level}. 
    Based on the Pokémon: #{pokemon_info['name']}, provide the following:
    1. A question related to the Pokémon's type, color, ability, or evolution chain.
    2. Four options, where one option is the correct answer and three are incorrect.
    3. Clearly indicate the correct answer.
    Ensure the format of your response follows this structure:
    {
      "question": "Your generated question?",
      "options": ["Option 1", "Option 2", "Option 3", "Option 4"],
      "answer": "Correct Answer"
    }
    PROMPT
  end

  
end
