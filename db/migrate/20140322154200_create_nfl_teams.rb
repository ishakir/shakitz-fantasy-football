# -*- encoding : utf-8 -*-
class CreateNflTeams < ActiveRecord::Migration
  def change
    create_table :nfl_teams do |t|
      t.string :name

      t.timestamps
    end
  end
end
