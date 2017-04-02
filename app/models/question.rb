class Question < ApplicationRecord
  include Attachable
  include Votable
  include Commentable

  has_many :answers, dependent: :destroy
  belongs_to :user
  has_many :subscriptions, dependent: :destroy
  has_many :subscribers, through: :subscriptions, source: :user

  validates :title, :body, :user_id, presence: true

  after_create :subscribe
  after_create :publish_question

  private

  def publish_question
    return if self.errors.any?
    ActionCable.server.broadcast(
        'questions',
        ApplicationController.render(
            partial: 'questions/short_question',
            locals: { question: self }
        )
    )
  end

  def subscribe
    subscriptions.create(user: self.user)
  end
end