shared_examples_for "Create Subscription" do
  it "changes Subscriptions value" do
    expect{ do_request }.to change(question.subscriptions, :count).by(1)
  end

  it "sends OK status" do
    do_request
    expect(response).to be_success
  end
end

shared_examples_for "Not create Subscription" do
  it "does not change Subscriptions value" do
    expect{ do_request }.to_not change(Subscription, :count)
  end

  it "is not successful" do
    do_request
    expect(response).to_not be_success
  end
end

shared_examples_for "Delete Subscription" do
  it "destroys a subscription" do
    expect(question.subscriptions.count).to eq 2
    expect{ do_request }.to change(Subscription, :count).by(-1)
    expect(question.subscriptions.count).to eq 1
  end

  it "sends OK status" do
    do_request
    expect(response).to have_http_status(200)
  end
end

shared_examples_for "Not delete Subscription" do
  it "does not destroy a subscription" do
    expect(question.subscriptions.count).to eq 2
    expect{ do_request }.to_not change(Subscription, :count)
    expect(question.subscriptions.count).to eq 2
  end

  it "is not successful" do
    do_request
    expect(response).to_not be_success
  end
end