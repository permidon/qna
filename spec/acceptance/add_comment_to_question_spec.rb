require_relative 'acceptance_helper'

feature 'Add comment to a question', %q{
  In order to understand question
  as registred user
  I'd like to be able to comment a question
} do

  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: author) }

  scenario 'Author comments his own question', js: true do
    sign_in(author)
    visit question_path(question)

    within '.question' do
      click_on 'Add Comment'
    end

    within '.question .new-comment' do
      fill_in 'Your Comment', with: 'New Comment'
      click_on 'Save Comment'

      expect(page).to have_no_selector 'textarea'
    end

    within '.question .comments' do
      expect(page).to have_content 'New Comment'
    end
  end

  scenario 'User comments a question', js: true do
    sign_in(user)
    visit question_path(question)

    within '.question' do
      click_on 'Add Comment'
    end

    within '.question .new-comment' do
      fill_in 'Your Comment', with: 'New Comment'
      click_on 'Save Comment'

      expect(page).to have_no_selector 'textarea'
    end

    within '.question .comments' do
      expect(page).to have_content 'New Comment'
    end
  end

  scenario 'Guest comments a question', js: true do
    visit question_path(question)

    within '.question' do
      expect(page).to have_no_link 'Add Comment'
    end
  end
end
