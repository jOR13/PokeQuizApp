class AddLevelToQuizzes < ActiveRecord::Migration[7.1]
  def change
    add_column :quizzes, :level, :string
  end
end
