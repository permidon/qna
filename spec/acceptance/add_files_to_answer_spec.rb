require_relative 'acceptance_helper'

feature 'Add files to answer', %q{
  In order to illustrate my answer
  As an author of answer
  I'd like to be able to attach files to answer
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'Author adds a file when he answers ', js: true do
    fill_in 'Your Answer', with: answer.body
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Post Your Answer'

    within '.answers' do
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    end
  end
end
