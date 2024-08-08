# frozen_string_literal: true

class CreateQuizzes < ActiveRecord::Migration[7.1]
  def change
    create_table :quizzes do |t|
      t.jsonb :content, default: {}

      t.timestamps
    end
  end
end
