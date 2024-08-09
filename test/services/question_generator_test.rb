require 'test_helper'

class QuestionGeneratorTest < ActiveSupport::TestCase
  def setup
    @pokemon_info = {
      'name' => 'Pikachu',
      'types' => [{ 'type' => { 'name' => 'electric' } }],
      'abilities' => [{ 'ability' => { 'name' => 'static' } }]
    }
    @generator = QuestionGenerator.new(@pokemon_info, 'easy', true)
  end

  def test_generate_question_using_ai_mode
    def @generator.make_request(_prompt)
      {
        'choices' => [{
          'message' => {
            'content' => '{"question": "What is the type of Pikachu?", "options": ["water", "fire", "grass", "electric"], "answer": "electric"}'
          }
        }]
      }
    end

    question = @generator.generate_question

    assert_equal 'What is the type of Pikachu?', question['question']
    assert_equal %w[water fire grass electric], question['options']
    assert_equal 'electric', question['answer']
  end
  
  def test_generate_type_question
    question = @generator.send(:generate_type_question, @pokemon_info)

    assert_equal 'What is the type of Pikachu?', question[:question]
    assert_includes question[:options], 'electric'
    assert_equal 'electric', question[:answer]
  end

  def test_generate_color_question
    def @generator.fetch_pokemon_color(_name)
      'yellow'
    end

    question = @generator.send(:generate_color_question, @pokemon_info)

    assert_equal 'What is the color of Pikachu?', question[:question]
    assert_includes question[:options], 'yellow'
    assert_equal 'yellow', question[:answer]
  end

  def test_generate_ability_question
    question = @generator.send(:generate_ability_question, @pokemon_info)

    assert_equal 'What is one of the abilities of Pikachu?', question[:question]
    assert_includes question[:options], 'static'
    assert_equal 'static', question[:answer]
  end

  def test_generate_options
    options = @generator.send(:generate_options, 'electric')

    assert_equal 4, options.length
    assert_includes options, 'electric'
  end

  test "should handle JSON parse error in parse_response" do
    response = { 'choices' => [{ 'message' => { 'content' => 'invalid json' } }] }

    assert_equal({ error: 'Could not parse generated question' }, @generator.send(:parse_response, response))
  end

  test "should handle missing content in parse_response" do
    response = { 'choices' => [{ 'message' => { 'content' => nil } }] }

    assert_equal({ error: 'Could not generate question' }, @generator.send(:parse_response, response))
  end
end
