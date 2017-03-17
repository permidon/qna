require_relative 'acceptance_helper'

feature 'User sign up', %q{
  In order to be start a session
  As an guest user
  I want to be able to sign up
} do
  given(:user) { create(:user) }

  scenario 'Guest user tries to sign up' do
    visit new_user_registration_path
    fill_in 'Email', with: 'newuser@test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'

    open_email('newuser@test.com')
    current_email.click_link 'Confirm my account'
    clear_emails

    expect(page).to have_content 'Your email address has been successfully confirmed.'
  end

  scenario 'Guest user tries to sign up with existing email' do
    visit new_user_registration_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password
    click_on 'Sign up'

    expect(page).to have_content 'Email has already been taken'
  end

  scenario 'Guest user tries to sign up with invalid email' do
    visit new_user_registration_path
    fill_in 'Email', with: 'blablabla'
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password
    click_on 'Sign up'

    expect(page).to have_content 'Email is invalid'
  end

  scenario 'Guest user tries to sign up with blank email field' do
    visit new_user_registration_path
    fill_in 'Email', with: nil
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password
    click_on 'Sign up'

    expect(page).to have_content 'Email can\'t be blank'
  end

  scenario 'Guest user tries to sign up with blank fields' do
    visit new_user_registration_path
    fill_in 'Email', with: nil
    fill_in 'Password', with: nil
    fill_in 'Password confirmation', with: nil
    click_on 'Sign up'

    expect(page).to have_content 'Email can\'t be blank'
    expect(page).to have_content 'Password can\'t be blank'
  end

  scenario 'Guest user tries to sign up with blank password field' do
    visit new_user_registration_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: nil
    fill_in 'Password confirmation', with: user.password
    click_on 'Sign up'

    expect(page).to have_content 'Password can\'t be blank'
  end

  scenario 'Guest user tries to sign up with mismatch password fields' do
    visit new_user_registration_path
    fill_in 'Email', with: 'newuser@test.com'
    fill_in 'Password', with: '87654321'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'

    expect(page).to have_content 'Password confirmation doesn\'t match Password'
  end

  scenario 'Guest user tries to sign up with short password fields' do
    visit new_user_registration_path
    fill_in 'Email', with: 'newuser@test.com'
    fill_in 'Password', with: '123'
    fill_in 'Password confirmation', with: '123'
    click_on 'Sign up'

    expect(page).to have_content 'Password is too short'
  end

  scenario 'Signed user tries to sign up' do
    sign_in(user)

    visit new_user_registration_path

    expect(page).to have_content 'You are already signed in'
    expect(current_path).to eq root_path
  end
end