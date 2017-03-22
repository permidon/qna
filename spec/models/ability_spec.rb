require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }
    it { should be_able_to :read, Attachment }
    it { should be_able_to :read, Vote }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:other) { create :user }
    let(:user_list) { create_list(:user, 3) }

    let(:user_question) { create :question, user: user }
    let(:other_question) { create :question, user: other }

    let(:user_answer) { create :answer, question: user_question, user: user }
    let(:other_answer) { create :answer, question: user_question, user: other }
    let(:unacceptable_user_answer) { create :answer, question: other_question, user: user }
    let(:unacceptable_other_answer) { create :answer, question: other_question, user: other }

    let(:user_question_attachment) { create :attachment, attachable: user_question }
    let(:user_answer_attachment) { create :attachment, attachable: user_answer }
    let(:other_question_attachment) { create :attachment, attachable: other_question }
    let(:other_answer_attachment) { create :attachment, attachable: other_answer }

    let(:user_question_comment) { create :comment, commentable: user_question, user: user }
    let(:user_answer_comment) { create :comment, commentable: user_answer, user: user }
    let(:other_question_comment) { create :comment, commentable: other_question, user: user }
    let(:other_answer_comment) { create :comment, commentable: other_answer, user: user }

    let(:user_question_vote) { create :vote, votable: user_question, user: user }
    let(:user_answer_vote) { create :vote, votable: user_answer, user: user }
    let(:other_question_vote) { create :vote, votable: other_question, user: user }
    let(:other_answer_vote) { create :vote, votable: other_answer, user: user }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    context 'Question' do
      it { should be_able_to :create, Question }
      it { should be_able_to :destroy, user_question }
      it { should be_able_to :update, user_question }

      it { should_not be_able_to :destroy, other_question }
      it { should_not be_able_to :update, other_question }
    end

    context 'Answer' do
      it { should be_able_to :create, Answer }
      it { should be_able_to :destroy, user_answer }
      it { should be_able_to :update, user_answer }
      it { should be_able_to :mark_best, user_answer }
      it { should be_able_to :mark_best, other_answer }

      it { should_not be_able_to :destroy, other_answer }
      it { should_not be_able_to :update, other_answer }
      it { should_not be_able_to :mark_best, unacceptable_user_answer }
      it { should_not be_able_to :mark_best, unacceptable_other_answer }
    end

    context 'Attachment' do
      it { should be_able_to :destroy, user_question_attachment }
      it { should be_able_to :destroy, user_answer_attachment }

      it { should_not be_able_to :destroy, other_question_attachment }
      it { should_not be_able_to :destroy, other_answer_attachment }
    end

    context 'Comment' do
      it { should be_able_to :create, user_question_comment }
      it { should be_able_to :create, user_answer_comment }
      it { should be_able_to :create, other_question_comment }
      it { should be_able_to :create, other_answer_comment }
    end

    context 'Vote' do
      it { should be_able_to :create, other_question_vote }
      it { should be_able_to :create, other_answer_vote }
      it { should be_able_to :destroy, other_question_vote }
      it { should be_able_to :destroy, other_answer_vote }

      it { should_not be_able_to :create, user_question_vote }
      it { should_not be_able_to :create, user_answer_vote }
    end

    context 'API' do
      it { should be_able_to :me, user }
      it { should be_able_to :all_but_me, user }

      it { should_not be_able_to :me, other }
      it { should_not be_able_to :all_but_me, other }
    end
  end
end
