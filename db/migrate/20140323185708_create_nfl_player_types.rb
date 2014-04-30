# -*- encoding : utf-8 -*-
class CreateNflPlayerTypes < ActiveRecord::Migration
  def change
    create_table :nfl_player_types do |t|
      t.string :position_type

      t.timestamps
    end
  end
end
