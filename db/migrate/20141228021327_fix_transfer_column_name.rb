class FixTransferColumnName < ActiveRecord::Migration
  def change
    rename_column :transfer_requests, :request_user_id, :offering_user_id  
  end
end
