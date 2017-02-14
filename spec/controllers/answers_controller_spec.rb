require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }

  describe 'GET new' do
    context 'user is signed in' do
      sign_in_user

      before { get :new, params: { question_id: question} }

      it 'assigns the requested question to @question' do
        expect(assigns(:question)).to eq question
      end

      it 'assigns a new Answer to @answer' do
        expect(assigns(:answer)).to be_a_new(Answer)
      end

      it 'render new view' do
        expect(response).to render_template :new
      end
    end

    context 'user is not signed in' do
      before { get :new, params: { question_id: question} }

      it 'redirect to sign in page' do
        expect(response).to redirect_to new_user_session_path
      end
    end

  end

  describe 'POST #create' do
    context 'user is signed in' do
      sign_in_user
      it 'assigns the requested question to @question' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }
        expect(assigns(:question)).to eq question
      end

      context 'with valid attributes' do
        it 'saves the new answer in the database' do
          expect { post :create, params: { question_id: question, answer: attributes_for(:answer) } }.to change(question.answers, :count).by(1)
          expect(assigns(:answer).user).to eq @user
        end

        it 'redirects to question view' do
          post :create, params: { question_id: question, answer: attributes_for(:answer) }
          expect(response).to redirect_to assigns(:question)
        end
      end

      context 'with invalid attributes' do
        it 'does not save the new question in the database' do
          expect { post :create, params: { question_id: question, answer: attributes_for(:invalid_answer) } }.to_not change(Answer, :count)
        end

        it 're-renders new view' do
          post :create, params: { question_id: question, answer: attributes_for(:invalid_answer) }
          expect(response).to render_template :new
        end
      end
    end

    context 'user is not signed in' do
      it 'does not save the new answer in the database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) } }.to_not change(question.answers, :count)
      end

      it 'redirect to sign in page' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'GET #show' do
    before { answer }

    before { get :show, params: { id: answer } } # use new syntax to remove deprecation warning

    it 'assigns the requested answer to @answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'renders show view' do
      expect(response).to render_template :show
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
