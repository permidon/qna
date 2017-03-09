require_relative 'acceptance_helper'

feature 'Answer\'s appearing', %q{
  In order to avoid answer\'s duplication
  I want to inform all users
  About new question\'s answer
} do

  given(:user1) { create(:user) }
  given(:user2) { create(:user) }
  given(:author) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given!(:answer) { create(:answer) }

  context "mulitple sessions", js: true do
    scenario "new answer appears on another user's page" do
      Capybara.using_session('user1') do
        sign_in(user1)
        visit question_path(question)
      end

      Capybara.using_session('user2') do
        sign_in(user2)
        visit question_path(question)
      end

      Capybara.using_session('author') do
        sign_in(author)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user1') do
        fill_in 'Your Answer', with: answer.body
        attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
        click_on 'Post Your Answer'

        expect(current_path).to eq question_path(question)
        within '.answers' do
          expect(page).to have_content answer.body
          expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
          expect(page).to have_link 'Delete file'
          expect(page).to have_no_link 'Mark answer as the best'
          expect(page).to have_no_link 'Thumbs Down'
          expect(page).to have_no_link 'Thumbs Up'
          expect(page).to have_link 'Add Comment'
        end
      end


      Capybara.using_session('user2') do
        within '.answers' do
          expect(page).to have_content answer.body
          expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
          expect(page).to have_no_link 'Delete file'
          expect(page).to have_no_link 'Mark answer as the best'
          expect(page).to have_link 'Thumbs Down'
          expect(page).to have_link 'Thumbs Up'
          expect(page).to have_link 'Add Comment'
        end
      end

      Capybara.using_session('author') do
        within '.answers' do
          expect(page).to have_content answer.body
          expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
          expect(page).to have_no_link 'Delete file'
          expect(page).to have_link 'Mark answer as the best'
          expect(page).to have_link 'Thumbs Down'
          expect(page).to have_link 'Thumbs Up'
          expect(page).to have_link 'Add Comment'
        end
      end

      Capybara.using_session('guest') do
        within '.answers' do
          expect(page).to have_content answer.body
          expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
          expect(page).to have_no_link 'Delete file'
          expect(page).to have_no_link 'Mark answer as the best'
          expect(page).to have_no_link 'Thumbs Down'
          expect(page).to have_no_link 'Thumbs Up'
          expect(page).to have_no_link 'Add Comment'
        end
      end
    end
  end
end
