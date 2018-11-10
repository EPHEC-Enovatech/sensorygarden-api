require 'rails_helper'

RSpec.describe 'Contact section endpoints' do 
    describe 'POST /contact' do 
        it 'returns a status message' do
            post '/contact', params: { nom: 'Test', email: 'test@testing.com', message: 'Testing tests, tests and tests...'}
            json = JSON.parse response.body
            expect(json['status']).to eql('SUCCESS')
            expect(response.status).to eql(200)
        end

        it 'returns a status message (ERROR) if missing an argument' do
            post '/contact', params: { nom: 'Test', email: 'test@testing.com'}
            json = JSON.parse response.body
            expect(json['status']).to eql('ERROR')
            expect(response.status).to eql(422)
        end
    end
end