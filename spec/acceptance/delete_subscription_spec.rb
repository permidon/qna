require_relative 'acceptance_helper'

feature 'Create subscription', %q{
  In order to stop to be informed about new answer
  As an authenticated user
  I want to be able to unsubscribe to the question
} do

  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given!(:subscription) { create(:subscription, user: user, question: question) }

  scenario 'Authenticated user unsubscribes to the question', js: true do
    sign_in(user)

    visit question_path(question)
    expect(page).to have_no_link 'Subscribe'

    click_on 'Unsubscribe'

    expect(current_path).to eq question_path(question)
    expect(page).to have_link 'Subscribe'
  end

  scenario 'Author unsubscribes to the question', js: true do
    sign_in(author)

    visit question_path(question)
    expect(page).to have_no_link 'Subscribe'

    click_on 'Unsubscribe'

    expect(current_path).to eq question_path(question)
    expect(page).to have_link 'Subscribe'
  end

  scenario 'Non-authenticated user unsubscribes to the question', js: true do
    visit question_path(question)

    expect(page).to have_no_link 'Subscribe'
    expect(page).to have_no_link 'Unsubscribe'
  end
end
