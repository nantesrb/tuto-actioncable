class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room

  validates :user, :room, :content, presence: true

  after_create_commit :broadcast

  private

  def broadcast
    MessageBroadcastJob.perform_later(self)
  end
end
