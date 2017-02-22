require_relative 'acceptance_helper'

feature 'Create answer', %q{
  In order to give my advice
  As an authenticated user
  I want to be able to answer to questions
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer) }

  scenario 'Authenticated user creates an answer with valid attributes', js: true do
    sign_in(user)

    visit question_path(question)

    fill_in 'Your Answer', with: answer.body
    click_on 'Post Your Answer'

    expect(current_path).to eq question_path(question)
    within '.answers' do
      expect(page).to have_content answer.body
    end
  end

  scenario 'Authenticated user creates an answer with invalid attributes', js: true do
    sign_in(user)

    visit question_path(question)
    fill_in 'Your Answer', with: nil
    click_on 'Post Your Answer'

    expect(current_path).to eq question_path(question)
    expect(page).to have_content 'Body can\'t be blank'
    within '.answers' do
      expect(page).to have_no_content answer.body
    end
  end
end
