require_relative 'acceptance_helper'

feature 'Subscribed users received new answer', %q{
  In order to inform all subscribed users about new answer
} do

  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given!(:answer) { create(:answer) }

  scenario 'sends new answer to question subscribers', js: true do
    Sidekiq::Testing.inline! do
      sign_in(user)

      visit question_path(question)

      click_on 'Subscribe'

      fill_in 'Your Answer', with: answer.body
      click_on 'Post Your Answer'

      sleep(1)

      open_email(user.email)
      expect(current_email).to have_content answer.body

      open_email(author.email)
      expect(current_email).to have_content answer.body

      clear_emails
    end
  end
end