require_relative 'acceptance_helper'

feature 'Edit answer', %q{
  In order to fix mistake
  As an author of answer
  I'd like to be able to edit an answer
} do

  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:admin) { create(:admin) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: author) }

  context 'Author edits his own answer', js: true do
    before  do
      sign_in(author)
      visit question_path(question)
      within '.answers' do
        click_on 'Edit answer'
      end
    end
    scenario 'with valid attributes', js: true do
      within '.answers' do
        fill_in 'Answer', with: 'Test Message'
        click_on 'Save Answer'

        expect(page).to have_no_content answer.body
        expect(page).to have_content 'Test Message'
        expect(page).to have_no_selector 'textarea'
      end
    end

    scenario 'with invalid attributes', js: true do
      within '.answers' do
        fill_in 'Answer', with: nil
        click_on 'Save Answer'

        expect(page).to have_content 'Body can\'t be blank'
      end
    end
  end

  context 'Admin edits an answer', js: true do
    before  do
      sign_in(admin)
      visit question_path(question)
      within '.answers' do
        click_on 'Edit answer'
      end
    end
    scenario 'with valid attributes', js: true do
      within '.answers' do
        fill_in 'Answer', with: 'Test Message'
        click_on 'Save Answer'

        expect(page).to have_no_content answer.body
        expect(page).to have_content 'Test Message'
        expect(page).to have_no_selector 'textarea'
      end
    end

    scenario 'with invalid attributes', js: true do
      within '.answers' do
        fill_in 'Answer', with: nil
        click_on 'Save Answer'

        expect(page).to have_content 'Body can\'t be blank'
      end
    end
  end

  scenario 'Non-authenticated user edits an answer' do
    visit question_path(question)

    within '.answers' do
      expect(page).to have_no_link 'Edit answer'
    end
  end

  scenario 'Non-author edits an answer' do
    sign_in(user)

    visit question_path(question)
    within '.answers' do
      expect(page).to have_no_link 'Edit answer'
    end
  end
end
