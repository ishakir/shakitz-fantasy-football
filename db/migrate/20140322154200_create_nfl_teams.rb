class CreateNflTeams < ActiveRecord::Migration
  def change
    create_table :nfl_teams do |t|
      t.string :name

      t.timestamps
    end
    
    alter_table :nfl_players do |t|
      t.references :nfl_team
      
    end
  end
end
