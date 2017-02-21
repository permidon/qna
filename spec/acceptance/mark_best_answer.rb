require_relative 'acceptance_helper'

feature 'Mark the best answer', %q{
  In order to show the answer which helped me
  As an author of question
  I want to be able to mark the best answer
} do

  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given!(:answer) { create(:answer, question: question, user: user) }


  scenario 'Author marks the answers as the best', js: true do
    sign_in(author)
    visit question_path(question)
    click_on 'Mark answer as the best'

    expect(page).to have_content 'Best Answer'
  end

  scenario 'Author removes the best answer mark', js: true do
    sign_in(author)
    visit question_path(question)
    click_on 'Mark answer as the best'
    click_on 'Remove the mark of best answer'

    expect(page).to have_no_content 'Best Answer'
  end

  scenario 'Non-author marks the answers as the best' do
    sign_in(user)
    visit question_path(question)

    expect(page).to have_no_link 'Mark answer as the best'
  end

  scenario 'Guest marks the answers as the best' do
    visit question_path(question)

    expect(page).to have_no_link 'Mark answer as the best'
  end
end