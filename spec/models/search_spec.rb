require 'rails_helper'

RSpec.describe Search do
  describe 'Models' do
    %w(Questions Answers Comments Users).each do |source|
      it "calls #{source} .search if query is valid" do
        expect(source.classify.constantize).to receive(:search).with('1234')
        Search.search("#{source}", '1234' )
      end

      it "does not call #{source} .search if query is invalid" do
        expect(source.classify.constantize).to_not receive(:search).with('')
        Search.search("#{source}", '' )
      end
    end
  end

  describe 'Everywhere' do
    it "calls ThinkingSphinx .search if query is valid" do
      expect(ThinkingSphinx).to receive(:search).with('1234')
      Search.search('Everywhere', '1234' )
    end

    it "does not call ThinkingSphinx .search if query is invalid" do
      expect(ThinkingSphinx).to_not receive(:search).with('')
      Search.search('Everywhere', '' )
    end
  end

  describe 'Wrong Model' do
    it "does not call .search if model is invalid" do
      expect('Attachments'.classify.constantize).to_not receive(:search).with('1234')
      Search.search('Attachments', '1234' )
    end
  end
end