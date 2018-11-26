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


RSpec.describe 'Devices management' do
    describe 'GET /devices' do 
        it 'returns a status message' do
            get '/devices', :headers => { Authorization: "Bearer #{@token}"}
            json = JSON.parse response.body 
            expect(json['status']).to eql('SUCCESS')
            expect(response.status).to eql(200)
        end

        it 'supports getting a user_id parameter' do
            get '/devices/1', :headers => { Authorization: "Bearer #{@token}"}
            json = JSON.parse response.body 
            expect(json['status']).to eql('SUCCESS')
            expect(response.status).to eql(200)
        end

        it "returns a status message (ERROR) if the requested user_id doesn't exists" do
            get '/devices/42', :headers => { Authorization: "Bearer #{@token}"}
            json = JSON.parse response.body
            expect(json['status']).to eql('ERROR')
            expect(response.status).to eql(404)
        end

        it 'return a status code 401 if missing authentication token' do
            get '/devices'
            expect(response.status).to eql(401)
            get '/devices/1'
            expect(response.status).to eql(401)
            get '/devices/42'
            expect(response.status).to eql(401)
        end
    end

    describe 'POST /devices/:user_id' do
        it 'returns a status message' do
            post '/devices/1', :params => { device_id: 'ABC000222', deviceName: "Test device", checksum: 87 }, :headers => { Authorization: "Bearer #{@token}"}
            json = JSON.parse response.body
            expect(json['status']).to eql('SUCCESS')
            expect(response.status).to eql(200)
        end

        it 'returns a status message (ERROR) if missing body' do
            post '/devices/1', :headers => { Authorization: "Bearer #{@token}"}
            json = JSON.parse response.body 
            expect(json['status']).to eql('ERROR')
            expect(response.status).to eql(422)
        end

        it 'returns a status message (ERROR) if missing argument' do
            post '/devices/1', :params => { device_id: 'ABC000222', checksum: 87 }, :headers => { Authorization: "Bearer #{@token}"}
            json = JSON.parse response.body
            expect(json['status']).to eql('ERROR')
            expect(response.status).to eql(422)
        end

        it 'returns a status message (ERROR) if device_id already exists' do
            post '/devices/1', :params => { device_id: 'ABC000111', deviceName: "Test device", checksum: 63 }, :headers => { Authorization: "Bearer #{@token}"}
            json = JSON.parse response.body
            expect(json['status']).to eql('ERROR')
            expect(response.status).to eql(422)
        end

        it "retuns a status message (ERROR) if the requested user_id doesn't exists" do
            post '/devices/42', :params => { device_id: 'DEF000333', deviceName: "Test device", checksum: 32 }, :headers => { Authorization: "Bearer #{@token}"}
            json = JSON.parse response.body
            expect(json['status']).to eql('ERROR')
            expect(response.status).to eql(404)
        end

        it 'return a status code 401 if missing authentication token' do
            post '/devices/1', :params => { device_id: 'ABC000222', deviceName: "Test device" }
            expect(response.status).to eql(401)
            post '/devices/1'
            expect(response.status).to eql(401)
            post '/devices/1', :params => { deviceName: 'Test device' }
            expect(response.status).to eql(401)
            post '/devices/1', :params => { device_id: 'ABC000111', deviceName: "Test device" }
            expect(response.status).to eql(401)
            post '/devices/42', :params => { device_id: 'DEF000333', deviceName: "Test device" }
            expect(response.status).to eql(401)
        end

        it 'return a status message (ERROR) if missing the checksum is incorrect' do
            post '/devices/1', :params => { device_id: 'ABC000222', deviceName: "Test device", checksum: 42 }, :headers => { Authorization: "Bearer #{@token}"}
            json = JSON.parse response.body
            expect(json['status']).to eql('ERROR')
            expect(response.status).to eql(422)
        end
    end

    describe 'PATCH /devices/:id' do
        it 'returns a status message' do
            patch '/devices/ABC000111', :params => { deviceName: "Test device 1" }, :headers => { Authorization: "Bearer #{@token}"}
            json = JSON.parse response.body
            expect(json['status']).to eql('SUCCESS')
            expect(response.status).to eql(200)
        end

        it "returns a status message (Error) if the requested device_id doesn't exists" do
            patch '/devices/ABC696969', :params => { deviceName: "Test device 1" }, :headers => { Authorization: "Bearer #{@token}"}
            json = JSON.parse response.body
            expect(json['status']).to eql('ERROR')
            expect(response.status).to eql(404)
        end

        it 'return a status code 401 if missing authentication token' do
            patch '/devices/ABC000111', :params => { deviceName: "Test device 1" }
            expect(response.status).to eql(401)
            patch '/devices/ABC696969', :params => { deviceName: "Test device 1" }
            expect(response.status).to eql(401)
        end
    end

    describe 'DELETE /devices/:id' do
        it 'returns a status message' do
            delete '/devices/ABC000111', :headers => { Authorization: "Bearer #{@token}"}
            json = JSON.parse response.body
            expect(json['status']).to eql('SUCCESS')
            expect(response.status).to eql(200)
        end

        it "returns a status message (ERROR) if the requested device_id doesn't exists" do
            delete '/devices/ABC696969', :headers => { Authorization: "Bearer #{@token}"}
            json = JSON.parse response.body
            expect(json['status']).to eql('ERROR')
            expect(response.status).to eql(404)
        end

        it 'return a status code 401 if missing authentication token' do
            delete '/devices/ABC000111'
            expect(response.status).to eql(401)
            delete '/devices/ABC696969'
            expect(response.status).to eql(401)
        end
    end
end