require_relative 'lib/marvel.rb'
require 'byebug'

namespace :marvel do
  # Mainly for testing and debugging
  task :get_the_characters do
    puts Marvel.new.get_the_characters
  end
  # Example: rake marvel:get_total_character_count
  task :get_total_character_count do
    count = Marvel.new.get_character_count
    puts "Total characters: #{count}"
  end

  # Example: rake marvel:get_character_thumbnail[1011136]
  task :get_character_thumbnail, [:id] do |t, args|
    id = args[:id].to_i
    puts Marvel.new.get_character_thumbnail(id)
  end

  # Example: rake marvel:people_in_comics[30090,160]
  task :people_in_comics, [:comic1_id,:comic2_id] do |t, args|
    comic1_id = args[:comic1_id].to_i
    comic2_id = args[:comic2_id].to_i

    puts Marvel.new.people_in_comics([comic1_id, comic2_id])
  end
end
