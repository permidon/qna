require 'rails_helper'

RSpec.describe Answer, type: :model do
  it_behaves_like "User References"
  it_behaves_like "Common Preferences"

  it { should belong_to :question }

  describe "set best_status" do
    let!(:question) { create(:question) }
    let!(:answer1) { create(:answer, question: question, best: true)}
    let!(:answer2) { create(:answer, question: question)}
    let!(:answer3) { create(:answer, question: question)}

    before { answer3.set_best_status }

    it "changes value from true to false to the old best answer" do
      answer1.reload
      expect(answer1).to_not be_best
    end

    it "does not change value from false to true to other answers" do
      answer2.reload
      expect(answer2).to_not be_best
    end

    it "changes value from false to true to the new best answer" do
      answer3.reload
      expect(answer3).to be_best
    end
  end

  describe "mail_answer" do
    let(:user) { create(:user) }
    let!(:question) { create(:question)}

    it 'calls .mail_answer method after answer creation' do
      answer = question.answers.new(body: '123', user: user)

      expect(answer).to receive(:mail_answer)
      answer.save
    end
  end
end
