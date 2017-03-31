class SubscriptionMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.subscription_mailer.new_answer.subject
  #
  def new_answer(user, answer)
    @greeting = "#{answer.body}, #{answer.question.title}"

    mail to: user.email
  end
end
