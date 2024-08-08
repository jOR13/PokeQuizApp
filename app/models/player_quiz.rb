# frozen_string_literal: true

class PlayerQuiz < ApplicationRecord
  belongs_to :player
  belongs_to :quiz
end
