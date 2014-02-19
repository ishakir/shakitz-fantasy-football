class NflPlayer < ActiveRecord::Base
  
  validates :name, presence: true
  
end
