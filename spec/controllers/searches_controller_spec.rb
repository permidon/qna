require 'rails_helper'

RSpec.describe SearchesController, type: :controller do
  describe 'GET #show' do
    it 'renders show view' do
      get :show, params: { source: 'Everywhere', query: '1234' }
      expect(response).to render_template :show
    end

    it 'sends OK status' do
      get :show, params: { source: 'Everywhere', query: '1234' }
      expect(response).to have_http_status(200)
    end

    it 'calls ThinkingSphinx .search method if source is Everywhere' do
      expect(ThinkingSphinx).to receive(:search).with('1234')
      get :show, params: { source: 'Everywhere', query: '1234' }
    end

    it 'calls Model .search method if source is plural name of Model' do
      expect(Question).to receive(:search).with('1234')
      get :show, params: { source: 'Questions', query: '1234' }
    end
  end
end
