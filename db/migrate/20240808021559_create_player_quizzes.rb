# frozen_string_literal: true

class CreatePlayerQuizzes < ActiveRecord::Migration[7.1]
  def change
    create_table :player_quizzes do |t|
      t.references :player, null: false, foreign_key: true
      t.references :quiz, null: false, foreign_key: true

      t.timestamps
    end
  end
end
