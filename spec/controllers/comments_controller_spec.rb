require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:author) { create(:user) }
  let(:user) { create(:user) }
  let(:admin) { create(:admin) }
  let!(:question) { create(:question, user: author) }
  let!(:answer) { create(:answer, question: question, user: author)}
  let(:commentable) { set_commentable }

  describe "POST #create" do
    context "for a question" do
      it_behaves_like "Commenting by Roles"

      def set_commentable
        question
      end

      def do_request(options = {})
        post :create, params: { question_id: question.id, format: :json }.merge(options)
      end
    end

    context "for an answer" do
      it_behaves_like "Commenting by Roles"

      def set_commentable
        answer
      end

      def do_request(options = {})
        post :create, params: { answer_id: answer.id, format: :json }.merge(options)
      end
    end
  end
end