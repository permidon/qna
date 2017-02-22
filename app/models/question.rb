class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :attachments, dependent: :destroy
  belongs_to :user

  validates :title, :body, presence: true

  # def reset_best_status
  #   self.answers.each do |answer|
  #     answer.update(best: false)
  #   end
  # end
end