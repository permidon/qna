require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should belong_to :user }
  it { should have_many(:attachments).dependent(:destroy) }

  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :attachments}

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
end
