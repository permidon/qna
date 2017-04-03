require 'rails_helper'

RSpec.describe Question, type: :model do
  it_behaves_like "User References"
  it_behaves_like "Common Preferences"

  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:subscribers).through(:subscriptions).source(:user) }

  it { should validate_presence_of :title }
end
