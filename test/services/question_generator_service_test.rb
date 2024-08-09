# frozen_string_literal: true

require 'test_helper'

class QuestionGeneratorServiceTest < ActiveSupport::TestCase
  def setup
    @pokemon_info = {
      'name' => 'pikachu',
      'types' => [{ 'type' => { 'name' => 'electric' } }],
      'abilities' => [{ 'ability' => { 'name' => 'static' } }]
    }
    @level = 'medium'
    @ai_mode = false
    @service = QuestionGeneratorService.new(@pokemon_info, @level, @ai_mode)

    stub_request(:get, 'https://pokeapi.co/api/v2/pokemon-species/pikachu')
      .to_return(status: 200, body: '{"color": {"name": "yellow"}}', headers: { 'Content-Type': 'application/json' })
  end

  def test_generate_question_without_ai_mode
    question = @service.generate_question
    assert_kind_of Hash, question
    assert_includes ['What is the type of pikachu?',
                     'What is the color of pikachu?',
                     'What is one of the abilities of pikachu?'],
                    question[:question]
    assert_equal 4, question[:options].size
    assert_includes question[:options], question[:answer]
  end

  def test_generate_type_question
    question = @service.send(:generate_type_question, @pokemon_info)
    assert_equal 'What is the type of pikachu?', question[:question]
    assert_equal 'electric', question[:answer]
    assert_includes question[:options], 'electric'
  end

  def test_generate_color_question
    @service.stub :fetch_pokemon_color, 'yellow' do
      question = @service.send(:generate_color_question, @pokemon_info)
      assert_equal 'What is the color of pikachu?', question[:question]
      assert_equal 'yellow', question[:answer]
      assert_includes question[:options], 'yellow'
    end
  end

  def test_generate_ability_question
    question = @service.send(:generate_ability_question, @pokemon_info)
    assert_equal 'What is one of the abilities of pikachu?', question[:question]
    assert_equal 'static', question[:answer]
    assert_includes question[:options], 'static'
  end

  def test_generate_options
    correct_answer = 'electric'
    options = @service.send(:generate_options, correct_answer)
    assert_equal 4, options.size
    assert_includes options, correct_answer
    assert_equal options.uniq, options
  end

  def test_fetch_pokemon_color
    mock_response = Minitest::Mock.new
    mock_response.expect :body, '{"color": {"name": "yellow"}}'
    HTTParty.stub :get, mock_response do
      color = @service.send(:fetch_pokemon_color, 'pikachu')
      assert_equal 'yellow', color
    end
  end

  private

  def mock_ai_question
    {
      question: "What is Pikachu's signature move?",
      options: ['Thunderbolt', 'Hydro Pump', 'Flamethrower', 'Solar Beam'],
      answer: 'Thunderbolt'
    }
  end
end
