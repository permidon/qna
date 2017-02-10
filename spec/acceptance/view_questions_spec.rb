require 'rails_helper'

feature 'View questions', %q{
  In order to find an interesting question
  As an any user
  I want to be able to view all questions
} do

  given(:user) { create(:user) }

  scenario 'Authenticated user creates a question' do
    sign_in(user)

    visit questions_path

    expect(page).to have_content 'All questions'
  end

  scenario 'Non-authenticated user creates a question' do
    visit questions_path

    expect(page).to have_content 'All questions'
  end
end