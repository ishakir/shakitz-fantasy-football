class CreateMatchPlayers < ActiveRecord::Migration
  def change
    create_table :match_players do |t|
      t.integer :touchdown
      t.integer :nfl_player_id

      t.timestamps
    end
  end
end
