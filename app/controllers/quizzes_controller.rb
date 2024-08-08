# frozen_string_literal: true

class QuizzesController < ApplicationController
  before_action :set_quiz, only: %i[show update results]
  before_action :set_question, only: %i[show update]

  def show; end

  def new
    @player = Player.new
  end

  def create
    @player = Player.create(player_params)
    @quiz = build_quiz(@player)
    if @quiz.save
      PlayerQuiz.create(player: @player, quiz: @quiz)
      redirect_to quiz_path(@quiz, question_index: 0)
    else
      render :new
    end
  end

  def update
    answer = params[:answer]
    update_quiz_content(@question_index, answer)
    next_question_index = @question_index + 1

    if next_question_index < @quiz.content['questions'].length
      redirect_to quiz_path(@quiz, question_index: next_question_index)
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

  def build_quiz(_player)
    ai_mode = params[:quiz][:ai_mode] == '1'
    quiz_content_generator = QuizContentGenerator.new(params[:quiz][:level], ai_mode)
    Quiz.new(content: quiz_content_generator.generate, level: params[:quiz][:level], ai_mode:)
  end

  def update_quiz_content(question_index, answer)
    @quiz.content['questions'][question_index]['player_answer'] = answer
    @quiz.save
  end

  def calculate_and_save_score
    correct_answers = @quiz.content['questions'].count do |question|
      question['answer'] == question['player_answer']
    end
    @quiz.update(score: correct_answers)
  end
end
