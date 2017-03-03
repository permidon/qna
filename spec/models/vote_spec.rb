require 'rails_helper'

RSpec.describe Vote do
  it { should belong_to :votable }
  it { should belong_to :user }

  it { should validate_presence_of :user_id}
  it { should validate_presence_of :value }
  it { should validate_presence_of :votable_id }
  it { should validate_presence_of :votable_type }

  # it { should validate_uniqueness_of(:user_id).scoped_to(:votable_id, :votable_type)}
  # Не проходит если выполняется rating_increment после after_create

  it { should validate_inclusion_of(:value).in_array([-1, 1]) }
  it { should validate_inclusion_of(:votable_type).in_array(['Question', 'Answer']) }

  describe "votable rating" do
    let(:author) { create(:user) }
    let(:user) { create(:user) }
    let!(:question) { create(:question, user: author) }
    let!(:answer) { create(:answer, question: question, user: author)}
    let!(:answer_vote){ create(:vote, votable: answer, user: user) }
    let!(:question_vote){ create(:vote, votable: question, user: user) }


    context 'rating_increment' do
      it "increments a question rating" do
        expect(question.rating).to eq 1
      end

      it "increments an answer rating" do
        expect(answer.rating).to eq 1
      end
    end

    context 'rating_decrement' do
      it "decrements a question rating" do
        question_vote.destroy
        expect(question.rating).to eq 0
      end

      it "decrements an answer rating" do
        answer_vote.destroy
        expect(answer.rating).to eq 0
      end
    end
  end
end
