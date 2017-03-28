shared_examples_for "Create Comment" do
  context "with valid value" do
    it "makes a new comment" do
      expect{ do_request(comment: attributes_for(:comment)) }.to change(commentable.comments, :count).by(1)
    end

    it "sends OK status" do
      do_request(comment: attributes_for(:comment))
      expect(response).to be_success
    end
  end

  context "with invalid value" do
    it "does not make a new comment" do
      expect{ do_request(comment: attributes_for(:invalid_comment)) }.to_not change(Comment, :count)
    end

    it "sends 422 status" do
      do_request(comment: attributes_for(:invalid_comment))
      expect(response).to have_http_status(422)
    end
  end
end

shared_examples_for "Not create Comment" do
  it "does not make a new comment" do
    expect { do_request(body: 'new comment') }.to_not change(Comment, :count)
  end

  it "send 401 status" do
    do_request(body: 'new comment')
    expect(response).to have_http_status(401)
  end
end