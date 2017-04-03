shared_examples_for "Create Subscription by Roles" do
  context "user subscription" do
    before { sign_in(user) }

    it_behaves_like "Create Subscription"
  end

  context "admin subscription" do
    before { sign_in(admin) }

    it_behaves_like "Create Subscription"
  end

  context "guest subscription" do
    it_behaves_like "Not create Subscription"
  end

  context "author subscription" do
    before { sign_in(author) }

    it_behaves_like "Not create Subscription"
  end
end

shared_examples_for "Delete Subscription by Roles" do
  context "user cancels his own subscription" do
    before { sign_in(user) }

    it_behaves_like "Delete Subscription"
  end

  context "admin cancels user subscription" do
    before { sign_in(admin) }

    it_behaves_like "Delete Subscription"
  end

  context "guest cancels user subscription" do
    it_behaves_like "Not delete Subscription"
  end

  context "author cancels user subscription" do
    before { sign_in(author) }

    it_behaves_like "Not delete Subscription"
  end

  context "author cancels his own subscription" do
    before { sign_in(author) }

    it "destroy subscription" do
      expect(question.subscriptions.count).to eq 2
      expect{delete :destroy, params: { id: author.subscriptions.first.id, format: :js }}.to change(Subscription, :count).by(-1)
      expect(question.subscriptions.count).to eq 1
    end

    it "sends OK status" do
      delete :destroy, params: { id: author.subscriptions.first.id, format: :js }
      expect(response).to have_http_status(200)
    end
  end
end