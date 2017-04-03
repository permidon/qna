class Answer < ApplicationRecord
  include Attachable
  include Votable
  include Commentable

  belongs_to :question
  belongs_to :user

  validates :body, :user_id, presence: true

  after_create :publish_answer
  after_create :mail_answer

  scope :helpful, -> { order(best: :desc).order(created_at: :asc) }

  def set_best_status
    self.transaction do
      self.question.answers.update_all(best: false)
      self.update!(best: true)
    end
  end

  private

  def publish_answer
    return if self.errors.any?

    attachments = []
    self.attachments.each do |a|
      attachment = {}
      attachment[:id] = a.id
      attachment[:url] = a.file.url
      attachment[:name] = a.file.identifier
      attachments << attachment
    end

    ActionCable.server.broadcast(
        "answers-question-#{self.question.id}",
        answer: self,
        attachments: attachments,
        question: self.question
    )
  end

  def mail_answer
    QuestionSubscribeJob.perform_later(self)
  end
end
