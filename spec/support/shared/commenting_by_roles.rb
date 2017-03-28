shared_examples_for "Commenting by Roles" do
  context "user comments" do
    before { sign_in(user) }

    it_behaves_like "Create Comment"
  end

  context "guest comments" do
    it_behaves_like "Not create Comment"
  end

  context "author comments" do
    before { sign_in(author) }

    it_behaves_like "Create Comment"
  end

  context "admin comments" do
    before { sign_in(admin) }

    it_behaves_like "Create Comment"
  end
end
