require 'helpers/helpers'

=begin
Planet
	-name
	-star_id
	-owner_id
	-position
	-size
	-temperature
	-air_quality
	-has n, :cities
=end

class Planet
  include DataMapper::Resource
  property :id, Serial
  property :name, String
  property :owner_id, Integer
  property :star_id, Integer
  property :position, Integer
  property :size, Integer
  property :temperature, Integer
  property :air_quality, Float
  
  belongs_to :star
  has n, :cities
  
  def randomize(i)
    self.name = Helpers.generate_name
    self.position = i
    self.size = 4
    self.temperature = 72
    self.air_quality = 0.9
    self.size.times do |i|
      city = self.cities.new
      city.randomize(i)
      unless city.save
        puts "ZOMG CITY HAS ERRORS!!!"
      end
    end
  end
  
  def url
    return Star.first(:id => self.star_id).url + "/#{name}"
  end
end