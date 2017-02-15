require 'rails_helper'

feature 'Delete question', %q{
  In order to remove my problem
  As an author of the question
  I want to be able to delete the question
} do

  given(:user) { create(:user) }
  given(:bad_user) { create(:user, email: 'baduser@test.com') }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:answer2) { create(:answer, question: question, user: bad_user) }

  scenario 'Authenticated user deletes his own question' do
    sign_in(user)

    visit question_path(question)
    click_on 'Delete question'

    expect(page).to have_content 'The question has been successfully deleted.'
    expect(current_path).to eq questions_path
    expect(page).to have_no_content question.title
  end

  scenario 'Authenticated user deletes other question' do
    sign_in(bad_user)

    visit question_path(question)
    expect(page).to have_no_link 'Delete question'
  end

  scenario 'Non-authenticated user deletes a question' do
    visit question_path(question)
    expect(page).to have_no_link 'Delete question'
  end
end