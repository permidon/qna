require 'acceptance/acceptance_helper'

describe 'Answers API' do
  let!(:question) { create(:question) }

  # Создаю один объект, т.к. при создании коллекции возникает путаница в адресации json (default scope?)
  let!(:answer) { create(:answer, question: question) }

  describe 'GET /index' do
    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get "/api/v1/questions/#{question.id}/answers", params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get "/api/v1/questions/#{question.id}/answers", params: { format: :json, access_token: '1234' }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      before { get "/api/v1/questions/#{question.id}/answers", params: { format: :json, access_token: access_token.token } }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      it 'returns list of answers' do
        expect(response.body).to have_json_size(1)
      end

      %w(id body created_at updated_at best rating).each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end
    end
  end

  describe 'GET /show' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question) }

    # Создаю по одному объекту, т.к. при создании коллекций возникает путаница в адресации json (default scope?)
    let!(:comment) { create(:comment, commentable: answer, user: user) }
    let!(:attachment) { create(:attachment, attachable: answer) }

    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get "/api/v1/answers/#{answer.id}", params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get "/api/v1/answers/#{answer.id}", params: { format: :json, access_token: '1234' }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      before { get "/api/v1/answers/#{answer.id}", params: { format: :json, access_token: access_token.token } }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      %w(id body created_at updated_at).each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path(attr)
        end
      end

      context 'comments' do
        it 'included in answer object' do
          expect(response.body).to have_json_size(1).at_path("comments")
        end

        %w(id body).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("comments/0/#{attr}")
          end
        end
      end

      context 'attachments' do
        it 'included in answer object' do
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
        post "/api/v1/questions/#{question.id}/answers", params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        post "/api/v1/questions/#{question.id}/answers", params: { format: :json, access_token: '1234' }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      before { post "/api/v1/questions/#{question.id}/answers", params: { answer: answer, format: :json, access_token: access_token.token } }

      context 'with valid attributes' do
        let(:answer) { attributes_for(:answer, question: question, body: 'New_Body') }

        it 'creates and returns a new answer' do
          expect(response.status).to eq 201

          get "/api/v1/questions/#{question.id}/answers", params: { format: :json, access_token: access_token.token }
          expect(response.body).to have_json_size(1)
          expect(response.body).to be_json_eql('New_Body'.to_json).at_path('0/body')
        end
      end

      context 'with invalid attributes' do
        let(:answer) { attributes_for(:answer, question: question, body: '') }

        it 'doesn\'t save an answer, renders errors' do
          expect(response.status).to eq 422
          expect(response.body).to have_json_path('errors')

          get "/api/v1/questions/#{question.id}/answers", params: { format: :json, access_token: access_token.token }
          expect(response.body).to have_json_size(0)
        end
      end
    end
  end
end