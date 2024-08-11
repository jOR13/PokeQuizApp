# frozen_string_literal: true

require 'test_helper'

class PlayerTest < ActiveSupport::TestCase
  def setup
    @player = Player.new(name: 'Test Player')
  end

  test 'valid player' do
    assert @player.valid?
  end

  test 'invalid without name' do
    @player.name = nil
    assert_not @player.valid?
    assert_not_nil @player.errors[:name]
  end

  test 'invalid with duplicate name' do
    duplicate_player = @player.dup
    @player.save
    assert_not duplicate_player.valid?
    assert_not_nil duplicate_player.errors[:name]
  end

  test 'has many player_quizzes' do
    assert_respond_to @player, :player_quizzes
    assert_equal [], @player.player_quizzes
  end

  test 'has many quizzes through player_quizzes' do
    assert_respond_to @player, :quizzes
    assert_equal [], @player.quizzes
  end
end
