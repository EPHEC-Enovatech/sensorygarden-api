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

RSpec.describe 'Posts management' do
    describe 'GET /posts' do
        it 'returns a status message' do
            get '/posts', :headers => { Authorization: "Bearer #{@token}" }
            json = JSON.parse response.body
            expect(json['status']).to eql('SUCCESS')
            expect(response.status).to eql(200)
        end

        it 'supports getting an id' do
            get '/posts/1', :headers => { Authorization: "Bearer #{@token}" }
            json = JSON.parse response.body
            expect(json['status']).to eql("SUCCESS")
            expect(response.status).to eql(200)
        end

        it 'returns a status message (ERROR) if the id does not exist' do
            get '/posts/42', :headers => { Authorization: "Bearer #{@token}" }
            json = JSON.parse response.body
            expect(json['status']).to eql("ERROR")
            expect(response.status).to eql(404)
        end
    end

    describe 'POST /posts' do
        it 'returns a status message' do
            post '/posts', :headers => { Authorization: "Bearer #{@token}" }, :params => { 
                postTitle: "Test post", 
                user_id: 1, 
                postText: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras volutpat nunc nibh, vitae ultrices massa rutrum eu.",
                categories: [1]
            }
            json = JSON.parse response.body
            expect(json['status']).to eql("SUCCESS")
            expect(response.status).to eql(201)
        end

        it 'returns a status message (ERROR) if missing parameters' do
            post '/posts', :headers => { Authorization: "Bearer #{@token}" }, :params => { 
                postTitle: "Test post", 
                user_id: 1,
                categories: [1]
             }
            json = JSON.parse response.body
            expect(json['status']).to eql("ERROR")
            expect(response.status).to eql(422)
        end

        it 'returns a status message (ERROR) if the user_id does not exist' do
            post '/posts', :headers => { Authorization: "Bearer #{@token}" }, :params => { 
                postTitle: "Test post", 
                user_id: 42, 
                postText: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras volutpat nunc nibh, vitae ultrices massa rutrum eu.",
                categories: [1]
             }
            json = JSON.parse response.body
            expect(json['status']).to eql("ERROR")
            expect(response.status).to eql(422)
        end

        it 'returns a status message (ERROR) if the categories parameter is not an array' do
            post '/posts', :headers => { Authorization: "Bearer #{@token}" }, :params => { 
                postTitle: "test",
                postText: "test",
                user_id: 1,
                categories: 1
             }
            json = JSON.parse response.body
            expect(json['status']).to eql("ERROR")
            expect(response.status).to eql(422)
        end
    end

    describe 'PATCH /posts/:id' do
        it 'returns a status message' do
            patch '/posts/1', :headers => { Authorization: "Bearer #{@token}" }, :params => { 
                postTitle: "Test post",
                postText: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras volutpat nunc nibh, vitae ultrices massa rutrum eu."
             }
            json = JSON.parse response.body
            expect(json['status']).to eql("SUCCESS")
            expect(response.status).to eql(200)
        end

        it 'returns a status message (ERROR) if the post_id does not exist' do
            patch '/posts/42', :headers => { Authorization: "Bearer #{@token}" }, :params => { 
                postTitle: "Test post", 
                postText: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras volutpat nunc nibh, vitae ultrices massa rutrum eu."
             }
            json = JSON.parse response.body
            expect(json['status']).to eql("ERROR")
            expect(response.status).to eql(404)
        end
    end

    describe 'DELETE /posts/id' do
        it 'returns a status message' do
            delete '/posts/2', :headers => { Authorization: "Bearer #{@token}" }
            json = JSON.parse response.body
            expect(json['status']).to eql("SUCCESS")
            expect(response.status).to eql(200)
        end

        it 'returns a status message (ERROR) if the post_id does not exist' do 
            delete '/posts/42', :headers => { Authorization: "Bearer #{@token}" }
            json = JSON.parse response.body
            expect(json['status']).to eql("ERROR")
            expect(response.status).to eql(404)
        end

        it 'returns a status message (ERROR) if the user is not admin' do
            token =  Knock::AuthToken.new(payload: { sub: 2, admin: false }).token
            delete '/posts/1', :headers => { Authorization: "Bearer #{token}" }
            json = JSON.parse response.body
            expect(json['status']).to eql("ERROR")
            expect(response.status).to eql(401)
        end
    end
end