# -*- encoding : utf-8 -*-
class CreateTransferRequests < ActiveRecord::Migration
  def change
    create_table :transfer_requests do |t|
      t.references :request_user, index: true
      t.references :target_user, index: true
      t.references :trade_back_game_week
      t.string :status, default: "pending", null: false
      t.timestamps
    end
  end
end
