# -*- encoding : utf-8 -*-
class CreateGameWeekTeamPlayers < ActiveRecord::Migration
  def change
    create_table :game_week_team_players do |t|
      t.references :game_week_team, index: true
      t.references :match_player, index: true
      t.boolean :playing
      
      t.timestamps
    end
  end
end
