# frozen_string_literal: true

require 'test_helper'
require 'net/http'

class OpenaiServiceTest < ActiveSupport::TestCase
  def setup
    @prompt = 'Generate a Pokémon quiz question'
    @service = OpenaiService.new(@prompt)
  end

  def test_generate_question_success
    {
      choices: [
        {
          message: {
            content: { question: "What is Pikachu's type?", options: %w[Electric Fire Water Grass],
                       answer: 'Electric' }.to_json
          }
        }
      ]
    }.to_json

    stub_request(:post, OpenaiService::OPENAI_API_URL)
      .to_return(
        status: 200,
        body: {
          choices: [{
            message: {
              content: "{\"question\":\"What is Pikachu's type?\",
              \"options\":[\"Electric\",\"Fire\",\"Water\",
              \"Grass\"],\"answer\":\"Electric\"}"
            }
          }]
        }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )

    result = @service.generate_question
    assert_not_nil result, 'Result should not be nil'
    assert_equal "What is Pikachu's type?", result['question']
    assert_equal %w[Electric Fire Water Grass], result['options']
    assert_equal 'Electric', result['answer']
  end

  def test_generate_question_with_empty_response
    stub_request(:post, OpenaiService::OPENAI_API_URL)
      .to_return(status: 200, body: '', headers: {})

    result = OpenaiService.generate_question(@prompt)

    assert_nil result, 'Result should be nil when response is empty'
  end

  test 'should handle JSON parsing error' do
    stub_request(:post, OpenaiService::OPENAI_API_URL)
      .to_return(
        status: 200,
        body: {
          choices: [{
            message: {
              content: '{this is not JSON}'
            }
          }]
        }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )

    result = @service.generate_question
    assert_nil result, 'Result should be nil due to JSON parsing error'
  end

  def test_generate_question_with_invalid_json
    stub_request(:post, OpenaiService::OPENAI_API_URL)
      .to_return(status: 200, body: 'Invalid JSON', headers: {})

    result = OpenaiService.generate_question(@prompt)

    assert_nil result, 'Result should be nil when JSON is invalid'
  end

  def test_generate_question_with_http_error
    stub_request(:post, OpenaiService::OPENAI_API_URL)
      .to_raise(StandardError.new('Network error'))

    result = OpenaiService.generate_question(@prompt)

    assert_nil result, 'Result should be nil when there is a network error'
  end
end
