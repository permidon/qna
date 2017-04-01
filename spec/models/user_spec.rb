require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many :questions }
  it { should have_many :answers }
  it { should have_many :comments }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:authorizations).dependent(:destroy) }

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

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) {OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456')}

    context 'user already has authorization' do
      it "returns the user" do
        user.authorizations.create(provider: 'facebook', uid: '123456')
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context 'user has no authorization' do
      context 'user already exists' do
        let(:auth) {OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: user.email }) }

        it "does not create a new user" do
          expect { User.find_for_oauth(auth) }.to_not change(User, :count)
        end

        it "creates authorization for user" do
          expect { User.find_for_oauth(auth) }.to change(user.authorizations, :count).by(1)
        end

        it 'creates authorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

        it "returns user" do
          expect(User.find_for_oauth(auth)).to eq user
        end
      end
    end

    context 'user does not exist and provider returns email' do
      let(:auth) {OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: 'new@user.com' }) }

      it "creates a new user" do
        expect { User.find_for_oauth(auth) }.to change(User, :count).by(1)
      end

      it "returns a new user" do
        expect(User.find_for_oauth(auth)).to be_a(User)
      end

      it "makes a new user confirmed" do
        expect(User.find_for_oauth(auth)).to be_confirmed
      end

      it "fills user email" do
        user = User.find_for_oauth(auth)
        expect(user.email).to eq auth.info[:email]
      end

      it "creates an authorization for a new user" do
        user = User.find_for_oauth(auth)
        expect(user.authorizations).to_not be_empty
      end

      it "creates an authorization with provider and uid" do
        authorization = User.find_for_oauth(auth).authorizations.first

        expect(authorization.provider).to eq auth.provider
        expect(authorization.uid).to eq auth.uid
      end
    end

    context 'user does not exist and provider does not return email' do
      let(:auth) {OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', unconfirm: 'true', info: { email: 'email@confirmation.form' }) }

      it "creates a new user" do
        expect { User.find_for_oauth(auth) }.to change(User, :count).by(1)
      end

      it "returns a new user" do
        expect(User.find_for_oauth(auth)).to be_a(User)
      end

      it "makes a new user unconfirmed" do
        expect(User.find_for_oauth(auth)).to_not be_confirmed
      end

      it "fills user email" do
        user = User.find_for_oauth(auth)
        expect(user.email).to eq auth.info[:email]
      end

      it "creates an authorization for a new user" do
        user = User.find_for_oauth(auth)
        expect(user.authorizations).to_not be_empty
      end

      it "creates an authorization with provider and uid" do
        authorization = User.find_for_oauth(auth).authorizations.first

        expect(authorization.provider).to eq auth.provider
        expect(authorization.uid).to eq auth.uid
      end
    end
  end

  describe '.send_daily_digest' do
    let(:users) { create_list(:user, 2) }

    it 'should send daily digest to all users' do
      users.each { |user| expect(DailyMailer).to receive(:digest).with(user).and_call_original  }
      User.send_daily_digest
    end
  end

  describe '.send_new_answer(answer)' do
    let!(:users) { create_list(:user, 3) }
    let!(:question) { create(:question, user: users[0]) }
    let!(:subscription) { create(:subscription, question: question, user: users[1])}
    let(:answer) { create(:answer, question: question)}

    it 'should send new answer only to subscribed users' do
      expect(SubscriptionMailer).to receive(:new_answer).with(users[0], answer).and_call_original
      expect(SubscriptionMailer).to receive(:new_answer).with(users[1], answer).and_call_original
      expect(SubscriptionMailer).to_not receive(:new_answer).with(users[2], answer).and_call_original
      User.send_new_answer(answer)
    end
  end
end