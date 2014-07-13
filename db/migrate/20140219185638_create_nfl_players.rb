# -*- encoding : utf-8 -*-
class CreateNflPlayers < ActiveRecord::Migration
  def change
    create_table :nfl_players do |t|
      t.string :name
      t.string :nfl_id
      t.references :nfl_team
      t.references :nfl_player_type
      t.timestamps
    end
  end
end
