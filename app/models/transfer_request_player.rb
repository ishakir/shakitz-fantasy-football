class TransferRequestPlayer < ActiveRecord::Base
  # TODO: validations, test etc...

  belongs_to :nfl_player
  belongs_to :transfer_request
end
