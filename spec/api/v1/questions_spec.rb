require 'acceptance/acceptance_helper'

describe 'Questions API' do
  describe 'GET /index' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/questions', params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get '/api/v1//questions', params: { format: :json, access_token: '1234' }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let!(:answer) { create(:answer, question: question) }

      before { get '/api/v1/questions', params: { format: :json, access_token: access_token.token } }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      it 'returns list of questions' do
        expect(response.body).to have_json_size(2)
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end

      it 'question object contains short title' do
        expect(response.body).to be_json_eql(question.title.truncate(10).to_json).at_path("0/short_title")
      end

      context 'answers' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path("0/answers")
        end

        %w(id body created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("0/answers/0/#{attr}")
          end
        end
      end
    end
  end

  describe 'GET /show' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question) }
    let!(:comment) { create(:comment, commentable: question, user: user) }
    let!(:attachment) { create(:attachment, attachable: question) }
    # Создаю по одному объекту, т.к. при создании коллекции возникает об при обращении

    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get "/api/v1/questions/#{question.id}", params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get "/api/v1/questions/#{question.id}", params: { format: :json, access_token: '1234' }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      before { get "/api/v1/questions/#{question.id}", params: { format: :json, access_token: access_token.token } }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path(attr)
        end
      end

      context 'comments' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path("comments")
        end

        %w(id body).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("comments/0/#{attr}")
          end
        end
      end

      context 'attachments' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path("attachments")
        end

        %w(id file_url).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(attachment.send(attr.to_sym).to_json).at_path("attachments/0/#{attr}")
          end
        end
      end
    end
  end

  describe 'POST /create' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        post "/api/v1/questions", params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        post "/api/v1/questions", params: { format: :json, access_token: '1234' }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      before { post "/api/v1/questions", params: { question: question, format: :json, access_token: access_token.token } }

      context 'with valid attributes' do
        let(:question) { attributes_for(:question, title: 'New_Title', body: 'New_Body') }

        it 'creates and returns a new question' do
          expect(response.status).to eq 201

          get "/api/v1/questions", params: { format: :json, access_token: access_token.token }
          expect(response.body).to have_json_size(1)
          expect(response.body).to be_json_eql('New_Title'.to_json).at_path('0/title')
          expect(response.body).to be_json_eql('New_Body'.to_json).at_path('0/body')
        end
      end

      context 'with invalid attributes' do
        let(:question) { attributes_for(:question, title: '', body: '') }

        it 'doesn\'t save a question, renders errors' do
          expect(response.status).to eq 422
          expect(response.body).to have_json_path('errors')

          get "/api/v1/questions", params: { format: :json, access_token: access_token.token }
          expect(response.body).to have_json_size(0)
        end
      end
    end
  end
end