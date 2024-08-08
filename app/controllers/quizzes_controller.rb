# frozen_string_literal: true

class QuizzesController < ApplicationController
  before_action :set_quiz, only: %i[show update]
  before_action :set_question, only: %i[show update]

  def show; end

  def new
    @player = Player.new
  end

  def create
    @player = Player.create(player_params)
    quiz_content_generator = QuizContentGenerator.new(params[:quiz][:level])
    @quiz = Quiz.create(content: quiz_content_generator.generate, level: params[:quiz][:level])
    PlayerQuiz.create(player: @player, quiz: @quiz)
    redirect_to quiz_path(@quiz, question_index: 0)
  end

  def update
    answer = params[:answer]
    update_quiz_content(@question_index, answer)
    next_question_index = @question_index + 1

    if next_question_index < @quiz.content['questions'].length
      redirect_to quiz_path(@quiz, question_index: next_question_index)
    else
      redirect_to results_quiz_path(@quiz)
    end
  end

  def results
    @quiz = Quiz.find(params[:id])
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

  def update_quiz_content(question_index, answer)
    @quiz.content['questions'][question_index]['player_answer'] = answer
    @quiz.save
  end
end
