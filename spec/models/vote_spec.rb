require 'rails_helper'

RSpec.describe Vote do
  it { should belong_to :votable }
end
