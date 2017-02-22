require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }

  describe 'GET #new' do
    context 'user is signed in' do
      sign_in_user
      before { get :new }

      it 'assigns a new Question to @question' do
        expect(assigns(:question)).to be_a_new(Question)
      end

      it 'builds a new attachment to a question' do
        expect(assigns(:question).attachments.first).to be_a_new(Attachment)
      end

      it 'render new view' do
        expect(response).to render_template :new
      end
    end

    context 'user is not signed in' do
      before { get :new }

      it 'redirect to sign in page' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'POST #create' do
    context 'user is signed in' do
      sign_in_user
      context 'with valid attributes' do
        it 'saves the new question in the database' do
          expect { post :create, params: { question: attributes_for(:question) } }.to change(@user.questions, :count).by(1)
        end

        it 'redirects to show view' do
          post :create, params: { question: attributes_for(:question) }
          expect(response).to redirect_to assigns(:question)
        end
      end

      context 'with invalid attributes' do
        it 'does not save the new question in the database' do
          expect { post :create, params: { question: attributes_for(:invalid_question) } }.to_not change(Question, :count)
        end

        it 're-renders new view' do
          post :create, params: { question: attributes_for(:invalid_question) }
          expect(response).to render_template :new
        end
      end
    end

    context 'user is not signed in' do
      it 'does not save the new question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to_not change(Question, :count)
      end

      it 'redirect to sign in page' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }

    before {get :index}

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { question }

    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns new answer to question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'DELETE #destroy' do
    context 'user is signed in' do
      sign_in_user
      context 'user is the author of the question' do
        let!(:question) { create(:question, user: @user) }

        it 'deletes the question' do
          expect { delete :destroy, params: { id: question } }.to change(@user.questions, :count).by(-1)
        end

        it 'redirects to index view' do
          delete :destroy, params: { id: question }
          expect(response).to redirect_to questions_path
        end
      end

      context 'user is not the author of the question' do
        before { question }

        it 'does not delete the question' do
          expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
        end

        it 'redirects to index view' do
          delete :destroy, params: { id: question }
          expect(response).to redirect_to questions_path
        end
      end
    end

    context 'user is not the author of the question' do
      before { question }

      it 'does not delete the question' do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end

      it 'redirects to sign in page' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'PATCH #update' do
    context 'user is signed in' do
      sign_in_user
      context 'user is the author of the question' do
        let!(:question) { create(:question, user: @user) }
        context 'with valid attributes' do
          it 'assigns the requested question to @question' do
            patch :update, params: { id: question, question: attributes_for(:question), format: :js }
            expect(assigns(:question)).to eq question
          end

          it 'changes the question attributes' do
            patch :update, params: { id: question, question: { title: 'new title', body: 'new body'}, format: :js }
            question.reload
            expect(question.title).to eq 'new title'
            expect(question.body).to eq 'new body'
          end

          it 'renders update view' do
            patch :update, params: { id: question, question: attributes_for(:question), format: :js }
            expect(response).to render_template :update
          end
        end

        context 'with invalid attributes' do
          before { patch :update, params: { id: question, question: { title: 'new title', body: nil}, format: :js } }
          it 'does not change the question attributes' do
            question.reload
            expect(question.title).to eq question.title
            expect(question.body).to eq question.body
          end

          it 're-renders update view' do
            expect(response).to render_template :update
          end
        end
      end

      context 'user is not the author of the question' do
        let!(:question) { create(:question) }

        before { patch :update, params: { id: question, question: { title: 'new title', body: 'new body'}, format: :js } }
        it 'does not change question attributes' do
          question.reload
          expect(question.title).to eq question.title
          expect(question.body).to eq question.body
        end

        it 're-renders update view' do
          expect(response).to render_template :update
        end
      end
    end

    context 'user is not signed in' do
      before { patch :update, params: { id: question, question: { title: 'new title', body: 'new body'}, format: :js } }
      it 'does not change answer attributes' do
        question.reload
        expect(question.title).to_not eq 'new title'
        expect(question.body).to_not eq 'new body'
      end

      it 'redirect to sign in page' do
        expect(response).to have_http_status(401)
      end
    end
  end
end
