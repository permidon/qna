require 'rails_helper'

feature 'User sign in', %q{
  In order to be able to ask a question
  As an user
  I want to be able to sign in
} do
  given(:user) { create(:user) }

  scenario 'Registered user tries to sign in' do
    sign_in(user)

    expect(page).to have_content 'Signed in successfully.'
    expect(current_path).to eq root_path
  end

  scenario 'Non-registered user tries to sign in'do
    visit new_user_session_path # or url
    fill_in 'Email', with: 'bad_user@mail.com'
    fill_in 'Password', with: '87654321'
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password'
    expect(current_path).to eq new_user_session_path
  end
end