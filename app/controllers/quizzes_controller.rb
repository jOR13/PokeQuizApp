# frozen_string_literal: true

class QuizzesController < ApplicationController
  include PlayerHandling
  include QuizHandling

  before_action :set_quiz, only: %i[show update results]
  before_action :set_question, only: %i[show update]
  before_action :fetch_top_players, only: %i[new create]

  def show; end

  def new
    @quiz = Quiz.new
    @player = Player.new
  end

  def create
    @player = find_or_create_player

    if @player.nil?
      flash.now[:error] = I18n.t('flash.player_creation_error')
      render :new and return
    end

    @quiz = build_quiz(@player)

    if @quiz.save
      PlayerQuiz.create(player: @player, quiz: @quiz)
      redirect_to quiz_path(@quiz, question_index: 0)
    else
      flash.now[:error] = I18n.t('flash.quiz_creation_error')
      render :new
    end
  end

  def update
    answer = params[:answer]
    update_quiz_content(@question_index, answer)

    if next_question?
      redirect_to quiz_path(@quiz, question_index: @question_index + 1)
    else
      calculate_and_save_score
      redirect_to results_quiz_path(@quiz)
    end
  end

  def results
    @score = @quiz.score
  end

  private

  def set_quiz
    @quiz = Quiz.find(params[:id])
  end

  def set_question
    @question_index = params[:question_index].to_i
    @question = @quiz.content['questions'][@question_index]
  end

  def player_params
    params.require(:player).permit(:name)
  end
end
