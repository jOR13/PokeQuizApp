# frozen_string_literal: true

require 'test_helper'

class PlayerTest < ActiveSupport::TestCase
  test 'should be valid with valid attributes' do
    player = Player.new(name: 'Test Player')
    assert player.valid?
  end

  test 'should not be valid without a name' do
    player = Player.new(name: nil)
    assert_not player.valid?
  end
end
