class Answer < ApplicationRecord
  belongs_to :question, dependent: :destroy

  validates :body, :question_id, presence: true
end
