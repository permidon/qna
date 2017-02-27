class Answer < ApplicationRecord
  has_many :attachments, as: :attachable, dependent: :destroy
  has_many :votes, as: :votable, dependent: :destroy
  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  scope :helpful, -> { order(best: :desc).order(created_at: :asc) }

  def set_best_status
    self.transaction do
      self.question.answers.update_all(best: false)
      self.update!(best: true)
    end
  end
end
