class QuestionSubscribeJob < ApplicationJob
  queue_as :default

  def perform(answer)
    User.send_new_answer(answer)
  end
end
