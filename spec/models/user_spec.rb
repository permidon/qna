require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many :questions }
  it { should have_many :answers }
  it { should have_many(:votes).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe "author_of?" do
    let(:author) { create(:user) }
    let(:user) { create(:user) }
    let(:question) { create(:question, user: author) }
    let(:answer) { create(:answer, question: question, user: author)}

    context 'user_id and object_id are the same' do
      it "compares user_id and question_id" do
        expect(author).to be_author_of(question)
      end

      it "compares user_id and answer_id" do
        expect(author).to be_author_of(answer)
      end
    end

    context 'user_id and object_id are different' do
      it "compares user_id and question_id" do
        expect(user).to_not be_author_of(question)
      end

      it "compares user_id and answer_id" do
        expect(user).to_not be_author_of(answer)
      end
    end
  end
end