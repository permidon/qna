require_relative 'acceptance_helper'

feature 'Delete question\'s file', %q{
  In order to remove not relevant file
  As an author of the question
  I want to be able to delete the file
} do

  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given!(:attachment) { create(:attachment, attachable: question) }

  scenario 'Authenticated user deletes his own question\'s file', js: true do
    sign_in(author)

    visit question_path(question)

    within '.question' do
      click_on 'Delete file'
    end

    within '.question' do
      expect(page).to have_no_link attachment.file.identifier, href: attachment.file.url
    end

  end

  scenario 'Authenticated user deletes other question\'s file' do
    sign_in(user)

    visit question_path(question)

    within '.question' do
      expect(page).to have_no_link 'Delete file'
    end
  end

  scenario 'Non-authenticated user deletes a question\'s file' do
    visit question_path(question)

    within '.question' do
      expect(page).to have_no_link 'Delete file'
    end
  end
end