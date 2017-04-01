require 'rails_helper'

RSpec.describe QuestionSubscribeJob, type: :job do
  let(:answer) { create(:answer) }
  it 'sends mail after create answer' do
    expect(User).to receive(:send_new_answer)
    QuestionSubscribeJob.perform_now(answer)
  end
end
