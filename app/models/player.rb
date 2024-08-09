# frozen_string_literal: true

class Player < ApplicationRecord
  has_many :player_quizzes, dependent: :destroy
  has_many :quizzes, through: :player_quizzes

  validates :name, presence: true, uniqueness: true
end
