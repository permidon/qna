require_relative 'acceptance_helper'

feature 'Delete answer\'s files', %q{
  In order to remove not relevant file
  As an author of the question
  I want to be able to delete the file
} do

  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: author) }
  given!(:attachment) { create(:attachment, attachable: answer) }

  scenario 'Authenticated user deletes his own answer\'s file', js: true do
    sign_in(author)

    visit question_path(question)

    within '.answers' do
      click_on 'Delete file'
    end

    within '.answers' do
      expect(page).to have_no_link attachment.file.identifier, href: attachment.file.url
    end

  end

  scenario 'Authenticated user deletes other answer\'s file' do
    sign_in(user)

    visit question_path(question)

    within '.answers' do
      expect(page).to have_no_link 'Delete file'
    end
  end

  scenario 'Non-authenticated user deletes a answer\'s file' do
    visit question_path(question)

    within '.answers' do
      expect(page).to have_no_link 'Delete file'
    end
  end
end