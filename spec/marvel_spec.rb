require 'rspec'
require_relative 'spec_helper.rb'
require_relative '../marvel.rb'

RSpec.describe Marvel do
  describe '#auth_params' do
    it 'returns auth params for a given user' do
      private_key = '123abc'

      marvel = Marvel.new(
       private_key: private_key
      )

      expected_pattern = /\?ts=\d+&apikey=\w{32}&hash=\w{32}/

      auth_params = marvel.send(:auth_params)
      expect(auth_params).to match(expected_pattern)
    end
  end

  describe '#get_the_characters' do
    it 'calls the Marvel api' do
      stub = stub_request(
        :get, /http:\/\/gateway.marvel.com\/v1\/public\/characters\?apikey=.*/)

      Marvel.new.get_the_characters

      expect(stub).to have_been_requested
    end
  end
end
