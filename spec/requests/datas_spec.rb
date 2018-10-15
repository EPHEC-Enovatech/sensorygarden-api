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

RSpec.describe 'Data records management' do
    describe 'GET /records' do
        it 'returns a status message' do
            get '/records'
            json = JSON.parse response.body
            expect(json['status']).to eql('SUCCESS')
            expect(response.status).to eql(200)
        end

        it 'supports getting a device_id' do
            get '/records/ABC000111'
            json = JSON.parse response.body
            expect(json['status']).to eql('SUCCESS')
            expect(response.status).to eql(200)
        end

        it 'returns a status message (ERROR) if no records for requested device_id' do
            get '/records/ABC696969'
            json = JSON.parse response.body
            expect(json['status']).to eql('ERROR')
            expect(response.status).to eql(404)
        end

        it 'supports getting a data_type with the device_id' do
            get '/records/ABC000111/temperature'
            json = JSON.parse response.body
            expect(json['status']).to eql('SUCCESS')
            expect(response.status).to eql(200)
        end

        it 'returns a status message (ERROR) if the requested type does not exist' do
            get '/records/ABC000111/type_inconnu'
            json = JSON.parse response.body
            expect(json['status']).to eql('ERROR')
            expect(response.status).to eql(404)
        end

        it 'returns a status message (ERROR) this there is no record for the device and type requested' do
            get '/records/ABC000111/pression'
            json = JSON.parse response.body
            expect(json['status']).to eql('ERROR')
            expect(response.status).to eql(404)
        end
    end

    describe 'POST /records/:data_type' do
        it 'returns a status message' do
            post '/records/temperature', :params => { device_id: "ABC000111", data: 15 }
            json = JSON.parse response.body
            expect(json['status']).to eql('SUCCESS')
            expect(response.status).to eql(200)
        end

        it 'returns a status message (ERROR) if the device_id does not exist' do
            post '/records/temperature', :params => { device_id: "ABC696969", data: 15 }
            json = JSON.parse response.body
            expect(json['status']).to eql('ERROR')
            expect(response.status).to eql(404)
        end

        it 'returns a status message (ERROR) if missing body' do
            post '/records/temperature'
            json = JSON.parse response.body
            expect(json['status']).to eql('ERROR')
            expect(response.status).to eql(422)
        end

        it 'return a status message (ERROR) if missing parameter' do
            post '/records/temperature', :params => { device_id: "ABC000111" }
            json = JSON.parse response.body
            expect(json['status']).to eql('ERROR')
            expect(response.status).to eql(422)
        end

        it 'returns a status message (ERROR) if data_type does not exist' do
            post '/records/type_inconnu', :params => { device_id: "ABC000111", data: 15 }
            json = JSON.parse response.body
            expect(json['status']).to eql('ERROR')
            expect(response.status).to eql(404)
        end
    end

    describe 'DELETE /records/:id' do
        it 'returns a status message' do
            delete '/records/1'
            json = JSON.parse response.body
            expect(json['status']).to eql('SUCCESS')
            expect(response.status).to eql(200)
        end

        it 'returns a status message (ERROR) if the id does not exist' do
            delete '/records/42'
            json = JSON.parse response.body
            expect(json['status']).to eql('ERROR')
            expect(response.status).to eql(404)
        end
    end
end