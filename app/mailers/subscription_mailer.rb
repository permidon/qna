class SubscriptionMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.subscription_mailer.new_answer.subject
  #
  def new_answer(user, answer)
    @greeting = 'Hi'
    @answer = answer

    mail to: user.email
  end
end
