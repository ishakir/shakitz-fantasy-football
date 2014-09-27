# -*- encoding : utf-8 -*-
class CreateMatchPlayers < ActiveRecord::Migration
  def change
    create_table :match_players do |t|

      # Offensive Stats
      t.integer :passing_yards, :default => 0
      t.integer :passing_tds, :default => 0
      t.integer :passing_twoptm, :default => 0
      t.integer :rushing_yards, :default => 0
      t.integer :rushing_tds, :default => 0
      t.integer :rushing_twoptm, :default => 0
      t.integer :receiving_yards, :default => 0
      t.integer :receiving_tds, :default => 0
      t.integer :receiving_twoptm, :default => 0

      t.integer :times_sacked, :default => 0
      t.integer :fumbles_lost, :default => 0
      t.integer :interceptions_thrown, :default => 0
      t.integer :field_goals_kicked, :default => 0
      t.integer :extra_points_kicked, :default => 0

      # Defensive Stats
      t.integer :sacks_made, :default => 0
      t.integer :defense_touchdowns, :default => 0
      t.integer :fumbles_won, :default => 0
      t.integer :interceptions_caught, :default => 0
      t.integer :points_conceded, :default => 0

      t.integer :points, :default => 0
      
      t.references :game_week
      t.references :nfl_player
      t.timestamps
    end
  end
end
