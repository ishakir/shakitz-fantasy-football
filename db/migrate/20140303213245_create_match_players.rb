class CreateMatchPlayers < ActiveRecord::Migration
  def change
    create_table :match_players do |t|
      t.integer :passing_yards, :default => 0
      t.integer :passing_td, :default => 0
      t.integer :rushing_yards, :default => 0
      t.integer :rushing_td, :default => 0
      t.integer :point_conversion, :default => 0
      t.integer :offensive_sack, :default => 0
      t.integer :offensive_safety, :default => 0
      t.integer :fumble, :default => 0
      t.integer :qb_pick, :default => 0
      t.integer :defensive_sack, :default => 0
      t.integer :defensive_td, :default => 0
      t.integer :defensive_safety, :default => 0
      t.integer :turnover, :default => 0
      t.integer :defensive_yards, :default => 0
      t.integer :defensive_points, :default => 0
      t.integer :kicker_points, :default => 0
      t.integer :blocked_kicks, :default => 0
      
      t.references :game_week
      t.references :nfl_player
      t.timestamps
    end
  end
end
