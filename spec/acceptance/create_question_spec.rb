require 'rails_helper'

feature 'Create question', %q{
  In order to get an answer from community
  As an authenticated user
  I want to be able to ask questions
} do

  given(:user) { create(:user) }

  scenario 'Authenticated user creates a question' do
    sign_in(user)

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: 'Theme'
    fill_in 'Body', with: 'Lorem ipsum'
    click_on 'Create'

    expect(page).to have_content 'The question has been successfully created.'
  end

  scenario 'Non-authenticated user creates a question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end