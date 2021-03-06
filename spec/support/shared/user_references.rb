shared_examples_for "User References" do
  context 'User' do
    it { should belong_to :user }
    it { should validate_presence_of :user_id}
  end
end