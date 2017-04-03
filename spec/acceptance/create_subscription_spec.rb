require_relative 'acceptance_helper'

feature 'Create subscription', %q{
  In order to know about new answer
  As an authenticated user
  I want to be able to subscribe to the question
} do

  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given!(:question) { create(:question, user: author) }

  scenario 'Authenticated user subscribes to the question', js: true do
    sign_in(user)

    visit question_path(question)
    expect(page).to have_no_link 'Unsubscribe'

    click_on 'Subscribe'

    expect(current_path).to eq question_path(question)
    expect(page).to have_link 'Unsubscribe'
  end

  scenario 'Author subscribes to the question', js: true do
    sign_in(author)

    visit question_path(question)
    expect(page).to have_no_link 'Subscribe'
    expect(page).to have_link 'Unsubscribe'
  end

  scenario 'Non-authenticated user subscribes to the question', js: true do
    visit question_path(question)

    expect(page).to have_no_link 'Subscribe'
    expect(page).to have_no_link 'Unsubscribe'
  end
end
