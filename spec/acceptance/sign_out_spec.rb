require 'rails_helper'

feature 'User sign out', %q{
  In order to be able to end a session
  As an currently signed user
  I want to be able to sign out
} do
  given(:user) { create(:user) }

  scenario 'Signed user tries to sign out' do
    sign_in(user)

    click_on 'Sign Out'

    expect(page).to have_content 'Signed out successfully.'
    expect(current_path).to eq root_path
  end
end