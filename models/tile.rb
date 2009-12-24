class Tile
  include DataMapper::Resource
  
  property :id, Serial
  property :city_id, Integer
  property :position, Integer
  property :has_building, Boolean, :default => false
  
  # resources
  # surface level
  property :sunshine, Integer, :default => 0
  property :wind, Integer, :default => 0
  property :wood, Integer, :default => 0
  property :minerals, Integer, :default => 0
  property :water, Integer, :default => 0
  property :marble, Integer, :default => 0
  # underground
  property :iron, Integer, :default => 0
  property :coal, Integer, :default => 0
  property :gold, Integer, :default => 0
  # deep underground
  property :crystal, Integer, :default => 0
  property :oil, Integer, :default => 0
  property :natural_gas, Integer, :default => 0
  
  belongs_to :city
  
  def randomize(i)
    self.position = i
    self.sunshine = rand(100).round
    self.wind = rand(100).round
    surface_remaining = 100
    self.wood = rand(surface_remaining).round
    surface_remaining -= self.wood
    self.minerals = rand(surface_remaining).round
    surface_remaining -= self.minerals
    self.water = rand(surface_remaining).round
    surface_remaining -= self.water
    self.marble = rand(surface_remaining).round
    self
  end
  
  def x_coordinate
    return position % self.city.size
  end
  
  def y_coordinate
    return (position / self.city.size).floor
  end
end

