require_relative 'acceptance_helper'

feature 'Add files to question', %q{
  In order to illustrate my question
  As an author of question
  I'd like to be able to attach files to question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  background do
    sign_in(user)
    visit new_question_path
  end

  scenario 'Author adds a file when he asks a question', js: true do
    fill_in 'Title', with: question.title
    fill_in 'Body', with: question.body
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Create'

    expect(page).to have_content 'spec_helper.rb'
  end
end
