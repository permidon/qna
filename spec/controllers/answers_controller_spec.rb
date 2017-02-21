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
        let!(:answer) { create(:answer, question: question, user: @user) }

        it 'deletes the answer' do
          expect { delete :destroy, params: { id: answer, format: :js } }.to change(question.answers, :count).by(-1)
        end

        it 'render question view' do
          delete :destroy, params: { id: answer, format: :js }
          expect(response).to render_template :destroy
        end
      end

      context 'user is not the author of the question' do
        before { answer }

        it 'deletes the answer' do
          expect { delete :destroy, params: { id: answer, format: :js } }.to_not change(Answer, :count)
        end

        it 'redirects to index view' do
          delete :destroy, params: { id: answer, format: :js }
          expect(response).to render_template :destroy
        end
      end
    end

    context 'user is not signed in' do
      before { answer }

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer, format: :js } }.to_not change(Answer, :count)
      end

      it 'redirect to sign in page' do
        delete :destroy, params: { id: answer, format: :js }
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'PATCH #update' do
    context 'user is signed in' do
      sign_in_user
      context 'user is the author of the answer' do
        context 'with valid attributetes' do
          let(:answer) { create(:answer, question: question, user: @user) }

          it 'assigns the question to @question' do
            patch :update, params: { id: answer, question_id: question, answer: attributes_for(:answer), format: :js }
            expect(assigns(:question)).to eq question
          end

          it 'assings the requested answer to @answer' do
            patch :update, params: { id: answer, question_id: question, answer: attributes_for(:answer), format: :js }
            expect(assigns(:answer)).to eq answer
          end

          it 'changes answer attributes' do
            patch :update, params: { id: answer, question_id: question, answer: { body: 'new body'}, format: :js }
            answer.reload
            expect(answer.body).to eq 'new body'
          end

          it 'render update template' do
            patch :update, params: { id: answer, question_id: question, answer: attributes_for(:answer), format: :js }
            expect(response).to render_template :update
          end
        end

        context 'with invalid attributetes' do
          let(:answer) { create(:answer, question: question, user: @user) }

          it 'assigns the question to @question' do
            patch :update, params: { id: answer, question_id: question, answer: attributes_for(:answer), format: :js }
            expect(assigns(:question)).to eq question
          end

          it 'assings the requested answer to @answer' do
            patch :update, params: { id: answer, question_id: question, answer: attributes_for(:answer), format: :js }
            expect(assigns(:answer)).to eq answer
          end

          it 'changes answer attributes' do
            patch :update, params: { id: answer, question_id: question, answer: { body: nil}, format: :js }
            answer.reload
            expect(answer.body).to_not eq nil
          end

          it 'render update template' do
            patch :update, params: { id: answer, question_id: question, answer: attributes_for(:answer), format: :js }
            expect(response).to render_template :update
          end
        end
      end

      context 'user is not the author of the answer' do
        let(:user) { create(:user) }
        let(:answer) { create(:answer, question: question, user: user) }

        it 'assings the requested answer to @answer' do
          patch :update, params: { id: answer, question_id: question, answer: attributes_for(:answer), format: :js }
          expect(assigns(:answer)).to eq answer
        end

        it 'does not change answer attributes' do
          patch :update, params: { id: answer, question_id: question, answer: { body: 'new body'}, format: :js }
          answer.reload
          expect(answer.body).to_not eq 'new body'
        end

        it 'render update template' do
          patch :update, params: { id: answer, question_id: question, answer: attributes_for(:answer), format: :js }
          expect(response).to render_template :update
        end
      end
    end

    context 'user is a guest' do
      it 'does not change answer attributes' do
        patch :update, params: { id: answer, question_id: question, answer: { body: 'new body'}, format: :js }
        answer.reload
        expect(answer.body).to_not eq 'new body'
      end

      it 'redirect to sign in page' do
        patch :update, params: { id: answer, question_id: question, answer: attributes_for(:answer), format: :js }
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'PATCH #mark_best' do
    context 'user is signed in' do
      sign_in_user
      context 'user is the author of the question' do
        let(:user) { create(:user) }
        let(:question) { create(:question, user: @user) }
        let(:answer) { create(:answer, question: question, user: user) }

        it 'assigns the question to @question' do
          patch :mark_best, params: { id: answer, question_id: question, answer: attributes_for(:answer), format: :js }
          expect(assigns(:question)).to eq question
        end

        it 'assings the answer to @answer' do
          patch :mark_best, params: { id: answer, question_id: question, answer: attributes_for(:answer), format: :js }
          expect(assigns(:answer)).to eq answer
        end

        it 'changes answer attributes' do
          patch :mark_best, params: { id: answer, question_id: question, answer: { best: true }, format: :js }
          answer.reload
          expect(answer.best).to eq true
        end

        it 'render best template' do
          patch :mark_best, params: { id: answer, question_id: question, answer: attributes_for(:answer), format: :js }
          expect(response).to render_template :mark_best
        end
      end

      context 'user is not the author of the question' do
        let(:user) { create(:user) }
        let(:question) { create(:question, user: user) }
        let(:answer) { create(:answer, question: question, user: user) }

        it 'assigns the question to @question' do
          patch :mark_best, params: { id: answer, question_id: question, answer: attributes_for(:answer), format: :js }
          expect(assigns(:question)).to eq question
        end

        it 'assings the answer to @answer' do
          patch :mark_best, params: { id: answer, question_id: question, answer: attributes_for(:answer), format: :js }
          expect(assigns(:answer)).to eq answer
        end

        it 'does not change answer attributes' do
          patch :mark_best, params: { id: answer, question_id: question, answer: { best: true }, format: :js }
          answer.reload
          expect(answer.best).to eq false
        end

        it 'render best template' do
          patch :mark_best, params: { id: answer, question_id: question, answer: attributes_for(:answer), format: :js }
          expect(response).to render_template :mark_best
        end
      end
    end

    context 'user is not signed in' do
      before {question}
      before {answer}

      it 'does not change answer attributes' do
        patch :mark_best, params: { id: answer, question_id: question, answer: { best: true }, format: :js }
        answer.reload
        expect(answer.best).to eq false
      end

      it 'render best template' do
        patch :mark_best, params: { id: answer, question_id: question, answer: attributes_for(:answer), format: :js }
        expect(response).to have_http_status(401)
      end
    end
  end
end
