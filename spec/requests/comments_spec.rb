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

RSpec.describe 'Comments management' do
    describe "GET /comments" do
        it 'returns a status message' do
            get '/comments', :headers => { Authorization: "Bearer #{@token}" }
            json = JSON.parse response.body
            expect(json['status']).to eql("SUCCESS")
            expect(response.status).to eql(200)
        end

        it 'supports getting an :id' do
            get '/comments/1', :headers => { Authorization: "Bearer #{@token}" }
            json = JSON.parse response.body
            expect(json['status']).to eql("SUCCESS")
            expect(response.status).to eql(200)
        end

        it 'returns a status message (ERROR) if the id does not exist' do
            get '/comments/42', :headers => { Authorization: "Bearer #{@token}" }
            json = JSON.parse response.body
            expect(json['status']).to eql("ERROR")
            expect(response.status).to eql(404)
        end
    end

    describe "POST /comments" do
        it 'returns a status message' do
            post '/comments', :headers => { Authorization: "Bearer #{@token}" }, :params => { commentText: "Test comment", user_id: 1, post_id: 1 }
            json = JSON.parse response.body
            expect(json['status']).to eql("SUCCESS")
            expect(response.status).to eql(201)
        end

        it 'returns a status message (ERROR) if missing a parameter' do
            post '/comments', :headers => { Authorization: "Bearer #{@token}" }, :params => { commentText: "Test comment", post_id: 1 }
            json = JSON.parse response.body
            expect(json['status']).to eql("ERROR")
            expect(response.status).to eql(404)
        end

        it 'returns a status message (ERROR) if the user_id does not exist' do
            post '/comments', :headers => { Authorization: "Bearer #{@token}" }, :params => { commentText: "Test comment", user_id: 42, post_id: 1 }
            json = JSON.parse response.body
            expect(json['status']).to eql("ERROR")
            expect(response.status).to eql(404)
        end

        it 'returns a status message (ERROR) if the post_id does not exist' do
            post '/comments', :headers => { Authorization: "Bearer #{@token}" }, :params => { commentText: "Test comment", user_id: 1, post_id: 42 }
            json = JSON.parse response.body
            expect(json['status']).to eql("ERROR")
            expect(response.status).to eql(404)
        end
    end

    describe "PATCH /comments/:id" do
        it 'returns a status message' do
            patch '/comments/2', :headers => { Authorization: "Bearer #{@token}" }, :params => { commentText: "Change comment text" }
            json = JSON.parse response.body
            expect(json['status']).to eql("SUCCESS")
            expect(response.status).to eql(200)
        end

        it 'returns a status message (ERROR) the id does not exist' do
            patch '/comments/42', :headers => { Authorization: "Bearer #{@token}" }, :params => { commentText: "Change comment test" }
            json = JSON.parse response.body
            expect(json['status']).to eql("ERROR")
            expect(response.status).to eql(404)
        end
    end

    describe "DELETE /comments" do
       it 'returns a status message' do
        delete '/comments/2', :headers => { Authorization: "Bearer #{@token}" }
        json = JSON.parse response.body
        expect(json['status']).to eql("SUCCESS")
        expect(response.status).to eql(200)
       end

       it "returns a status message (ERROR) if the id does not exist" do
        delete '/comments/42', :headers => { Authorization: "Bearer #{@token}" }
        json = JSON.parse response.body
        expect(json['status']).to eql("ERROR")
        expect(response.status).to eql(404)
       end

       it 'returns a status message (ERROR) if the user is not admin' do
        token =  Knock::AuthToken.new(payload: { sub: 2, admin: false }).token
        delete '/comments/1', :headers => { Authorization: "Bearer #{token}" }
        json = JSON.parse response.body
        expect(json['status']).to eql("ERROR")
        expect(response.status).to eql(401)
    end
    end
end 