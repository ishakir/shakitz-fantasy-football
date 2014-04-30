# -*- encoding : utf-8 -*-
class CreateGameWeeks < ActiveRecord::Migration
  
  def change
    create_table :game_weeks do |t|
      t.integer :number

      t.timestamps
    end
  end
  
end
