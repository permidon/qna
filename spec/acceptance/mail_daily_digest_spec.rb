require_relative 'acceptance_helper'

feature 'Registered users received daily digest', %q{
  In order to inform
  registered users
  about last day new questions
} do

  given(:users) { create_list(:user, 3) }
  given!(:question1) { create(:question, user: users[0]) }
  given!(:question2) { create(:question, user: users[1]) }
  given!(:question3) { create(:question, created_at: (Time.now - 1.day), user: users[2]) }

  scenario 'sends daily digest to all users', js: true do
    Sidekiq::Testing.inline! do
      DailyDigestJob.perform_now

      users.each do |user|
        open_email(user.email)
        expect(current_email).to have_link question1.title
        expect(current_email).to have_link question2.title
        expect(current_email).to have_no_link question3.title
      end

      clear_emails
    end
  end
end