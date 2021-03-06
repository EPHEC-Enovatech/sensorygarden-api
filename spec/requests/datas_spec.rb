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

RSpec.describe 'Data records management' do
    describe 'GET /records' do
        it 'returns a status message' do
            get '/records', :headers => { Authorization: "Bearer #{@token}"}
            json = JSON.parse response.body
            expect(json['status']).to eql('SUCCESS')
            expect(response.status).to eql(200)
        end

        it 'supports getting a device_id' do
            get '/records/ABC000111', :headers => { Authorization: "Bearer #{@token}"}
            json = JSON.parse response.body
            expect(json['status']).to eql('SUCCESS')
            expect(response.status).to eql(200)
        end

        it 'returns a status message (ERROR) if no records for requested device_id' do
            get '/records/ABC696969', :headers => { Authorization: "Bearer #{@token}"}
            json = JSON.parse response.body
            expect(json['status']).to eql('ERROR')
            expect(response.status).to eql(404)
        end

        it 'supports getting a data_type with the device_id' do
            get '/records/ABC000111/temperature', :headers => { Authorization: "Bearer #{@token}"}
            json = JSON.parse response.body
            expect(json['status']).to eql('SUCCESS')
            expect(response.status).to eql(200)
        end

        it 'returns a status message (ERROR) if the requested type does not exist' do
            get '/records/ABC000111/type_inconnu', :headers => { Authorization: "Bearer #{@token}"}
            json = JSON.parse response.body
            expect(json['status']).to eql('ERROR')
            expect(response.status).to eql(404)
        end

        it 'returns a status message (ERROR) if there is no record for the device and type requested' do
            get '/records/ABC000111/pression', :headers => { Authorization: "Bearer #{@token}"}
            json = JSON.parse response.body
            expect(json['status']).to eql('ERROR')
            expect(response.status).to eql(404)
        end

        it 'returns a status code 401 if missing authentification token' do
            get '/records'
            expect(response.status).to eql(401)
            get '/records/ABC000111'
            expect(response.status).to eql(401)
            get '/records/ABC000111/temperature'
            expect(response.status).to eql(401)
        end

        it 'support getting a date to return only the records for this date' do
            get '/records/ABC000111/temperature/17-10-2018', :headers => { Authorization: "Bearer #{@token}"}
            json = JSON.parse response.body
            expect(json['status']).to eql('SUCCESS')
            expect(response.status).to eql(200)
        end

        it 'returns a status message (ERROR) if there is no record for the device, type and date requested' do
            get '/records/ABC000111/temperature/17-10-2019', :headers => { Authorization: "Bearer #{@token}"}
            json = JSON.parse response.body
            expect(json['status']).to eql('ERROR')
            expect(response.status).to eql(404)
        end

        it 'supports getting a date range to return the records for this range' do
            get '/records/ABC000111/temperature/17-10-2018/19-10-2018', :headers => { Authorization: "Bearer #{@token}"}
            json = JSON.parse response.body
            expect(json['status']).to eql('SUCCESS')
            expect(response.status).to eql(200)
        end

        it 'returns a status message (ERROR) if there is no record for the device, type and date requested' do
            get '/records/ABC000111/temperature/17-10-2019/19-10-2019', :headers => { Authorization: "Bearer #{@token}"}
            json = JSON.parse response.body
            expect(json['status']).to eql('ERROR')
            expect(response.status).to eql(404)
        end

        it 'supports getting a "/last" endpoint plus a device_id to return the timestamp of the last record' do
            get '/records/ABC000111/temperature/last', :headers => { Authorization: "Bearer #{@token}" }
            json = JSON.parse response.body
            expect(json['status']).to eql('SUCCESS')
            expect(response.status).to eql(200)
        end

        it 'return a status message (ERROR) if there is no record for the device and/or type requested' do
            get '/records/ABC696969/type_inconnu/last', :headers => { Authorization: "Bearer #{@token}" }
            json = JSON.parse response.body
            expect(json['status']).to eql('ERROR')
            expect(response.status).to eql(404)
        end

        it 'supports getting a /records/:device_id/all/:date that returns all the data for the given day' do
            get '/records/ABC000111/all/17-10-2018', :headers => { Authorization: "Bearer #{@token}" }
            json = JSON.parse response.body
            expect(json['status']).to eql('SUCCESS')
            expect(response.status).to eql(200)
        end

        it 'returns a status message (ERROR) if thre is no record for the device for this day' do
            get '/records/ABC000111/all/17-10-2019', :headers => { Authorization: "Bearer #{@token}" }
            json = JSON.parse response.body
            expect(json['status']).to eql('ERROR')
            expect(response.status).to eql(404)
        end
    end

    describe 'POST /records/:data_type' do
        it 'returns a status message' do
            post '/records/temperature', :params => { device_id: "ABC000111", data: 15 }, :headers => { Authorization: "Bearer #{@token}"}
            json = JSON.parse response.body
            expect(json['status']).to eql('SUCCESS')
            expect(response.status).to eql(200)
        end

        it 'returns a status message (ERROR) if the device_id does not exist' do
            post '/records/temperature', :params => { device_id: "ABC696969", data: 15 }, :headers => { Authorization: "Bearer #{@token}"}
            json = JSON.parse response.body
            expect(json['status']).to eql('ERROR')
            expect(response.status).to eql(404)
        end

        it 'returns a status message (ERROR) if missing body' do
            post '/records/temperature', :headers => { Authorization: "Bearer #{@token}"}
            json = JSON.parse response.body
            expect(json['status']).to eql('ERROR')
            expect(response.status).to eql(422)
        end

        it 'return a status message (ERROR) if missing parameter' do
            post '/records/temperature', :params => { device_id: "ABC000111" }, :headers => { Authorization: "Bearer #{@token}"}
            json = JSON.parse response.body
            expect(json['status']).to eql('ERROR')
            expect(response.status).to eql(422)
        end

        it 'returns a status message (ERROR) if data_type does not exist' do
            post '/records/type_inconnu', :params => { device_id: "ABC000111", data: 15 }, :headers => { Authorization: "Bearer #{@token}"}
            json = JSON.parse response.body
            expect(json['status']).to eql('ERROR')
            expect(response.status).to eql(404)
        end
    end

    describe 'DELETE /records/:id' do
        it 'returns a status message' do
            delete '/records/1', :headers => { Authorization: "Bearer #{@token}"}
            json = JSON.parse response.body
            expect(json['status']).to eql('SUCCESS')
            expect(response.status).to eql(200)
        end

        it 'returns a status message (ERROR) if the id does not exist' do
            delete '/records/42', :headers => { Authorization: "Bearer #{@token}"}
            json = JSON.parse response.body
            expect(json['status']).to eql('ERROR')
            expect(response.status).to eql(404)
        end
    end

    it 'returns a status code 401 if missing authentification token' do
        delete '/records/1'
        expect(response.status).to eql(401)
        delete '/records/42'
        expect(response.status).to eql(401)
    end
end