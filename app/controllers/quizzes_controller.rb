# frozen_string_literal: true

class QuizzesController < ApplicationController
  before_action :set_quiz, only: %i[show update results]
  before_action :set_question, only: %i[show update]
  before_action :fetch_top_players, only: :new

  def show; end

  def new
    @player = Player.new
  end

  def create
    @player = find_or_create_player
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

  def find_or_create_player
    Player.find_or_create_by(name: player_params[:name])
  end

  def build_quiz(player)
    quiz_content_generator = QuizContentGenerator.new(params[:quiz][:level], params[:quiz][:ai_mode])
    player.quizzes.build(content: quiz_content_generator.generate, level: params[:quiz][:level],
                         ai_mode: params[:quiz][:ai_mode])
  end

  def update_quiz_content(question_index, answer)
    @quiz.content['questions'][question_index]['player_answer'] = answer
    @quiz.save
  end

  def next_question?
    @question_index + 1 < @quiz.content['questions'].length
  end

  def calculate_and_save_score
    correct_answers = @quiz.content['questions'].count { |q| q['answer'].casecmp?(q['player_answer']) }
    @quiz.update(score: correct_answers)
    broadcast_top_players
  end

  def fetch_top_players
    @players = top_players
  end

  def broadcast_top_players
    ActionCable.server.broadcast 'top_players', turbo_stream.replace(
      'top-players-list',
      partial: 'players/top_players',
      locals: { players: top_players }
    )
  end

  def top_players
    Player.joins(:quizzes)
          .select('players.id, players.name, SUM(quizzes.score) AS total_score, MAX(quizzes.level) AS max_level')
          .group('players.id, players.name')
          .having('SUM(quizzes.score) > 0')
          .order('total_score DESC')
          .limit(10)
  end
end
