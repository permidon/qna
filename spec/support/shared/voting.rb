shared_examples_for "Create Vote" do
  context "with valid value" do
    it "changes Votes value" do
      expect{ do_request(value: 1) }.to change(votable.votes, :count).by(1)
    end

    it "sends OK status" do
      do_request(value: 1)
      expect(response).to be_success
    end
  end

  context "with invalid value" do
    it "does not change Votes value" do
      expect{ do_request(value: 2) }.to_not change(Vote, :count)
    end

    it "sends 422 status" do
      do_request(value: 2)
      expect(response).to have_http_status(422)
    end
  end
end

shared_examples_for "Not create Vote" do
  it "does not change Votes value" do
    expect{ do_request(value: 1) }.to_not change(Vote, :count)
  end

  it "is not successful" do
    do_request(value: 1)
    expect(response).to_not be_success
  end
end

shared_examples_for "Delete Vote" do
  it "destroys a vote" do
    expect(votable.rating).to eq 1
    expect{ do_request }.to change(Vote, :count).by(-1)
    votable.reload
    expect(votable.rating).to eq 0
  end

  it "sends OK status" do
    do_request
    expect(response).to have_http_status(200)
  end
end

shared_examples_for "Not delete Vote" do
  it "does not destroy vote" do
    expect(votable.rating).to eq 1
    expect{ do_request }.to_not change(Vote, :count)
    votable.reload
    expect(votable.rating).to eq 1
  end

  it "is not successful" do
    do_request
    expect(response).to_not be_success
  end
end