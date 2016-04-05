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
require "net/http"
require "uri"
require 'byebug'
require 'dotenv'
Dotenv.load

class Marvel
  attr_reader :public_key, :private_key

  def initialize(private_key: ENV['PRIVATE_KEY'])
    @public_key  = 'acb9bf7870195e71cd36cfaea2a9099e'
    @private_key = private_key
  end

  def get_the_characters
    uri = URI.parse(
      "http://gateway.marvel.com/v1/public/characters#{auth_params}")

    @response = Net::HTTP.get_response(uri)
    @response.body
  rescue
    nil
  end

def people_in_comics(comic_ids_array = [])
    comic_ids = to_csv(comic_ids_array)
    uri = URI.parse("http://gateway.marvel.com")
    http = Net::HTTP.new(uri.host, uri.port)

    request = Net::HTTP::Get.new(
      "/v1/public/characters#{auth_params}&limit=1&comics=#{comic_ids}")

    @response = http.request(request)
    @response.body
  end

  private

  def auth_params
    ts   = Time.now.to_i
    hash = Digest::MD5.hexdigest("#{ts}#{@private_key}#{@public_key}")
    "?ts=#{ts}&apikey=#{@public_key}&hash=#{hash}"
  end

  def to_csv(array)
    output = ''
    is_first = true

    array.each do |x|
      unless is_first
        output = output + ','
      end
      output = output + x.to_s
      is_first = false
      end
    return output
  end
end

# puts Marvel.new.get_the_characters
#comic_ids = [31068, 20367]
# puts people_in_comics(comic_ids)
