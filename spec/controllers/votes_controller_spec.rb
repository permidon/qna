require 'rails_helper'

RSpec.describe VotesController, type: :controller do
  let(:author) { create(:user) }
  let(:user) { create(:user) }
  let!(:question) { create(:question, user: author) }
  let!(:answer) { create(:answer, question: question, user: author)}

  describe "POST #create" do
    context "user votes" do
      before { sign_in(user) }

      context "for a question with valid value" do
        it "changes Votes value" do
          expect {post :create, params: { question_id: question.id, value: 1, format: :json } }.to change(question.votes, :count).by(1)
        end

        it "send OK status" do
          post :create, params: { question_id: question.id, value: 1, format: :json }
          expect(response).to have_http_status(200)
        end
      end

      context "for an answer with valid value" do
        it "changes Votes value" do
          expect {post :create, params: { answer_id: answer.id, value: 1, format: :json } }.to change(answer.votes, :count).by(1)
        end

        it "send OK status" do
          post :create, params: { answer_id: answer.id, value: 1, format: :json }
          expect(response).to have_http_status(200)
        end
      end

      context "for a question with invalid value" do
        it "does not change Votes value" do
          expect {post :create, params: { question_id: question.id, value: 2, format: :json } }.to_not change(Vote, :count)
        end

        it "send 422 status" do
          post :create, params: { question_id: question.id, value: 2, format: :json }
          expect(response).to have_http_status(422)
        end
      end

      context "for an answer with invalid value" do
        it "does not change Votes value" do
          expect {post :create, params: { answer_id: answer.id, value: 2, format: :json } }.to_not change(Vote, :count)
        end

        it "send 422 status" do
          post :create, params: { answer_id: answer.id, value: 2, format: :json }
          expect(response).to have_http_status(422)
        end
      end
    end

    context "guest votes" do
      context "for a question" do
        it "does not change Votes value" do
          expect {post :create, params: { question_id: question.id, value: 1, format: :json } }.to_not change(Vote, :count)
        end

        it "send 401 status" do
          post :create, params: { question_id: question.id, value: 1, format: :json }
          expect(response).to have_http_status(401)
        end
      end

      context "for an answer" do
        it "does not change Votes value" do
          expect {post :create, params: { answer_id: answer.id, value: 1, format: :json } }.to_not change(Vote, :count)
        end

        it "send 401 status" do
          post :create, params: { answer_id: answer.id, value: 1, format: :json }
          expect(response).to have_http_status(401)
        end
      end
    end

    context "author votes" do
      before { sign_in(author) }

      context "for a question" do
        it "does not change Votes value" do
          expect {post :create, params: { question_id: question.id, value: 1, format: :json } }.to_not change(Vote, :count)
        end

        it "send 403 status" do
          post :create, params: { question_id: question.id, value: 1, format: :json }
          expect(response).to have_http_status(302)
        end
      end

      context "for an answer" do
        it "does not change Votes value" do
          expect {post :create, params: { answer_id: answer.id, value: 1, format: :json } }.to_not change(Vote, :count)
        end

        it "send 403 status" do
          post :create, params: { answer_id: answer.id, value: 1, format: :json }
          expect(response).to have_http_status(302)
        end
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:answer_vote){ create(:vote, votable: answer, user: user) }
    let!(:question_vote){ create(:vote, votable: question, user: user) }

    context "user cancels his vote" do
      before { sign_in (user) }


      context "for an answer" do
        it "destroys a vote" do
          expect(answer.rating).to eq 1
          expect{ delete :destroy, params: { id: answer_vote.id, format: :js } }.to change(Vote, :count).by(-1)
          answer.reload
          expect(answer.rating).to eq 0
        end

        it "send OK status" do
          delete :destroy, params: { id: answer_vote.id, format: :js }
          expect(response).to have_http_status(200)
        end
      end

      context "for a question" do
        it "destroys a vote" do
          expect(question.rating).to eq 1
          expect{ delete :destroy, params: { id: question_vote.id, format: :js } }.to change(Vote, :count).by(-1)
          question.reload
          expect(question.rating).to eq 0
        end

        it "send OK status" do
          delete :destroy, params: { id: question_vote.id, format: :js }
          expect(response).to have_http_status(200)
        end
      end

    end

    context "guest cancels vote" do
      context "for a question" do
        it "does not destroy vote" do
          expect(question.rating).to eq 1
          expect{ delete :destroy, params: { id: question_vote.id, format: :js } }.to_not change(Vote, :count)
          question.reload
          expect(question.rating).to eq 1
        end

        it "send 401 status" do
          delete :destroy, params: { id: question_vote.id, format: :js }
          expect(response).to have_http_status(401)
        end
      end

      context "for an answer" do
        it "does not destroy vote" do
          expect(answer.rating).to eq 1
          expect{ delete :destroy, params: { id: answer_vote.id, format: :js } }.to_not change(Vote, :count)
          answer.reload
          expect(answer.rating).to eq 1
        end

        it "send 401 status" do
          delete :destroy, params: { id: answer_vote.id, format: :js }
          expect(response).to have_http_status(401)
        end
      end
    end

    context "author cancels vote" do
      before { sign_in(author) }

      context "for a question" do
        it "does not destroy vote" do
          expect(question.rating).to eq 1
          expect{ delete :destroy, params: { id: question_vote.id, format: :js } }.to_not change(Vote, :count)
          question.reload
          expect(question.rating).to eq 1
        end

        it "send 403 status" do
          delete :destroy, params: { id: question_vote.id, format: :js }
          expect(response).to have_http_status(302)
        end
      end

      context "for an answer" do
        it "does not destroy vote" do
          expect(question.rating).to eq 1
          expect{ delete :destroy, params: { id: answer_vote.id, format: :js } }.to_not change(Vote, :count)
          answer.reload
          expect(answer.rating).to eq 1
        end

        it "send 403 status" do
          delete :destroy, params: { id: answer_vote.id, format: :js }
          expect(response).to have_http_status(302)
        end
      end
    end
  end
end