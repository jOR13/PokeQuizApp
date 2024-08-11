# frozen_string_literal: true

module OpenaiStubs
  def stub_openai_request
    stub_request(:post, 'https://api.openai.com/v1/chat/completions')
      .with(
        body: /Generate multiple-choice questions/,
        headers: {
          'Authorization' => /Bearer .+/,
          'Content-Type' => 'application/json'
        }
      )
      .to_return(
        status: 200,
        body: {
          id: 'chatcmpl-9uMlFVWOMLBYvVmWHzsI6HaL21mVL',
          object: 'chat.completion',
          created: 1_723_220_889,
          model: 'gpt-3.5-turbo-0125',
          choices: [
            {
              index: 0,
              message: {
                role: 'assistant',
                content: '{"question":"What is the primary type of Paras?",
                  "options":["Bug","Grass","Poison","Water"],"answer":"Bug"}',
                refusal: nil
              },
              logprobs: nil,
              finish_reason: 'stop'
            }
          ],
          usage: {
            prompt_tokens: 151,
            completion_tokens: 40,
            total_tokens: 191
          },
          system_fingerprint: nil
        }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )
  end

  def stub_openai_success
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
  end

  def stub_openai_empty_response
    stub_request(:post, OpenaiService::OPENAI_API_URL).to_return(status: 200, body: '', headers: {})
  end

  def stub_openai_invalid_json
    stub_request(:post, OpenaiService::OPENAI_API_URL)
      .to_return(status: 200, body: 'Invalid JSON', headers: {})
  end

  def stub_openai_json_parsing_error
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
  end

  def stub_openai_http_error
    stub_request(:post, OpenaiService::OPENAI_API_URL).to_raise(StandardError.new('Network error'))
  end
end
