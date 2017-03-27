require 'rails_helper'

RSpec.describe Comment do
  it_behaves_like "User References"

  it { should belong_to :commentable }

  it { should validate_presence_of :body }
  it { should validate_inclusion_of(:commentable_type).in_array(['Question', 'Answer']) }
end