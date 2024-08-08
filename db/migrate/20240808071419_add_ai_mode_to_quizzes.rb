# frozen_string_literal: true

class AddAiModeToQuizzes < ActiveRecord::Migration[7.1]
  def change
    add_column :quizzes, :ai_mode, :boolean, default: false, null: false
  end
end
