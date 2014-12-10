# -*- encoding : utf-8 -*-
require 'test_helper'

class NflPlayerTypeTest < ActiveSupport::TestCase
  test 'should get player type position' do
    position_type = NflPlayerType.find(1)
    assert_respond_to position_type, :position_type, "NflPlayerType won't respond to 'position_type' method"
  end

  test 'should get player type id' do
    position_type = NflPlayerType.find(2)
    assert_respond_to position_type, :id, "NflPlayerType won't respond to 'id' method"
  end

  test 'should fail when adding a player type with no type' do
    player_type = NflPlayerType.new
    assert !player_type.save
  end

  test 'should fail when adding a player type with empty string' do
    player_type = NflPlayerType.new
    player_type.position_type = ''
    assert !player_type.save
  end

  test 'should allow position type QB' do
    NflPlayerType.find(1).destroy!
    player_type = NflPlayerType.new
    player_type.position_type = NflPlayerType::QB
    assert player_type.save
  end

  test 'should allow position type RB' do
    NflPlayerType.find(4).destroy!
    player_type = NflPlayerType.new
    player_type.position_type = NflPlayerType::RB
    assert player_type.save
  end

  test 'should allow position type WR' do
    NflPlayerType.find(2).destroy!
    player_type = NflPlayerType.new
    player_type.position_type = NflPlayerType::WR
    assert player_type.save
  end

  test 'should allow position type TE' do
    NflPlayerType.find(3).destroy!
    player_type = NflPlayerType.new
    player_type.position_type = NflPlayerType::TE
    assert player_type.save
  end

  test 'should allow position type K' do
    NflPlayerType.find(5).destroy!
    player_type = NflPlayerType.new
    player_type.position_type = NflPlayerType::K
    assert player_type.save
  end

  test 'should allow position type D' do
    NflPlayerType.find(6).destroy!
    player_type = NflPlayerType.new
    player_type.position_type = NflPlayerType::D
    assert player_type.save
  end

  test "shouldn't allow position type MB" do
    player_type = NflPlayerType.new
    player_type.position_type = 'MB'
    assert !player_type.save
  end

  test 'player type must be unique' do
    player_type = NflPlayerType.new
    player_type.position_type = NflPlayerType::D
    assert !player_type.save
  end
end
