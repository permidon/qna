require "rails_helper"

RSpec.describe SubscriptionMailer, type: :mailer do
  describe "new_answer" do
    let(:user) { create(:user) }
    let!(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question) }
    let(:mail) { SubscriptionMailer.new_answer(user, answer) }

    it "renders the headers" do
      expect(mail.subject).to eq("New answer")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["costromen@gmail.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("#{question.title}")
      expect(mail.body.encoded).to match("#{answer.body}")
    end
  end

end
