require 'rails_helper'

RSpec.describe Comment do
  it { should belong_to :commentable }
  it { should belong_to :user }

  it { should validate_presence_of :user_id}
  it { should validate_presence_of :body }

  it { should validate_inclusion_of(:commentable_type).in_array(['Question', 'Answer']) }
end