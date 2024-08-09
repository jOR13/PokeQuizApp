# frozen_string_literal: true

require 'test_helper'
require 'webmock/minitest'

class QuizContentGeneratorServiceTest < ActiveSupport::TestCase
  def setup
    @level = 'medium'
    @ai_mode = false
    @service = QuizContentGeneratorService.new(@level, @ai_mode)
  end

  def test_generate_returns_correct_number_of_questions
    stub_random_pokemon_request
    stub_question_generator do
      result = @service.generate
      assert_equal 5, result[:questions].length
    end
  end

  def test_generate_with_different_levels
    stub_random_pokemon_request
    stub_question_generator do
      assert_equal 3, QuizContentGeneratorService.new('easy', @ai_mode).generate[:questions].length
      assert_equal 5, QuizContentGeneratorService.new('medium', @ai_mode).generate[:questions].length
      assert_equal 7, QuizContentGeneratorService.new('hard', @ai_mode).generate[:questions].length
    end
  end

  def test_generate_with_unknown_level_defaults_to_easy
    stub_random_pokemon_request
    stub_question_generator do
      result = QuizContentGeneratorService.new('unknown', @ai_mode).generate
      assert_equal 3, result[:questions].length
    end
  end

  def test_fetch_random_pokemon_success
    stub_random_pokemon_request

    pokemon = @service.send(:fetch_random_pokemon)
    assert_equal 'pikachu', pokemon['name']
  end

  def test_fetch_random_pokemon_failure
    stub_request(:get, /pokeapi.co/).to_return(status: 500)

    pokemon = @service.send(:fetch_random_pokemon)
    assert_empty pokemon
  end

  def test_generate_question_for_pokemon_success
    pokemon_data = { 'name' => 'pikachu', 'types' => [{ 'type' => { 'name' => 'electric' } }] }
    stub_question_generator do
      question = @service.send(:generate_question_for_pokemon, pokemon_data)
      assert_equal 'mock question', question[:question]
    end
  end

  def test_generate_question_for_pokemon_failure
    question = @service.send(:generate_question_for_pokemon, {})
    assert_equal({ error: 'Failed to fetch Pokémon data' }, question)
  end

  private

  def stub_random_pokemon_request
    body = {
      name: 'pikachu',
      types: [{ type: { name: 'electric' } }]
    }.to_json

    headers = { 'Content-Type' => 'application/json' }

    stub_request(:get, /pokeapi.co/)
      .to_return(status: 200, body:, headers:)
  end

  def stub_question_generator(&)
    mock_question = { question: 'mock question', options: %w[A B C D], answer: 'A' }
    QuestionGeneratorService.stub(:new, ->(*_args) { OpenStruct.new(generate_question: mock_question) }, &)
  end
end
