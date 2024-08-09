# frozen_string_literal: true

class OpenaiService
  OPENAI_API_URL = 'https://api.openai.com/v1/chat/completions'
  OPENAI_API_KEY = ENV.fetch('OPENAI_API_KEY')

  def self.generate_question(prompt)
    new(prompt).generate_question
  end

  def initialize(prompt)
    @prompt = prompt
  end

  def generate_question
    response = make_request
    parse_response(response)
  end

  private

  def make_request
    uri = URI.parse(OPENAI_API_URL)
    request = Net::HTTP::Post.new(uri)
    request.content_type = 'application/json'
    request['Authorization'] = "Bearer #{OPENAI_API_KEY}"
    request.body = build_request_body

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.request(request)
    end
    response_body = JSON.parse(response.body)
    Rails.logger.debug response_body
    response_body
  rescue JSON::ParserError => e
    Rails.logger.error("JSON Parsing Error in OpenAI request: #{e.message}")
    nil
  rescue StandardError => e
    Rails.logger.error("Error in OpenAI request: #{e.message}")
    nil
  end

  def build_request_body
    {
      model: 'gpt-3.5-turbo',
      messages: [
        { role: 'system', content: 'You are a quiz master who generates questions about Pokémon.' },
        { role: 'user', content: @prompt }
      ],
      max_tokens: 150,
      temperature: 0.5
    }.to_json
  end

  def parse_response(response)
    return nil unless response&.dig('choices', 0, 'message', 'content')

    content = response['choices'][0]['message']['content']
    JSON.parse(content.strip)
  rescue JSON::ParserError => e
    Rails.logger.error("JSON::ParserError: #{e.message}")
    nil
  end
end
