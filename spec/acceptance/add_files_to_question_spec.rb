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
    fill_in 'Title', with: question.title
    fill_in 'Body', with: question.body
  end

  scenario 'Author adds a file when he asks a question', js: true do
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Create'

    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
  end

  scenario 'Author adds files when he asks a question', js: true do
    click_on 'add another file'

    inputs = all('input[type="file"]')

    inputs[0].set("#{Rails.root}/spec/rails_helper.rb")
    inputs[1].set("#{Rails.root}/spec/spec_helper.rb")

    click_on 'Create'

    expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/1/rails_helper.rb'
    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/2/spec_helper.rb'
  end
end
