require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should belong_to :user }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  context "reset_best_status" do
    let!(:question) { create(:question) }
    let!(:answer1) { create(:answer, question: question, best: true)}
    let!(:answer2) { create(:answer, question: question)}

    before { question.reset_best_status }

    it "changes value from true to false" do
      answer1.reload
      expect(answer1.best).to eq false
    end

    it "does not changes value from false to true" do
      answer2.reload
      expect(answer2.best).to eq false
    end
  end
end
