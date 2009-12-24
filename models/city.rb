class City
  include DataMapper::Resource  
  
  property :id, Serial
  property :planet_id, Integer
  property :name, String
  property :position, Integer
  property :city_size, Enum[:empty,:settlement,:village,:town,:city,:metropolis], :default => :empty
  belongs_to :planet
  has n, :tiles
  
  def randomize(i)
    self.position = i
    self.name = "Wilderness"
  end
  
  def settle
    self.update( :city_size => :settlement )
    (self.size*self.size).times do |i|
      tile = self.tiles.new
      tile.randomize(i)
      unless tile.save
        puts "Could not create tile"
        pp tile
      end
    end    
  end
  
  def increase_size
    new_size = case self.city_size
    when :settlement then :village
    when :village then :city
    when :city then :metropolis
    end
    
    self.update( :city_size => new_size )
  end
  
  def size
    return case self.city_size
    when :empty then 0
    when :settlement then 3
    when :village then 4
    when :town then 6
    when :city then 9
    when :metropolis then 13
    end
  end
end