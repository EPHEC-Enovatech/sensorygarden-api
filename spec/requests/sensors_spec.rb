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

RSpec.describe 'Sensors management' do
    describe 'GET /sensors' do
        it 'returns a status message' do
            get '/sensors', :headers => { Authorization: "Bearer #{@token}"}
            json = JSON.parse response.body
            expect(json['status']).to eql("SUCCESS")
            expect(response.status).to eql(200)
        end

        it 'supports getting an id parameter' do
            get '/sensors/1', :headers => { Authorization: "Bearer #{@token}"}
            json = JSON.parse response.body
            expect(json['status']).to eql('SUCCESS')
            expect(response.status).to eql(200)
        end

        it "returns a status message (ERROR) if the requested id doesn't exist" do
            get '/sensors/42', :headers => { Authorization: "Bearer #{@token}"}
            json = JSON.parse response.body
            expect(json['status']).to eql('ERROR')
            expect(response.status).to eql(404)
        end

        it 'return a status code 401 if missing authentication token' do
            get '/sensors'
            expect(response.status).to eql(401)
            get '/sensors/1'
            expect(response.status).to eql(401)
            get '/sensors/42'
            expect(response.status).to eql(401)
        end
    end

    describe 'POST /sensors' do
        it 'returns a status message (ERROR) if missing body' do
            post '/sensors', :headers => { Authorization: "Bearer #{@token}"}
            json = JSON.parse response.body
            expect(json['status']).to eql('ERROR')
            expect(response.status).to eql(422)
        end

        it 'returns a status message (ERROR) if missing argument' do
            post '/sensors', :params => { sensorName: 'Test sensor' }, :headers => { Authorization: "Bearer #{@token}"}
            json = JSON.parse response.body
            expect(json['status']).to eql('ERROR')
            expect(response.status).to eql(422)
        end

        it 'return a status message (SUCCESS)' do
            post '/sensors', :params => { sensorName: 'Test sensor', sensorUnit: 'Test unit'}, :headers => { Authorization: "Bearer #{@token}"}
            json = JSON.parse response.body
            expect(json['status']).to eql('SUCCESS')
            expect(response.status).to eql(200)
        end

        it 'return a status code 401 if missing authentication token' do
            post '/sensors'
            expect(response.status).to eql(401)
            post '/sensors', :params => { sensorName: 'Test sensor' }
            expect(response.status).to eql(401)
            post '/sensors', :params => { sensorName: 'Test sensor', sensorUnit: 'Test unit'}
            expect(response.status).to eql(401)
        end

        it 'returns a status message (ERROR) if the user is not admin' do
            token =  Knock::AuthToken.new(payload: { sub: 2, admin: false }).token
            post '/sensors', :headers => { Authorization: "Bearer #{token}" }, :params => { sensorName: 'Test sensor 2', sensorUnit: 'Test Unit' }
            json = JSON.parse response.body
            expect(json['status']).to eql("ERROR")
            expect(response.status).to eql(401)
        end
    end

    describe 'PATCH /sensors/:id' do
        it 'return a status message' do
            patch '/sensors/1', :headers => { Authorization: "Bearer #{@token}"}
            json = JSON.parse response.body
            expect(json['status']).to eql('SUCCESS')
            expect(response.status).to eql(200)
        end

        it "returns a status message (ERROR) if the requested id doesn't exist" do
            patch '/sensors/42', :headers => { Authorization: "Bearer #{@token}"}
            json = JSON.parse response.body
            expect(json['status']).to eql('ERROR')
            expect(response.status).to eql(404)
        end

        it 'return a status code 401 if missing authentication token' do
            patch '/sensors/1'
            expect(response.status).to eql(401)
            patch '/sensors/42'
            expect(response.status).to eql(401)
        end
    end

    describe 'DELETE /sensors/:id' do
        it 'return a status message' do
            delete '/sensors/2', :headers => { Authorization: "Bearer #{@token}"}
            json = JSON.parse response.body
            expect(json['status']).to eql('SUCCESS')
            expect(response.status).to eql(200)
        end

        it "return a status message (ERROR) if the requested id doesn't exist" do
            delete '/sensors/42', :headers => { Authorization: "Bearer #{@token}"}
            json = JSON.parse response.body
            expect(json['status']).to eql('ERROR')
            expect(response.status).to eql(404)
        end

        it 'return a status code 401 if missing authentication token' do
            delete '/sensors/2'
            expect(response.status).to eql(401)
            delete '/sensors/42'
            expect(response.status).to eql(401)
        end
    end
end
