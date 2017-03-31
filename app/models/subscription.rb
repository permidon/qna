class Subscription < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :question, optional: true

  validates :user_id, uniqueness: { scope: [:user_id, :question_id] }
end
