# frozen_string_literal: true

class Quiz < ApplicationRecord
  has_many :player_quizzes, dependent: :destroy
  has_many :players, through: :player_quizzes

  validates :level, presence: true
  attr_accessor :ai_mode
end
