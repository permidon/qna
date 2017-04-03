require 'rails_helper'

RSpec.describe QuestionSubscribeJob, type: :job do
  let!(:users) { create_list(:user, 3) }
  let!(:question) { create(:question, user: users[0]) }
  let!(:subscription) { create(:subscription, question: question, user: users[1])}
  let(:answer) { create(:answer, question: question)}

  it 'sends new answer to subscribed users' do
    expect(SubscriptionMailer).to receive(:new_answer).with(users[0], answer).and_call_original
    expect(SubscriptionMailer).to receive(:new_answer).with(users[1], answer).and_call_original
    expect(SubscriptionMailer).to_not receive(:new_answer).with(users[2], answer).and_call_original
    QuestionSubscribeJob.perform_now(answer)
  end
end