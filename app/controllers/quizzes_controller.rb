# frozen_string_literal: true

class QuizzesController < ApplicationController
  before_action :set_quiz, only: %i[show update]

  def show
    @question_index = params[:question_index].to_i
    @question = @quiz.content['questions'][@question_index]
  end

  def new
    @player = Player.new
  end

  def create
    @player = Player.create(player_params)
    @quiz = Quiz.create(content: generate_quiz_content)
    PlayerQuiz.create(player: @player, quiz: @quiz)
    redirect_to quiz_path(@quiz, question_index: 0)
  end

  def update
    question_index = params[:question_index].to_i
    answer = params[:answer]

    update_quiz_content(question_index, answer)
    next_question_index = question_index + 1

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

  def player_params
    params.require(:player).permit(:name)
  end

  def generate_quiz_content
    questions = []

    3.times do
      pokemon = fetch_random_pokemon
      questions << generate_question(pokemon)
    end

    { questions: }
  end

  def fetch_random_pokemon
    response = HTTParty.get("https://pokeapi.co/api/v2/pokemon/#{rand(1..151)}")
    JSON.parse(response.body)
  end

  def generate_question(pokemon)
    {
      question: "What is the type of #{pokemon['name']}?",
      options: pokemon['types'].map { |type| type['type']['name'] },
      answer: pokemon['types'][0]['type']['name'],
      player_answer: nil
    }
  end

  def update_quiz_content(question_index, answer)
    @quiz.content['questions'][question_index]['player_answer'] = answer
    @quiz.save
  end
end
