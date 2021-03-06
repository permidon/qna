class QuestionSubscribeJob < ApplicationJob
  queue_as :default

  def perform(answer)
    # Subscription.where(question_id: answer.question_id).each do |subscription|
    answer.question.subscribers.each do |subscripber|
      SubscriptionMailer.new_answer(subscripber, answer).deliver_later
    end
  end
end