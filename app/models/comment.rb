class Comment < ActiveRecord::Base
  belongs_to :user

  validates :user,
            presence: true

  validates :timestamp,
            presence: true

  validates :text,
            presence: true
end
