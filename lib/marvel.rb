# Description:
# review the code below that uses the Marvel API (http://developer.marvel.com/).
# You may have to signup for a free account to test
# Please keep this code private (do not post on a public github)

# Tasks:
# - Refactor. Make something worth sharing.
# - Find the total number of characters in Marvel catalog
# - Grab a character from the list and display their thumbnail url
# - List just the character names in the comics id of 30090 and 162
# - Return updated code and steps to generate answers in email attachment.

require 'digest/md5'
require 'net/http'
require 'uri'
require 'byebug'
require 'JSON'
require 'dotenv'
Dotenv.load

class Marvel
  attr_reader :public_key, :private_key

  def initialize(private_key: ENV['PRIVATE_KEY'])
    @public_key  = 'acb9bf7870195e71cd36cfaea2a9099e'
    @private_key = private_key
  end

  def get_character_count
    get_the_characters['data']['total']
  end

  # Example ID: 1011136
  def get_character_thumbnail(id)
    single_character_response = make_api_call(
      "http://gateway.marvel.com/v1/public/characters/#{id}#{auth_params}")
    build_thumbnail_url(single_character_response)
  end

  def get_the_characters
    make_api_call(
      "http://gateway.marvel.com/v1/public/characters#{auth_params}")
  rescue
    nil
  end

  def people_in_comics(comic_ids_array = [])
    comic_ids = to_csv(comic_ids_array)

    parsed_response = make_api_call(
      "http://gateway.marvel.com/v1/public/characters"\
      "#{auth_params}&comics=#{comic_ids}")

    output_character_names(parsed_response)
  end

  private

  def make_api_call(target_uri)
    uri = URI.parse(target_uri)

    response = Net::HTTP.get_response(uri)

    parsed_response(response)
  end

  def parsed_response(response)
    response = JSON.parse(response.body)
    validate_response(response)
    response
  end

  def auth_params
    time_stamp = Time.now.to_i

    hash = Digest::MD5.hexdigest("#{time_stamp}#{@private_key}#{@public_key}")

    "?ts=#{time_stamp}&apikey=#{@public_key}&hash=#{hash}"
  end

  def to_csv(array)
    array.join(',')
  end

  def build_hash(time_stamp)
    Digest::MD5.hexdigest("#{time_stamp}#{@private_key}#{@public_key}")
  end

  def build_thumbnail_url(single_character_response)
    thumbnail_blob = single_character_response['data']['results']
      .first['thumbnail']

    path      = thumbnail_blob['path']
    extension = thumbnail_blob['extension']

    "#{path}.#{extension}"
  end

  def output_character_names(parsed_response)
    parsed_response['data']['results'].map do |character|
      character['name']
    end
  end

  def validate_response(response)
    response_code   = response['code']
    response_status = response['status']
    raise response_status unless response_code == 200
  end
end

# puts Marvel.new.get_the_characters
# comic_ids = [30090, 160]
# puts Marvel.new.people_in_comics(comic_ids)
# puts Marvel.new.get_character_count
# puts Marvel.new.get_character_thumbnail(1011136)
