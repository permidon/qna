require_relative 'acceptance_helper'

feature 'Create question', %q{
  In order to get an answer from community
  As an authenticated user
  I want to be able to ask questions
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Authenticated user creates a question with valid attributes' do
    sign_in(user)

    visit questions_path
    click_on 'Ask Question'
    fill_in 'Title', with: question.title
    fill_in 'Body', with: question.body
    click_on 'Create'

    expect(page).to have_content 'Question was successfully created.'
    expect(page).to have_content question.title
    expect(page).to have_content question.body
  end

  scenario 'Authenticated user creates a question with invalid attributes' do
    sign_in(user)

    visit questions_path
    click_on 'Ask Question'
    fill_in 'Title', with: nil
    fill_in 'Body', with: nil
    click_on 'Create'

    expect(page).to have_content 'Title can\'t be blank'
    expect(page).to have_content 'Body can\'t be blank'
    expect(page).to have_no_content question.title
    expect(page).to have_no_content question.body
  end

  scenario 'Non-authenticated user creates a question' do
    visit questions_path
    click_on 'Ask Question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
    expect(current_path).to eq new_user_session_path
  end

  context "mulitple sessions", js: true do
    scenario "question appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit questions_path
      end

      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('user') do
        click_on 'Ask Question'
        fill_in 'Title', with: question.title
        fill_in 'Body', with: question.body
        click_on 'Create'

        expect(page).to have_content 'Question was successfully created.'
        expect(page).to have_content question.title
        expect(page).to have_content question.body
      end

      Capybara.using_session('guest') do
        expect(page).to have_content question.title
      end
    end
  end
end