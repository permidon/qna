require 'rails_helper'

RSpec.describe Subscription, type: :model do
  it_behaves_like "User References"

  it { should belong_to :question }
end
