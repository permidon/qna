require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let!(:author) { create(:user) }
  let(:user) { create(:user) }
  let(:admin) { create(:admin) }
  let!(:question) { create(:question, user: author) }

  describe "POST #create" do
    it_behaves_like "Create Subscription by Roles"

    def do_request
      post :create, params: { question_id: question.id, user_id: user.id, format: :json }
    end
  end

  describe "DELETE #destroy" do
    let!(:subscription){ create(:subscription, question: question, user: user) }

    it_behaves_like "Delete Subscription by Roles"

    def do_request
      delete :destroy, params: { id: subscription.id, format: :js }
    end
  end
end