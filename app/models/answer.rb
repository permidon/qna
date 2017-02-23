class Answer < ApplicationRecord
  has_many :attachments, as: :attachable, dependent: :destroy
  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  accepts_nested_attributes_for :attachments

  scope :helpful, -> { order(best: :desc).order(created_at: :asc) }

  def set_best_status
    self.transaction do
      self.question.answers.update_all(best: false)
      self.update!(best: true)
    end
  end
end
