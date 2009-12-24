require 'helpers/helpers'

class Star
  include DataMapper::Resource
  property :id, Serial
  property :name, String, :default => "star_name"
  property :cluster, String, :default => "star_cluster"
  property :brightness, Float, :default => -1.0
  property :size, Float, :default => -1
  property :x_coordinate, Integer, :default => 0
  property :y_coordinate, Integer, :default => 0
  property :color, Enum[:white,:blue,:orange,:brown,:red,:yellow], :default => :yellow
  property :galactic_arm, Enum[:north,:north_west,:west,:south_west,:south,:south_east,:east,:north_east], :default => :north
  property :galactic_sector, Enum[:core,:inner,:near,:middle,:far,:outer,:deep], :default => :core
  
  has n, :planets
  
  def randomize
    self.name = Helpers.generate_name
    self.brightness = rand
    self.size = rand
    self.x_coordinate = (rand*500).round
    self.y_coordinate = (rand*500).round
    self.color = Helpers.pick_random([:white,:blue,:orange,:brown,:red,:yellow])
    self.galactic_arm = Helpers.pick_random([:north,:north_west,:west,:south_west,:south,:south_east,:east,:north_east])
    self.galactic_sector = Helpers.pick_random([:core,:inner,:near,:middle,:far,:outer,:deep])
    
    # add some planets
    (1+rand*12).ceil.times do |i|
      planet = self.planets.new
      planet.randomize(i)
      planet.save
    end
  end 
  
  # returns a concise block of text describing the star, currently used in the star map hover text
  def get_info
    return self.full_name + "\n" + self.galactic_location
  end
  
  # the url that leads to the stars info
  def url
    return "/galaxy/#{self.galactic_arm}/#{self.galactic_sector}/#{self.cluster}/#{self.name}"
  end
  
  # the full name of the star, formatted correctly
  def full_name
    return self.cluster.gsub(/_/," ").capitalize + " " + self.name.capitalize
  end
  
  def galactic_location
    return self.galactic_arm.to_s.gsub(/_/,"").capitalize + " " + self.galactic_sector.to_s.capitalize
  end
end