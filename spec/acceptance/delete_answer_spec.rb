require_relative 'acceptance_helper'

feature 'Delete answer', %q{
  In order to remove my opinion
  As an author of the answer
  I want to be able to delete the answer
} do

  given(:user) { create(:user) }
  given(:bad_user) { create(:user, email: 'baduser@test.com') }
  given(:admin) { create(:admin) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Authenticated user deletes his own answer', js: true do
    sign_in(user)

    visit question_path(question)
    click_on 'Delete answer'

    expect(current_path).to eq question_path(question)
    expect(page).to have_no_content answer.body
  end

  scenario 'Admin deletes deletes other answer', js: true do
    sign_in(admin)

    visit question_path(question)
    click_on 'Delete answer'

    expect(current_path).to eq question_path(question)
    expect(page).to have_no_content answer.body
  end

  scenario 'Authenticated user deletes other answer' do
    sign_in(bad_user)

    visit question_path(question)
    expect(page).to have_no_link 'Delete answer'
  end

  scenario 'Non-authenticated user deletes a answer' do
    visit question_path(question)
    expect(page).to have_no_link 'Delete answer'
  end
end