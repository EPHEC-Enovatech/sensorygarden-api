require 'rails_helper'

RSpec.configure do |config|

    require 'database_cleaner'

    config.use_transactional_fixtures = false
    DatabaseCleaner.strategy = :truncation

    config.before(:suite) do
        DatabaseCleaner.clean
        Rails.application.load_seed
    end

    config.before(:each) do
        post '/user_token', params: {auth: {email: "john@doe.com", password: "1234"}}
        json = JSON.parse response.body
        @token = json['jwt']
    end

    config.after(:suite) do
        DatabaseCleaner.clean
    end
end

RSpec.describe 'Categories management' do
    describe 'GET /categories' do
        it 'returns a status message' do
            get '/categories', :headers => { Authorization: "Bearer #{@token}" }
            json = JSON.parse response.body
            expect(json['status']).to eql('SUCCESS')
            expect(response.status).to eql(200)
        end

        it 'get a status 401 Unauthorized if missing the authorization token in the header' do
            get '/categories'
            expect(response.status).to eql(401)
        end
    end

    describe 'POST /categories' do
        it 'returns a status message' do
            post '/categories', :headers => { Authorization: "Bearer #{@token}" }, :params => { categoryName: "Test category" }
            json = JSON.parse response.body
            expect(json['status']).to eql('SUCCESS')
            expect(response.status).to eql(201)
        end

        it 'returns a status message (ERROR) if missing parameter' do
            post '/categories', :headers => { Authorization: "Bearer #{@token}" }
            json = JSON.parse response.body
            expect(json['status']).to eql('ERROR')
            expect(response.status).to eql(422)
        end

        it 'returns a status messqge (ERROR) if category already exists' do
            post '/categories', :headers => { Authorization: "Bearer #{@token}" }, :params => { categoryName: "Category 1" }
            json = JSON.parse response.body
            expect(json['status']).to eql('ERROR')
            expect(response.status).to eql(422)
        end
    end

    describe 'PACTH /categories/:id' do
        it 'returns a status message' do
            patch '/categories/2', :headers => { Authorization: "Bearer #{@token}" }, :params => { categoryName: "Category 2 Changed" }
            json = JSON.parse response.body
            expect(json['status']).to eql('SUCCESS')
            expect(response.status).to eql(200)
        end

        it 'returns a status message (ERROR) if the category id requested does not exist' do
            patch '/categories/42', :headers => { Authorization: "Bearer #{@token}" }, :params => { categoryName: "Category 1" }
            json = JSON.parse response.body
            expect(json['status']).to eql('ERROR')
            expect(response.status).to eql(404)
        end

        it 'returns a status message (ERROR) if the categoryName already exists' do
            patch '/categories/2', :headers => { Authorization: "Bearer #{@token}" }, :params => { categoryName: "Category 1" }
            json = JSON.parse response.body
            expect(json['status']).to eql('ERROR')
            expect(response.status).to eql(422)
        end
    end

    describe 'DELETE /categories' do
        it 'returns a status message' do
            delete '/categories/2', :headers => { Authorization: "Bearer #{@token}" }
            json = JSON.parse response.body
            expect(json['status']).to eql('SUCCESS')
            expect(response.status).to eql(200)
        end

        it 'returns a status message (ERROR) if the requested categoryId does not exist' do
            delete '/categories/42', :headers => { Authorization: "Bearer #{@token}" }
            json = JSON.parse response.body
            expect(json['status']).to eql('ERROR')
            expect(response.status).to eql(404)
        end
    end
end