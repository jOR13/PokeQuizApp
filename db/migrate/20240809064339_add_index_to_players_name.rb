# frozen_string_literal: true

class AddIndexToPlayersName < ActiveRecord::Migration[7.1]
  def change
    add_index :players, :name, unique: true
  end
end
