require_relative 'acceptance_helper'

feature 'Vote for an answer', %q{
  In order to mark answer as a good/bad one
  Not as an author of answer
  I'd like to be able to vote for an answer
} do

  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given(:admin) { create(:admin) }
  given(:question) { create(:question, user: author) }
  given!(:answer1) { create(:answer, question: question, user: author) }


  context 'User is not the author of an answer' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'User marks an answer as a good one', js: true do
      within '.answer-rating' do
        click_on 'Thumbs Up'
        expect(page).to have_content 'Rating: 1'
      end
    end

    scenario 'User marks an answer as a bad one', js: true do
      within '.answer-rating' do
        click_on 'Thumbs Down'
        expect(page).to have_content 'Rating: -1'
      end
    end

    scenario 'User reset a rating of the answer', js: true do
      within '.answer-rating' do
        click_on 'Thumbs Up'
        click_on 'Reset Vote'
        expect(page).to have_content 'Rating: 0'
      end
    end
  end

  context 'Admin' do
    background do
      sign_in(admin)
      visit question_path(question)
    end

    scenario 'Admin marks an answer as a good one', js: true do
      within '.answer-rating' do
        click_on 'Thumbs Up'
        expect(page).to have_content 'Rating: 1'
      end
    end

    scenario 'Admin marks an answer as a bad one', js: true do
      within '.answer-rating' do
        click_on 'Thumbs Down'
        expect(page).to have_content 'Rating: -1'
      end
    end

    scenario 'Admin reset a rating of the answer', js: true do
      within '.answer-rating' do
        click_on 'Thumbs Up'
        click_on 'Reset Vote'
        expect(page).to have_content 'Rating: 0'
      end
    end
  end

  scenario 'Author marks an answer as a good/bad one' do
    sign_in(author)
    visit question_path(question)

    within '.answer-rating' do
      expect(page).to have_no_link 'Thumbs Up'
      expect(page).to have_no_link 'Thumbs Down'
    end
  end

  scenario 'Guest marks an answer as a good/bad one' do
    visit question_path(question)

    within '.answer-rating' do
      expect(page).to have_no_link 'Thumbs Up'
      expect(page).to have_no_link 'Thumbs Down'
    end
  end

  context "mulitple sessions", js: true do
    scenario "answer's vote appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)

        within '.answer-rating' do
          expect(page).to have_content 'Rating: 0'
        end
      end

      Capybara.using_session('user') do
        within '.answer-rating' do
          click_on 'Thumbs Up'
          expect(page).to have_content 'Rating: 1'
        end

      end

      Capybara.using_session('guest') do
        within '.answer-rating' do
          expect(page).to have_content 'Rating: 1'
        end
      end
    end
  end
end