require_relative 'acceptance_helper'

feature 'User sign up and sign in via OAuth', %q{
  In order to be start a session
  via OAuth account
  I want to be able to sign up and sign in
} do

  background { OmniAuth.config.test_mode = true }

  given!(:user) { create(:user, email: 'existed@mail.com') }

  scenario 'provider sends email, new user' do
    OmniAuth.config.add_mock(:facebook, uid: '123456789', info: {email: 'user@facebook.com'})

    visit new_user_session_path
    click_on 'Sign in with Facebook'

    expect(page).to have_content 'Successfully authenticated from Facebook account'
  end

  scenario 'provider sends email, existed user' do
    OmniAuth.config.add_mock(:facebook, uid: '123456789', info: {email: 'existed@mail.com'})

    visit new_user_session_path
    click_on 'Sign in with Facebook'

    expect(page).to have_content 'Successfully authenticated from Facebook account'
  end

  scenario 'provider does not send email, new user' do
    OmniAuth.config.add_mock(:twitter, uid: '123456789')

    visit new_user_session_path
    click_on 'Sign in with Twitter'

    fill_in 'auth[info][email]', with: 'user@twitter.com'
    click_on 'Confirm'

    open_email 'user@twitter.com'
    current_email.click_link 'Confirm my account'
    clear_emails

    expect(page).to have_content 'Your email address has been successfully confirmed'

    click_on 'Sign in with Twitter'

    expect(page).to have_content 'Successfully authenticated from Twitter account'
  end

  scenario 'provider does not send email, invalid email' do
    OmniAuth.config.add_mock(:twitter, uid: '123456789')

    visit new_user_session_path
    click_on 'Sign in with Twitter'

    click_on 'Confirm'

    expect(page).to have_content 'Please confirm your email address'
  end

  scenario 'provider does not send email, existed user' do

    OmniAuth.config.add_mock(:twitter, uid: '123456789')

    visit new_user_session_path
    click_on 'Sign in with Twitter'

    fill_in 'auth[info][email]', with: 'existed@mail.com'
    click_on 'Confirm'

    expect(page).to have_content 'Successfully authenticated from Twitter account'
  end

  scenario 'provider does not send email, unconfirmed email' do
    OmniAuth.config.add_mock(:twitter, uid: '123456789')

    visit new_user_session_path
    click_on 'Sign in with Twitter'

    fill_in 'auth[info][email]', with: 'user@twitter.com'
    click_on 'Confirm'

    expect(page).to have_content 'Resend confirmation instructions'

    visit new_user_session_path

    click_on 'Sign in with Twitter'

    expect(page).to have_content 'Resend confirmation instructions'
    expect(page).to have_no_content 'Successfully authenticated from Twitter account'
  end
end