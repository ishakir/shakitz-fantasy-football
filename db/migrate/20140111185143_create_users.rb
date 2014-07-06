# -*- encoding : utf-8 -*-
class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :team_name
      t.string :password_hash
      t.string :password_salt
      t.timestamps
    end
  end
end
