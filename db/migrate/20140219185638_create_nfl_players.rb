class CreateNflPlayers < ActiveRecord::Migration
  def change
    create_table :nfl_players do |t|
      t.string :name

      t.timestamps
    end
  end
end
