require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }

  describe 'POST #create' do
    context 'user is signed in' do
      sign_in_user
      it 'assigns the requested question to @question' do
        post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
        expect(assigns(:question)).to eq question
      end

      context 'with valid attributes' do
        it 'saves the new answer in the database' do
          expect { post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js } }.to change(question.answers, :count).by(1)
        end

        it 'assigns the new answer to the @user' do
          post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
          expect(assigns(:answer).user).to eq @user
        end

        it 'render create template' do
          post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
          expect(response).to render_template :create
        end
      end

      context 'with invalid attributes' do
        it 'does not save the new question in the database' do
          expect { post :create, params: { question_id: question, answer: attributes_for(:invalid_answer), format: :js } }.to_not change(Answer, :count)
        end

        it 'render create template' do
          post :create, params: { question_id: question, answer: attributes_for(:invalid_answer), format: :js }
          expect(response).to render_template :create
        end
      end
    end

    context 'user is not signed in' do
      it 'does not save the new answer in the database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js } }.to_not change(question.answers, :count)
      end

      it 'redirect to sign in page' do
        post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'user is signed in' do
      sign_in_user
      context 'user is the author of the answer' do
        let(:answer) { create(:answer, question: question, user: @user) }

        it 'deletes the answer' do
          params = { id: answer }
          expect { delete :destroy, params: params }.to change(question.answers, :count).by(-1)
        end

        it 'redirects to index view' do
          delete :destroy, params: { id: answer }
          expect(response).to redirect_to answer.question
        end
      end

      context 'user is not the author of the question' do
        before { answer }

        it 'deletes the answer' do
          expect { delete :destroy, params: { id: answer } }.to_not change(Answer, :count)
        end

        it 'redirects to index view' do
          delete :destroy, params: { id: answer }
          expect(response).to redirect_to answer.question
        end
      end
    end

    context 'user is not signed in' do
      before { answer }

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer } }.to_not change(Answer, :count)
      end

      it 'redirect to sign in page' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
