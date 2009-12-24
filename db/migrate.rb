require 'rubygems'
require 'dm-core'
require 'dm-aggregates'
require 'dm-validations'
require 'dm-types'

DataMapper.setup(:default, {
  :adapter  => 'mysql',
  :host     => 'localhost',
  :username => 'root' ,
  :password => 'admin',
  :database => 'planet_prototype' # <-- fill in database name
})

# require models:
Dir.glob("#{File.expand_path(File.dirname(__FILE__))}/../models/*.rb").each do |f|
  require f
end

# This creates  your tables
DataMapper.auto_migrate!

# Set up admin user
admin = User.new(:username => "admin")
admin.password = "pass"
unless admin.save
  puts "uh ohs, could not create admin"
end

# Come up with some random star cluster names... most of which are hg2g references...
cluster_names = ["epsilon","sol","centauri","beetleguese","fordprefect","beeblebrox","arthurdent","zaphod","marvin"]
10.times do
  cluster_names.push Helpers.generate_name
end

# Set up the galaxy
100.times do
  star = Star.new
  star.randomize
  star.cluster = Helpers.pick_random(cluster_names)
  unless star.save
    puts "#{star.name} could not be created"
    pp star
  else
    print "."
  end
end