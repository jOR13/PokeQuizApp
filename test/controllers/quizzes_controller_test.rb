# frozen_string_literal: true

require 'test_helper'
require_relative '../api_stubs/openai_stubs'
require_relative '../api_stubs/pokeapi_stubs'

class QuizzesControllerTest < ActionDispatch::IntegrationTest
  include OpenaiStubs
  include PokeapiStubs

  def setup
    @player = players(:player_one)
    @quiz = quizzes(:quiz_one)
    @quiz.update(content: { 'questions' => [{ 'question' => 'Test?', 'answer' => 'Yes', 'options' => %w[Yes No] }] })
  end

  test 'should create quiz' do
    stub_pokeapi_request(1, 'nidorino')
    stub_openai_request

    assert_difference('Quiz.count', 1) do
      post quizzes_url, params: {
        player: { name: 'New Player' },
        quiz: { level: 'easy', ai_mode: 'false' }
      }
    end

    assert_redirected_to quiz_path(Quiz.last, question_index: 0)
  end

  test 'should handle player creation failure' do
    Player.stub :find_or_initialize_by, Player.new do |player|
      player.define_singleton_method(:save) { false }
      post quizzes_url, params: { player: { name: 'InvalidName' }, quiz: { level: 'easy', ai_mode: 'false' } }
    end

    assert_response :success
    assert_equal 'The player could not be created.', flash[:error]
    assert_template :new
  end

  test 'should redirect to next question if there are more questions' do
    @quiz.update(content: {
                   'questions' => [
                     { 'question' => 'Q1?', 'answer' => 'Yes', 'player_answer' => nil, 'options' => %w[Yes No] },
                     { 'question' => 'Q2?', 'answer' => 'No', 'player_answer' => nil, 'options' => %w[Yes No] }
                   ]
                 })

    patch quiz_url(@quiz), params: { question_index: 0, answer: 'Yes' }

    assert_redirected_to quiz_path(@quiz, question_index: 1)
  end

  test 'should show quiz' do
    get quiz_url(@quiz, question_index: 0)
    assert_response :success
  end

  test 'should update quiz and go to results for last question' do
    patch quiz_url(@quiz), params: { question_index: 0, answer: 'Yes' }
    assert_redirected_to results_quiz_path(@quiz)
    @quiz.reload
    assert_equal 'Yes', @quiz.content['questions'][0]['player_answer']
  end

  test 'should show results' do
    get results_quiz_url(@quiz)
    assert_response :success
  end

  test 'should calculate and save score' do
    @quiz.update(content: {
                   'questions' => [
                     { 'question' => 'Q1?', 'answer' => 'Yes', 'player_answer' => 'Yes', 'options' => %w[Yes No] },
                     { 'question' => 'Q2?', 'answer' => 'No', 'player_answer' => 'No', 'options' => %w[Yes No] }
                   ]
                 })
    patch quiz_url(@quiz), params: { question_index: 1, answer: 'No' }
    assert_redirected_to results_quiz_path(@quiz)
    @quiz.reload
    assert_equal 2, @quiz.score
  end

  test 'should fetch top players' do
    get new_quiz_url
    assert_response :success
    assert_not_nil assigns(:players)
    assert assigns(:players).is_a?(ActiveRecord::Relation)
  end

  test 'should broadcast top players after quiz completion' do
    assert_broadcasts('top_players', 1) do
      patch quiz_url(@quiz), params: { question_index: 0, answer: 'Yes' }
    end
  end
end
