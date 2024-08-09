require 'test_helper'

class PlayerTest < ActiveSupport::TestCase
  test 'should not save player without name' do
    player = Player.new
    assert_not player.save, "Saved the player without a name"
  end

  test "should save player with valid name" do
    player = Player.new(name: "Ash")
    assert player.save, "Failed to save a player with a valid name"
  end

  test 'name should be unique' do
    player1 = Player.create(name: "Ash Ketchum")
    player2 = Player.new(name: "Ash Ketchum")
    assert_not player2.save, "Saved the player with a duplicate name"
  end
end
