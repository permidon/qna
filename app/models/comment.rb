class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true, optional: true
  belongs_to :user

  validates :user_id, :body, presence: true
  validates :commentable_type, inclusion: { in: ['Question', 'Answer']  }

  after_create :publish_comment

  private

  def publish_comment
    return if self.errors.any?
    ActionCable.server.broadcast(
        'comments', self
    )
  end
end