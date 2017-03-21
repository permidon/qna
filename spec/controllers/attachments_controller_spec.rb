require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:admin) { create(:admin) }
  describe 'DELETE #destroy' do
    context 'user is the author of the question or the answer' do
      sign_in_user
      let!(:question) { create(:question, user: @user) }
      let!(:answer) { create(:answer, question: question, user: @user) }
      let!(:q_attachment) { create(:attachment, attachable: question) }
      let!(:a_attachment) { create(:attachment, attachable: answer) }

      it 'deletes the question\'s file' do
        expect { delete :destroy, params: { id: q_attachment, format: :js } }.to change(question.attachments, :count).by(-1)
      end

      it 'deletes the answer\'s file' do
        expect { delete :destroy, params: { id: a_attachment, format: :js } }.to change(answer.attachments, :count).by(-1)
      end

      it 'render question view after deleting the question\'s file' do
        delete :destroy, params: { id: q_attachment, format: :js }
        expect(response).to render_template :destroy
      end

      it 'render question view after deleting the answer\'s file' do
        delete :destroy, params: { id: a_attachment, format: :js }
        expect(response).to render_template :destroy
      end
    end

    context 'user is NOT the author of the question or the answer' do
      sign_in_user
      let!(:question) { create(:question) }
      let!(:answer) { create(:answer, question: question) }
      let!(:q_attachment) { create(:attachment, attachable: question) }
      let!(:a_attachment) { create(:attachment, attachable: answer) }

      it 'does not delete the question\'s file' do
        expect { delete :destroy, params: { id: q_attachment, format: :js } }.to_not change(Attachment, :count)
      end

      it 'does not delete the answer\'s file' do
        expect { delete :destroy, params: { id: a_attachment, format: :js } }.to_not change(Attachment, :count)
      end

      it 'render question view after trying to delete the question\'s file' do
        delete :destroy, params: { id: q_attachment, format: :js }
        expect(response).to redirect_to root_path
      end

      it 'render question view after trying to delete the answer\'s file' do
        delete :destroy, params: { id: a_attachment, format: :js }
        expect(response).to redirect_to root_path
      end
    end

    context 'user is admin' do
      before { sign_in(admin) }

      let!(:question) { create(:question) }
      let!(:answer) { create(:answer, question: question) }
      let!(:q_attachment) { create(:attachment, attachable: question) }
      let!(:a_attachment) { create(:attachment, attachable: answer) }

      it 'deletes the question\'s file' do
        expect { delete :destroy, params: { id: q_attachment, format: :js } }.to change(question.attachments, :count).by(-1)
      end

      it 'deletes the answer\'s file' do
        expect { delete :destroy, params: { id: a_attachment, format: :js } }.to change(answer.attachments, :count).by(-1)
      end

      it 'render question view after deleting the question\'s file' do
        delete :destroy, params: { id: q_attachment, format: :js }
        expect(response).to render_template :destroy
      end

      it 'render question view after deleting the answer\'s file' do
        delete :destroy, params: { id: a_attachment, format: :js }
        expect(response).to render_template :destroy
      end
    end
  end
end
