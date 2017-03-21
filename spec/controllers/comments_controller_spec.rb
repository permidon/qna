require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:author) { create(:user) }
  let(:user) { create(:user) }
  let(:admin) { create(:admin) }
  let!(:question) { create(:question, user: author) }
  let!(:answer) { create(:answer, question: question, user: author)}

  describe "POST #create" do
    context "user comments" do
      before { sign_in(user) }

      context "a question with valid value" do
        it "makes a new comment" do
          expect {post :create, params: { question_id: question.id, comment: attributes_for(:comment), user: user, format: :json } }.to change(question.comments, :count).by(1)
        end

        it "send OK status" do
          post :create, params: { question_id: question.id, comment: attributes_for(:comment), user: user, format: :json }
          expect(response).to have_http_status(200)
        end
      end

      context "an answer with valid value" do
        it "makes a new comment" do
          expect {post :create, params: { answer_id: answer.id, comment: attributes_for(:comment), user: user, format: :json } }.to change(answer.comments, :count).by(1)
        end

        it "send OK status" do
          post :create, params: { answer_id: answer.id, comment: attributes_for(:comment), user: user, format: :json }
          expect(response).to have_http_status(200)
        end
      end

      context "a question with invalid value" do
        it "does not make a new comment" do
          expect {post :create, params: { question_id: question.id, comment: attributes_for(:invalid_comment), user: user, format: :json } }.to_not change(Comment, :count)
        end

        it "send 422 status" do
          post :create, params: { question_id: question.id, comment: attributes_for(:invalid_comment), user: user, format: :json }
          expect(response).to have_http_status(422)
        end
      end

      context "an answer with invalid value" do
        it "does not make a new comment" do
          expect {post :create, params: { answer_id: answer.id, comment: attributes_for(:invalid_comment), user: user, format: :json } }.to_not change(Comment, :count)
        end

        it "send 422 status" do
          post :create, params: { answer_id: answer.id, comment: attributes_for(:invalid_comment), user: user, format: :json }
          expect(response).to have_http_status(422)
        end
      end
    end

    context "guest comments" do
      context "a question" do
        it "does not make a new comment" do
          expect {post :create, params: { question_id: question.id, body: 'new comment', format: :json } }.to_not change(Comment, :count)
        end

        it "send 401 status" do
          post :create, params: { question_id: question.id, body: 'new comment', format: :json }
          expect(response).to have_http_status(401)
        end
      end

      context "an answer" do
        it "does not make a new comment" do
          expect {post :create, params: { answer_id: answer.id, body: 'new comment', format: :json } }.to_not change(Comment, :count)
        end

        it "send 401 status" do
          post :create, params: { answer_id: answer.id, body: 'new comment', format: :json }
          expect(response).to have_http_status(401)
        end
      end
    end

    context "author comments" do
      before { sign_in(author) }

      context "a question with valid value" do
        it "makes a new comment" do
          expect {post :create, params: { question_id: question.id, comment: attributes_for(:comment), user: author, format: :json } }.to change(question.comments, :count).by(1)
        end

        it "send OK status" do
          post :create, params: { question_id: question.id, comment: attributes_for(:comment), user: author, format: :json }
          expect(response).to have_http_status(200)
        end
      end

      context "an answer with valid value" do
        it "makes a new comment" do
          expect {post :create, params: { answer_id: answer.id, comment: attributes_for(:comment), user: author, format: :json } }.to change(answer.comments, :count).by(1)
        end

        it "send OK status" do
          post :create, params: { answer_id: answer.id, comment: attributes_for(:comment), user: author, format: :json }
          expect(response).to have_http_status(200)
        end
      end

      context "a question with invalid value" do
        it "does not make a new comment" do
          expect {post :create, params: { question_id: question.id, comment: attributes_for(:invalid_comment), user: author, format: :json } }.to_not change(Comment, :count)
        end

        it "send 422 status" do
          post :create, params: { question_id: question.id, comment: attributes_for(:invalid_comment), user: author, format: :json }
          expect(response).to have_http_status(422)
        end
      end

      context "an answer with invalid value" do
        it "does not make a new comment" do
          expect {post :create, params: { answer_id: answer.id, comment: attributes_for(:invalid_comment), user: author, format: :json } }.to_not change(Comment, :count)
        end

        it "send 422 status" do
          post :create, params: { answer_id: answer.id, comment: attributes_for(:invalid_comment), user: author, format: :json }
          expect(response).to have_http_status(422)
        end
      end
    end

    context "admin comments" do
      before { sign_in(admin) }

      context "a question with valid value" do
        it "makes a new comment" do
          expect {post :create, params: { question_id: question.id, comment: attributes_for(:comment), user: admin, format: :json } }.to change(question.comments, :count).by(1)
        end

        it "send OK status" do
          post :create, params: { question_id: question.id, comment: attributes_for(:comment), user: admin, format: :json }
          expect(response).to have_http_status(200)
        end
      end

      context "an answer with valid value" do
        it "makes a new comment" do
          expect {post :create, params: { answer_id: answer.id, comment: attributes_for(:comment), user: admin, format: :json } }.to change(answer.comments, :count).by(1)
        end

        it "send OK status" do
          post :create, params: { answer_id: answer.id, comment: attributes_for(:comment), user: admin, format: :json }
          expect(response).to have_http_status(200)
        end
      end

      context "a question with invalid value" do
        it "does not make a new comment" do
          expect {post :create, params: { question_id: question.id, comment: attributes_for(:invalid_comment), user: admin, format: :json } }.to_not change(Comment, :count)
        end

        it "send 422 status" do
          post :create, params: { question_id: question.id, comment: attributes_for(:invalid_comment), user: admin, format: :json }
          expect(response).to have_http_status(422)
        end
      end

      context "an answer with invalid value" do
        it "does not make a new comment" do
          expect {post :create, params: { answer_id: answer.id, comment: attributes_for(:invalid_comment), user: admin, format: :json } }.to_not change(Comment, :count)
        end

        it "send 422 status" do
          post :create, params: { answer_id: answer.id, comment: attributes_for(:invalid_comment), user: admin, format: :json }
          expect(response).to have_http_status(422)
        end
      end
    end
  end
end