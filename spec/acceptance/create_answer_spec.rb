require 'rails_helper'

feature 'Create answer', %q{
  In order to give my advice
  As an authenticated user
  I want to be able to answer to questions
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create(:answer) }

  scenario 'Authenticated user creates a answer' do
    sign_in(user)

    visit question_path(question)
    fill_in 'Answer', with: answer.body
    click_on 'Create'

    expect(page).to have_content 'The answer has been successfully created.'
  end

  scenario 'Non-authenticated user creates a answer' do
    visit question_path(question)
    fill_in 'Answer', with: answer.body
    click_on 'Create'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end