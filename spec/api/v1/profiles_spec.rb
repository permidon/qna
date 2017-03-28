require 'acceptance/acceptance_helper'

describe 'Profile API' do
  describe 'GET /me' do
    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles/me', params: { format: :json, access_token: access_token.token } }

      %w(id email created_at updated_at admin).each do |attr|
        it "contains current user data - #{attr}" do
          expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path(attr)
        end
      end

      %w(password encrypted_password).each do |attr|
        it "does not contain current user data - #{attr}" do
          expect(response.body).to_not have_json_path(attr)
        end
      end
    end

    def do_request(options = {})
      get '/api/v1/profiles/me', params: { format: :json }.merge(options)
    end
  end

  describe 'GET /index' do
    it_behaves_like "API Authenticable"

    context 'authorized' do
      let!(:users) { create_list(:user, 3) }
      let(:access_token) { create(:access_token, resource_owner_id: users[2].id) }

      before { get '/api/v1/profiles', params: { format: :json, access_token: access_token.token } }

      it 'returns list of profiles' do
        expect(response.body).to have_json_size(2)
      end

      %w(id email created_at updated_at admin).each do |attr|
        it "contains other users data - #{attr}" do
          expect(response.body).to be_json_eql(users[0].send(attr.to_sym).to_json).at_path("0/#{attr}")
          expect(response.body).to be_json_eql(users[1].send(attr.to_sym).to_json).at_path("1/#{attr}")
        end
      end

      %w(password encrypted_password).each do |attr|
        it "does not contain other users data - #{attr}" do
          expect(response.body).to_not have_json_path("0/#{attr}")
          expect(response.body).to_not have_json_path("1/#{attr}")
        end
      end

      it "does not contain current user data" do
        expect(response.body).to_not have_json_path("2")
      end

    end

    def do_request(options = {})
      get '/api/v1/profiles', params: { format: :json }.merge(options)
    end
  end
end