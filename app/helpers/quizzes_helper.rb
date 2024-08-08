# frozen_string_literal: true

module QuizzesHelper
  def format_question(question)
    "#{question['question']} (Options: #{question['options'].join(', ')})"
  end
end
