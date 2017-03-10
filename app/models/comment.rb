class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true, optional: true
  belongs_to :user

  validates :user_id, :body, presence: true
  validates :commentable_type, inclusion: { in: ['Question', 'Answer']  }
end