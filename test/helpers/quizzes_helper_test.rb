# frozen_string_literal: true

require 'test_helper'

class QuizzesHelperTest < ActionView::TestCase
  def format_score(score)
    "#{score} points"
  end

  test 'format_score' do
    assert_equal '100 points', format_score(100)
  end

  test 'should format question correctly' do
    question = {
      'question' => 'What is the type of Pikachu?',
      'options' => %w[Electric Water Fire Grass]
    }

    expected_output = 'What is the type of Pikachu? (Options: Electric, Water, Fire, Grass)'
    assert_equal expected_output, format_question(question)
  end
end
