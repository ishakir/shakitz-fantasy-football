# -*- encoding : utf-8 -*-
class CreateGameWeekTeams < ActiveRecord::Migration
  def change
    create_table :game_week_teams do |t|
      t.references :user, index: true
      t.references :game_week

      t.timestamps
    end
  end
end
