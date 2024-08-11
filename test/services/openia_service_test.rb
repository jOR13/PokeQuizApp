# frozen_string_literal: true

require 'test_helper'
require 'net/http'
require_relative '../api_stubs/openai_stubs'

class OpenaiServiceTest < ActiveSupport::TestCase
  include OpenaiStubs

  def setup
    @prompt = 'Generate a Pokémon quiz question'
    @service = OpenaiService.new(@prompt)
  end

  def test_generate_question_success
    stub_openai_success

    result = @service.generate_question
    assert_not_nil result, 'Result should not be nil'
    assert_equal "What is Pikachu's type?", result['question']
    assert_equal %w[Electric Fire Water Grass], result['options']
    assert_equal 'Electric', result['answer']
  end

  def test_generate_question_with_empty_response
    stub_openai_empty_response

    result = @service.generate_question

    assert_nil result, 'Result should be nil when response is empty'
  end

  def test_generate_question_with_invalid_json
    stub_openai_invalid_json

    result = @service.generate_question

    assert_nil result, 'Result should be nil when JSON is invalid'
  end

  def test_generate_question_with_http_error
    stub_openai_http_error

    result = @service.generate_question

    assert_nil result, 'Result should be nil when there is a network error'
  end

  def test_generate_question_with_json_parsing_error
    stub_openai_json_parsing_error

    result = @service.generate_question

    assert_nil result, 'Result should be nil due to JSON parsing error'
  end
end
