require_relative 'acceptance_helper'

feature 'Edit question', %q{
  In order to fix mistake
  As an author of question
  I'd like to be able to edit a question
} do

  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: author) }

  context 'Author edits his own question', js: true do
    before  do
      sign_in(author)
      visit question_path(question)
      within '.question' do
        click_on 'Edit question'
      end
    end
    scenario 'with valid attributes', js: true do
      within '.question' do
        fill_in 'Title', with: "New Title"
        fill_in 'Question', with: "New Body"
        click_on 'Save Question'

        expect(page).to have_no_content question.title
        expect(page).to have_no_content question.body
        expect(page).to have_content 'New Title'
        expect(page).to have_content 'New Body'
        expect(page).to have_no_selector 'textarea'
      end
    end

    scenario 'with invalid attributes', js: true do
      within '.question' do
        fill_in 'Title', with: nil
        fill_in 'Question', with: nil
        click_on 'Save Question'

        expect(page).to have_content 'Title can\'t be blank'
        expect(page).to have_content 'Body can\'t be blank'
      end
    end
  end

  scenario 'Non-authenticated user edits a question' do
    visit question_path(question)

    within '.question' do
      expect(page).to have_no_link 'Edit question'
    end
  end

  scenario 'Non-author edits a question' do
    sign_in(user)

    visit question_path(question)
    within '.question' do
      expect(page).to have_no_link 'Edit question'
    end
  end
end