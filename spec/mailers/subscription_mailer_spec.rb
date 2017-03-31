require "rails_helper"

RSpec.describe SubscriptionMailer, type: :mailer do
  describe "new_answer" do
    let(:user) { create(:user) }
    let(:mail) { SubscriptionMailer.new_answer(user) }

    it "renders the headers" do
      expect(mail.subject).to eq("New answer")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
