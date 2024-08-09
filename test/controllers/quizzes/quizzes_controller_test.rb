# frozen_string_literal: true

require 'test_helper'

class QuizzesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @player = players(:player_one)
    @quiz = quizzes(:quiz_one)
  end

  test 'should get new' do
    get new_quiz_url
    assert_response :success
  end

  test 'should create quiz and redirect to first question' do
    assert_difference('Quiz.count') do
      post quizzes_url, params: { player: { name: @player.name }, quiz: { level: 'easy', ai_mode: false } }
    end

    quiz = Quiz.last
    assert_redirected_to quiz_path(quiz, question_index: 0)
  end

  test 'should show quiz' do
    get quiz_url(@quiz, question_index: 0)
    assert_response :success
  end

  test 'should calculate score and redirect to results when no more questions' do
    patch quiz_url(@quiz, question_index: @quiz.content['questions'].length - 1), params: { answer: 'correct answer' }

    assert_redirected_to results_quiz_path(@quiz)
  end
end
