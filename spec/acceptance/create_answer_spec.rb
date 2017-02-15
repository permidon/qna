require 'rails_helper'

feature 'Create answer', %q{
  In order to give my advice
  As an authenticated user
  I want to be able to answer to questions
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create(:answer) }

  scenario 'Authenticated user creates an answer with valid attributes' do
    sign_in(user)

    visit question_path(question)
    fill_in 'Answer', with: answer.body
    click_on 'Create'

    expect(page).to have_content 'The answer has been successfully created.'
    expect(current_path).to eq question_path(question)
    within '.answers' do
      expect(page).to have_content answer.body
    end
  end

  scenario 'Authenticated user creates an answer with invalid attributes' do
    sign_in(user)

    visit question_path(question)
    fill_in 'Answer', with: nil
    click_on 'Create'

    expect(page).to have_content 'Body can\'t be blank'
    within '.answers' do
      expect(page).to have_no_content answer.body
    end
  end

  scenario 'Non-authenticated user creates an answer' do
    visit question_path(question)
    fill_in 'Answer', with: answer.body
    click_on 'Create'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
    expect(current_path).to eq new_user_session_path
  end
end