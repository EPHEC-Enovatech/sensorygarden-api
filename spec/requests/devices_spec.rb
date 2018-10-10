require 'rails_helper'

RSpec.configure do |config|

    require 'database_cleaner'

    config.use_transactional_fixtures = false
    DatabaseCleaner.strategy = :truncation

    config.before(:suite) do
        DatabaseCleaner.clean
        Rails.application.load_seed
    end

    config.after(:suite) do
        DatabaseCleaner.clean
    end
end

RSpec.describe 'Devices management' do
    describe 'GET /devices' do 
        it 'returns a status message' do
            get '/devices'
            json = JSON.parse response.body 
            expect(json['status']).to eql('SUCCESS')
            expect(response.status).to eql(200)
        end

        it 'supports getting a user_id parameter' do
            get '/devices/1'
            json = JSON.parse response.body 
            expect(json['status']).to eql('SUCCESS')
            expect(response.status).to eql(200)
        end

        it "returns a status message (ERROR) if the requested user_id doesn't exists" do
            get '/devices/42'
            json = JSON.parse response.body
            expect(json['status']).to eql('ERROR')
            expect(response.status).to eql(404)
        end
    end

    describe 'POST /devices/:user_id' do
        it 'returns a status message' do
            post '/devices/1', :params => { id: 'ABC000222', deviceName: "Test device", timestamp: DateTime.now }
            json = JSON.parse response.body
            expect(json['status']).to eql('SUCCESS')
            expect(response.status).to eql(200)
        end

        it 'returns a status message (ERROR) if missing body' do
            post '/devices/1'
            json = JSON.parse response.body 
            expect(json['status']).to eql('ERROR')
            expect(response.status).to eql(422)
        end

        it 'returns a status message (ERROR) if missing argument' do
            post '/devices/1', :params => { id: 'ABC000222', deviceName: "Test device" }
            json = JSON.parse response.body
            expect(json['status']).to eql('ERROR')
            expect(response.status).to eql(422)
        end

        it 'returns a status message (ERROR) if device_id already exists' do
            post 'devices/1', :params => { id: 'ABC000111', deviceName: "Test device", timestamp: DateTime.now }
            json = JSON.parse response.body
            expect(json['status']).to eql('ERROR')
            expect(response.status).to eql(422)
        end

        if "retuns a status message (ERROR) if the requested user_id doesn't exists" do
            post 'device/42', :params => { id: 'ABC000222', deviceName: "Test device", timestamp: DateTime.now }
            json = JSON.parse response.body
            expect(json['status']).to eql('ERROR')
            expect(response.status).to eql(404)
        end
    end
end