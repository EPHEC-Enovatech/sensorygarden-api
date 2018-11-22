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

RSpec.describe 'Users management' do
    describe 'GET /users' do
        it 'returns a status message' do
            get '/users', :headers => { Authorization: "Bearer #{@token}"}
            json = JSON.parse response.body
            expect(json['status']).to eql('SUCCESS')
            expect(response.status).to eql(200)
        end

        it 'supports getting an id parameter' do
            get '/users/1', :headers => { Authorization: "Bearer #{@token}"}
            json = JSON.parse response.body
            expect(json['status']).to eql('SUCCESS')
            expect(response.status).to eql(200)
        end

        it "returns a status message (ERROR) if the requested id doesn't exist" do
            get '/users/42', :headers => { Authorization: "Bearer #{@token}"}
            json = JSON.parse response.body
            expect(json['status']).to eql('ERROR')
            expect(response.status).to eql(404)
        end

        it 'return a status code 401 if missing authentication token' do
            get '/users'
            expect(response.status).to eql(401)
            get '/users/1'
            expect(response.status).to eql(401)
            get '/users/42'
            expect(response.status).to eql(401)
        end
    end

    describe 'POST /users' do
        it 'returns a status message (ERROR) if missing body' do
            post '/users', :headers => { Authorization: "Bearer #{@token}"}
            json = JSON.parse(response.body)
            expect(json['status']).to eql('ERROR')
            expect(response.status).to eql(422)
        end

        it 'returns a status message (ERROR) if missing parameter' do
            post '/users', :params => { prenom: 'Johnny' }, :headers => { Authorization: "Bearer #{@token}"}
            json = JSON.parse(response.body)
            expect(json['status']).to eql('ERROR')
            expect(response.status).to eql(422)
        end

        it 'returns a status message' do
            post '/users', :params => { nom: 'Test', prenom: 'Johnny', email: 'johnny@test.com', password: 'passtest', password_confirmation: 'passtest' }, :headers => { Authorization: "Bearer #{@token}"}
            json = JSON.parse(response.body)
            expect(json['status']).to eql('SUCCESS')
            expect(response.status).to eql(200)
        end

        it 'returns a status message (ERROR) if the mail already exists' do
            post '/users', :params => { nom: 'Test', prenom: 'Johnny', email: 'john@doe.com', password: 'passtest', password_confirmation: 'passtest'}, :headers => { Authorization: "Bearer #{@token}"}
            json = JSON.parse(response.body)
            expect(json['status']).to eql('ERROR')
            expect(response.status).to eql(422)
        end
    end

    describe 'POST /reset' do
        it 'returns a status message' do
            post '/reset', :params => { email: "john@doe.com" }
            json = JSON.parse(response.body)
            expect(json['status']).to eql('SUCCESS')
            expect(response.status).to eql(200)
        end

        it 'returns a status message (ERROR) if the user does not exist' do
            post '/reset', :params => { email: "someone@something.com" }
            json = JSON.parse response.body
            expect(json['status']).to eql('ERROR')
            expect(response.status).to eql(404)
        end
    end

    describe 'PATCH /users/:id' do
        it "returns a status message (ERROR) if the resquested id doesn't exists" do
            patch '/users/42', :headers => { Authorization: "Bearer #{@token}"}
            json = JSON.parse(response.body)
            expect(json['status']).to eql('ERROR')
            expect(response.status).to eql(404)
        end

        it 'returns a status message' do
            patch '/users/1', :headers => { Authorization: "Bearer #{@token}"}
            json = JSON.parse(response.body)
            expect(json['status']).to eql('SUCCESS')
            expect(response.status).to eql(200)
        end

        it 'return a status code 401 if missing authentication token' do
            patch '/users/42'
            expect(response.status).to eql(401)
            patch '/users/1'
            expect(response.status).to eql(401)
        end
    end

    describe "PATCH /confirm" do
        it 'returns a status message' do
            token = User.find(2).confirm_token
            patch '/confirm', :params => { token: token }
            json = JSON.parse response.body
            expect(json['status']).to eql('SUCCESS')
            expect(response.status).to eql(200)
        end

        it 'returns a status message (ERROR) if the email does not exist' do
            patch '/confirm', :params => { token: "bad token" }
            json = JSON.parse response.body
            expect(json['status']).to eql('ERROR')
            expect(response.status).to eql(404)
        end
    end

    describe 'PATCH /reset' do
        it 'returns a status message' do
            reset_token = User.find(2).reset_token
            patch '/reset', :params => { token: reset_token, password: "password", password_confirmation: "password" }
            json = JSON.parse response.body
            expect(json['status']).to eql('SUCCESS')
            expect(response.status).to eql(200)
        end

        it 'returns a status message (ERROR) if the token does not exist' do
            patch '/reset', :params => { token: "bad token", password: 'password', password_confirmation: 'password' }
            json = JSON.parse response.body
            expect(json['status']).to eql('ERROR')
            expect(response.status).to eql(404)
        end

        it 'returns a status message (ERROR) if the password and password_confirmation do not match' do
            reset_token = User.find(2).reset_token
            patch '/reset', :params => { token: reset_token, password: 'something', password_confirmation: 'something_else' }
            json = JSON.parse response.body
            expect(json['status']).to eql('ERROR')
            expect(response.status).to eql(422)
        end

        it 'supports getting a user_id to change the password giving the old password' do
            patch '/reset/3', :headers => { Authorization: "Bearer #{@token}" }, :params => { old_password: "1234", password: "password", password_confirmation: "password" }
            json = JSON.parse response.body
            expect(json['status']).to eql('SUCCESS')
            expect(response.status).to eql(200)
        end

        it 'returns a status message (ERROR) if the user does not exist' do
            patch '/reset/42', :headers => { Authorization: "Bearer #{@token}" }, :params => { old_password: "1234", password: "password", password_confirmation: "password" }
            json = JSON.parse response.body
            expect(json['status']).to eql('ERROR')
            expect(response.status).to eql(404)
        end

        it 'returns a status message (ERROR) if the old password does not match' do
            patch '/reset/3', :headers => { Authorization: "Bearer #{@token}" }, :params => { old_password: "bad_password", password: "password", password_confirmation: "password" }
            json = JSON.parse response.body
            expect(json['status']).to eql('ERROR')
            expect(response.status).to eql(422)
        end

        it 'returns a status message (ERROR) if the password and password_confirmation do not match' do
            patch '/reset/3', :headers => { Authorization: "Bearer #{@token}" }, :params => { old_password: "password", password: "something", password_confirmation: "something_else" }
            json = JSON.parse response.body
            expect(json['status']).to eql('ERROR')
            expect(response.status).to eql(422)
        end
    end

    describe 'DELETE /users/:id' do
        it "returns a status message (ERROR) if the resquested id doesn't exists" do
            delete '/users/42', :headers => { Authorization: "Bearer #{@token}"}
            json = JSON.parse(response.body)
            expect(json['status']).to eql('ERROR')
            expect(response.status).to eql(404)

        end

        it 'returns a status message' do
            delete '/users/1', :headers => { Authorization: "Bearer #{@token}"}
            json = JSON.parse(response.body)
            expect(json['status']).to eql('SUCCESS')
            expect(response.status).to eql(200)
        end
    end
end