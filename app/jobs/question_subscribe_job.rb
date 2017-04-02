class QuestionSubscribeJob < ApplicationJob
  queue_as :default

  def perform(answer)
    Subscription.where(question_id: answer.question_id).each do |subscription|
      SubscriptionMailer.new_answer(subscription.user, answer).deliver_later
    end
  end
end