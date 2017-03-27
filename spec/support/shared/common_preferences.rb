shared_examples_for "Common Preferences" do
  context 'References' do
    it { should have_many(:attachments).dependent(:destroy) }
    it { should have_many(:votes).dependent(:destroy) }
    it { should have_many(:comments).dependent(:destroy) }
  end

  context 'Validates' do
    it { should validate_presence_of :body }
  end

  context 'Attributes' do
    it { should accept_nested_attributes_for(:attachments).allow_destroy(true) }
  end
end