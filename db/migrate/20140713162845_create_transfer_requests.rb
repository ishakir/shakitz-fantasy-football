# -*- encoding : utf-8 -*-
class CreateTransferRequests < ActiveRecord::Migration
  def change
    create_table :transfer_requests do |t|
      t.references :request_user, index: true
      t.references :target_user, index: true
      t.references :offered_player, index: true
      t.references :target_player, index: true
      t.string :status, default: "pending"
      
      t.timestamps
    end
  end
end
