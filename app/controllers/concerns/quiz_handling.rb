# frozen_string_literal: true

module QuizHandling
  extend ActiveSupport::Concern

  private

  def build_quiz(player)
    quiz_content_generator = QuizContentGeneratorService.new(params[:quiz][:level], params[:quiz][:ai_mode])
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
end
