class CreateTransferRequestPlayers < ActiveRecord::Migration
  def change
    create_table :transfer_request_players do |t|
      t.references :nfl_player, index: true
      t.references :transfer_request, index: true
      t.boolean :offered

      t.timestamps
    end
  end
end
