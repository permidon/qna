require 'rails_helper'

RSpec.describe VotesController, type: :controller do
  let!(:author) { create(:user) }
  let(:user) { create(:user) }
  let(:admin) { create(:admin) }
  let!(:question) { create(:question, user: author) }
  let!(:answer) { create(:answer, question: question, user: author)}
  let(:votable) { set_votable }

  describe "POST #create" do
    context "for a question" do
      context "user votes" do
        before { sign_in(user) }

        it_behaves_like "Create Vote"
      end

      context "admin votes" do
        before { sign_in(admin) }

        it_behaves_like "Create Vote"
      end

      context "guest votes" do
        it_behaves_like "Not create Vote"
      end

      context "author votes" do
        before { sign_in(author) }

        it_behaves_like "Not create Vote"
      end

      def set_votable
        question
      end

      def do_request(options = {})
        post :create, params: { question_id: question.id, format: :json }.merge(options)
      end
    end

    context "for an answer" do
      context "user votes" do
        before { sign_in(user) }

        it_behaves_like "Create Vote"
      end

      context "admin votes" do
        before { sign_in(admin) }

        it_behaves_like "Create Vote"
      end

      context "guest votes" do
        it_behaves_like "Not create Vote"
      end

      context "author votes" do
        before { sign_in(author) }

        it_behaves_like "Not create Vote"
      end

      def set_votable
        answer
      end

      def do_request(options = {})
        post :create, params: { answer_id: answer.id, format: :json }.merge(options)
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:answer_vote){ create(:vote, votable: answer, user: user) }
    let!(:question_vote){ create(:vote, votable: question, user: user) }

    context "for a question" do
      context "user cancels his vote" do
        before { sign_in(user) }

        it_behaves_like "Delete Vote"
      end

      context "admin cancels his vote" do
        before { sign_in(admin) }

        it_behaves_like "Delete Vote"
      end

      context "guest cancels vote" do
        it_behaves_like "Not delete Vote"
      end

      context "author cancels vote" do
        before { sign_in(author) }

        it_behaves_like "Not delete Vote"
      end

      def set_votable
        question
      end

      def do_request(options = {})
        delete :destroy, params: { id: question_vote.id, format: :js }.merge(options)
      end
    end

    context "for an answer" do
      context "user cancels his vote" do
        before { sign_in(user) }

        it_behaves_like "Delete Vote"
      end

      context "admin cancels his vote" do
        before { sign_in(admin) }

        it_behaves_like "Delete Vote"
      end

      context "guest cancels vote" do
        it_behaves_like "Not delete Vote"
      end

      context "author cancels vote" do
        before { sign_in(author) }

        it_behaves_like "Not delete Vote"
      end

      def set_votable
        answer
      end

      def do_request(options = {})
        delete :destroy, params: { id: answer_vote.id, format: :js }.merge(options)
      end
    end
  end
end