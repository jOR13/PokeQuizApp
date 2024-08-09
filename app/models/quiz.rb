# frozen_string_literal: true

class Quiz < ApplicationRecord
  has_many :player_quizzes, dependent: :destroy
  has_many :players, through: :player_quizzes

  validates :level, inclusion: { in: %w[easy medium hard], message: I18n.t('errors.messages.invalid_level') }

  attr_accessor :ai_mode
end
