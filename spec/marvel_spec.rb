require 'rspec'
require_relative 'spec_helper.rb'
require_relative '../lib/marvel.rb'

RSpec.describe Marvel do
  before(:all) do
    @marvel = Marvel.new(
      private_key: '123_fake_key'
    )
  end

  describe '#auth_params' do
    it 'returns auth params for a given user' do
      expected_pattern = /\?ts=\d+&apikey=\w{32}&hash=\w{32}/

      auth_params = @marvel.send(:auth_params)
      expect(auth_params).to match(expected_pattern)
    end
  end

  describe '#to_csv' do
    it 'transforms and array of comic ids into encoded string' do
      comic_ids = [123,456,678]

      encoded_ids = @marvel.send(:to_csv, comic_ids)

      expect(encoded_ids).to eq('123,456,678')
    end
  end

  describe '#get_the_characters' do
    it 'calls the api then returns body' do
      stub = stub_request(
        :get, /http:\/\/gateway.marvel.com\/v1\/public\/characters\?apikey=\w+&hash=\w+&ts=\d+/).to_return(:body => "{\"code\":200}")

      parsed_response = @marvel.get_the_characters

      expect(stub).to have_been_requested
      expect(parsed_response).to eq({ 'code' => 200 })
    end
  end
end
