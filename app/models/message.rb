class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room

  validates :user, :room, :content, presence: true
end
