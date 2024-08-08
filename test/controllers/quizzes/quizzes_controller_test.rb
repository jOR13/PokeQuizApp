# frozen_string_literal: true
require 'test_helper'

class QuizzesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get new_quiz_url
    assert_response :success
  end

  test "should create quiz" do
    assert_difference('Player.count') do
      post quizzes_url, params: { player: { name: "Test Player" }, quiz: { level: "easy" } }
    end
    assert_redirected_to quiz_path(Quiz.last, question_index: 0)
  end

  test "should show quiz" do
    player = Player.create(name: "Test Player")
    quiz = Quiz.create(content: { questions: [{ question: "Test question?", options: ["Option 1", "Option 2"], answer: "Option 1", player_answer: nil }] }, level: "easy")
    PlayerQuiz.create(player: player, quiz: quiz)

    get quiz_url(quiz, question_index: 0)
    assert_response :success
  end
end
