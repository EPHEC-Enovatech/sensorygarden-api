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

RSpec.describe 'Sensors management' do
    describe 'GET /sensors' do
        it 'returns a status message' do
            get '/sensors'
            json = JSON.parse response.body
            expect(json['status']).to eql("SUCCESS")
            expect(response.status).to eql(200)
        end

        it 'supports getting an id parameter' do
            get '/sensors/1'
            json = JSON.parse response.body
            expect(json['status']).to eql('SUCCESS')
            expect(response.status).to eql(200)
        end

        it "returns a status message (ERROR) if the requested id doesn't exist" do
            get '/sensors/42'
            json = JSON.parse response.body
            expect(json['status']).to eql('ERROR')
            expect(response.status).to eql(404)
        end
    end

    describe 'POST /sensors' do
        it 'returns a status message (ERROR) if missing body' do
            post '/sensors'
            json = JSON.parse response.body
            expect(json['status']).to eql('ERROR')
            expect(response.status).to eql(422)
        end

        it 'returns a status message (ERROR) if missing argument' do
            post '/sensors', :params => { sensorName: 'Test sensor' }
            json = JSON.parse response.body
            expect(json['status']).to eql('ERROR')
            expect(response.status).to eql(422)
        end

        it 'return a status message (SUCCESS)' do
            post '/sensors', :params => { sensorName: 'Test sensor', sensorUnit: 'Test unit'}
            json = JSON.parse response.body
            expect(json['status']).to eql('SUCCESS')
            expect(response.status).to eql(200)
        end
    end

    describe 'PATCH /sensors/:id' do
        it 'return a status message' do
            patch '/sensors/1'
            json = JSON.parse response.body
            expect(json['status']).to eql('SUCCESS')
            expect(response.status).to eql(200)
        end

        it "returns a status message (ERROR) if the requested id doesn't exist" do
            patch '/sensors/42'
            json = JSON.parse response.body
            expect(json['status']).to eql('ERROR')
            expect(response.status).to eql(404)
        end
    end

    describe 'DELETE /sensors/:id' do
        it 'return a status message' do
            delete '/sensors/2'
            json = JSON.parse response.body
            expect(json['status']).to eql('SUCCESS')
            expect(response.status).to eql(200)
        end

        it "return a status message (ERROR) if the requested id doesn't exist" do
            delete '/sensors/42'
            json = JSON.parse response.body
            expect(json['status']).to eql('ERROR')
            expect(response.status).to eql(404)
        end
    end
end
