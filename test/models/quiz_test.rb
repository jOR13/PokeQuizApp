# frozen_string_literal: true

require 'test_helper'

class QuizTest < ActiveSupport::TestCase
  def setup
    @quiz = Quiz.new(content: { questions: [] }, level: 'easy')
  end

  test 'should not save quiz with invalid level' do
    @quiz.level = 'invalid_level'
    assert_not @quiz.save, 'Could not save the quizz with an invalid level'
  end

  test 'should save quiz with valid level' do
    @quiz.level = 'medium'
    assert @quiz.save, 'Could save the quizz with a valid level'
  end
end
