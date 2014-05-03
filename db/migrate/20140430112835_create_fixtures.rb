# -*- encoding : utf-8 -*-
class CreateFixtures < ActiveRecord::Migration
  def change
    create_table :fixtures do |t|
      t.references :home_team
      t.references :away_team
      
      t.timestamps
    end
  end
end
