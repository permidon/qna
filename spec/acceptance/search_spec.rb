require_relative 'acceptance_helper'

feature 'Search ', %q{
  In order to find the intrested thing
  As any user
  I want to be able to search
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }
  given!(:comment) { create(:comment, commentable: answer, user: user) }

  background do
    index
    visit root_path
  end

  scenario 'Query is invalid', sphinx: true do
    fill_in 'query', with: ''
    click_button 'Search'

    expect(page).to have_content 'Nothing found'

    expect(page).to have_no_content user.email
    expect(page).to have_no_content question.title
    expect(page).to have_no_content question.body
    expect(page).to have_no_content answer.body
    expect(page).to have_no_content comment.body
  end

  scenario 'Source is Everywhere', sphinx: true do
    select 'Everywhere', from: 'source'
    fill_in 'query', with: answer.body
    click_button 'Search'

    expect(page).to have_content 'in the answer to the question'
    expect(page).to have_link question.title
    expect(page).to have_content answer.body

    expect(page).to have_no_content 'Nothing found'
    expect(page).to have_no_content user.email
    expect(page).to have_no_content question.body
    expect(page).to have_no_content comment.body
  end

  scenario 'Source is Questions', sphinx: true do
    select 'Questions', from: 'source'
    fill_in 'query', with: question.title
    click_button 'Search'

    expect(page).to have_content 'in the question'
    expect(page).to have_content question.title
    expect(page).to have_content question.body

    expect(page).to have_no_content 'Nothing found'
    expect(page).to have_no_content user.email
    expect(page).to have_no_content answer.body
    expect(page).to have_no_content comment.body
  end

  scenario 'Source is Answer', sphinx: true do
    select 'Answers', from: 'source'
    fill_in 'query', with: answer.body
    click_button 'Search'

    expect(page).to have_content 'in the answer to the question'
    expect(page).to have_link question.title
    expect(page).to have_content answer.body

    expect(page).to have_no_content 'Nothing found'
    expect(page).to have_no_content user.email
    expect(page).to have_no_content question.body
    expect(page).to have_no_content comment.body
  end

  scenario 'Source is Comment', sphinx: true do
    select 'Comments', from: 'source'
    fill_in 'query', with: comment.body
    click_button 'Search'

    expect(page).to have_content 'in the comment to the answer to the question'
    expect(page).to have_link question.title
    expect(page).to have_content comment.body

    expect(page).to have_no_content 'Nothing found'
    expect(page).to have_no_content user.email
    expect(page).to have_no_content question.body
    expect(page).to have_no_content answer.body
  end

  scenario 'Source is User', sphinx: true do
    select 'Users', from: 'source'
    fill_in 'query', with: user.email
    click_button 'Search'

    expect(page).to have_content 'in the user email'
    expect(page).to have_content user.email

    expect(page).to have_no_content 'Nothing found'
    expect(page).to have_no_content question.title
    expect(page).to have_no_content question.body
    expect(page).to have_no_content answer.body
    expect(page).to have_no_content comment.body
  end
end