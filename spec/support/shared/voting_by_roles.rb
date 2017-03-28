shared_examples_for "Create Vote by Roles" do
  context "user votes" do
    before { sign_in(user) }

    it_behaves_like "Create Vote"
  end

  context "admin votes" do
    before { sign_in(admin) }

    it_behaves_like "Create Vote"
  end

  context "guest votes" do
    it_behaves_like "Not create Vote"
  end

  context "author votes" do
    before { sign_in(author) }

    it_behaves_like "Not create Vote"
  end
end

shared_examples_for "Delete Vote by Roles" do
  context "user cancels his vote" do
    before { sign_in(user) }

    it_behaves_like "Delete Vote"
  end

  context "admin cancels his vote" do
    before { sign_in(admin) }

    it_behaves_like "Delete Vote"
  end

  context "guest cancels vote" do
    it_behaves_like "Not delete Vote"
  end

  context "author cancels vote" do
    before { sign_in(author) }

    it_behaves_like "Not delete Vote"
  end
end