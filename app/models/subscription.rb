class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :question

  validates :user_id, presence: true
  validates :user_id, uniqueness: { scope: [:user_id, :question_id] }
end
