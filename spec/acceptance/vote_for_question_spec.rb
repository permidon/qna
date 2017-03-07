require_relative 'acceptance_helper'

feature 'Vote for a question', %q{
  In order to mark question as a good/bad one
  Not as an author of question
  I'd like to be able to vote for a question
} do

  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given!(:question) { create(:question, user: author) }

  context 'User is not the author of a question' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'User marks a question as a good one', js: true do
      within '.question-rating' do
        click_on 'Thumbs Up'
        expect(page).to have_content 'Rating: 1'
      end
    end

    scenario 'User marks a question as a bad one', js: true do
      within '.question-rating' do
        click_on 'Thumbs Down'
        expect(page).to have_content 'Rating: -1'
      end
    end

    scenario 'User reset a rating of the question', js: true do
      within '.question-rating' do
        click_on 'Thumbs Up'
        click_on 'Reset Vote'
        expect(page).to have_content 'Rating: 0'
      end
    end
  end

  scenario 'Author marks a question as a good/bad one' do
    sign_in(author)
    visit question_path(question)

    within '.question-rating' do
      expect(page).to have_no_link 'Thumbs Up'
      expect(page).to have_no_link 'Thumbs Down'
    end
  end

  scenario 'Guest marks a question as a good/bad one' do
    visit question_path(question)

    within '.question-rating' do
      expect(page).to have_no_link 'Thumbs Up'
      expect(page).to have_no_link 'Thumbs Down'
    end
  end

  context "mulitple sessions", js: true do
    scenario "question's vote appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)

        within '.question-rating' do
          expect(page).to have_content 'Rating: 0'
        end
      end

      Capybara.using_session('user') do
        within '.question-rating' do
          click_on 'Thumbs Up'
          expect(page).to have_content 'Rating: 1'
        end

      end

      Capybara.using_session('guest') do
        within '.question-rating' do
          expect(page).to have_content 'Rating: 1'
        end
      end
    end
  end
end