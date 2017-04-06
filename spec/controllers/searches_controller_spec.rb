require 'rails_helper'

RSpec.describe SearchesController, type: :controller do
  describe 'GET #show' do
    context "with valid params" do
      it_behaves_like "Searchable"

      def do_request
        get :show, params: { source: 'Everywhere', query: '1234' }
      end
    end

    context "with invalid query" do
      it_behaves_like "Searchable"

      def do_request
        get :show, params: { source: 'Everywhere', query: '' }
      end
    end

    context "with invalid source" do
      it_behaves_like "Searchable"

      def do_request
        get :show, params: { source: '', query: '1234' }
      end
    end
  end
end
