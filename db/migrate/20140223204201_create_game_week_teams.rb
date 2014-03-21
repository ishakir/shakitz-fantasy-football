class CreateGameWeekTeams < ActiveRecord::Migration
  def change
    create_table :game_week_teams do |t|
      t.integer :gameweek
      t.references :user, index: true

      t.timestamps
    end
  end
end
