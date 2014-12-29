class CreateWaiverWires < ActiveRecord::Migration
  def change
    create_table :waiver_wires do |t|
      t.references :user, index: true
      t.references :player_out, index: true
      t.references :player_in, index: true
      t.integer :incoming_priority
      t.references :game_week, index: true

      t.timestamps
    end
  end
end
