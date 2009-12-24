require 'rubygems'
require 'sinatra'
require 'dm-core'
require 'dm-aggregates'
require 'dm-validations'
require 'dm-types'
require 'pp'

require 'helpers/helpers'

configure do
  APP_NAME = 'Sinatra App'
  enable :sessions
  DataMapper.setup(:default, {
    :adapter  => 'mysql',
    :host     => 'localhost',
    :username => 'root' ,
    :password => 'admin',
    :database => 'planet_prototype' # <-- fill in database name
  })
  Dir.glob("#{File.expand_path(File.dirname(__FILE__))}/models/*.rb").each do |f|
    require f
  end  
end

error do
  puts "Exception! #{request.env['sinatra.error']}"
  erb :five_hundred
end

helpers do  
  # Renders a partial
  def partial(page, options={})
    erb page, options.merge!(:layout => false)
  end
  
  # Returns the current logged in user
  def current_user
    return User.first(:id => session['user_id'])
  end
  
  # To check if you are logged in or not
  def logged_in?
    return true if session['user_id']
    return false if session['user_id'].nil?
  end
  
  def comma_deliminate(num)
    return num.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1,")
  end
end

# home
# ----------------------------------------------------------------
get '/' do
  if logged_in?
    redirect '/dashboard'
  else
    erb :index
  end
end

get '/dashboard' do
  if logged_in? 
    current_user.projection
    erb :dashboard
  else
    redirect '/'
  end
end

# accounts
# ----------------------------------------------------------------
get '/sign_up' do
  erb :sign_up
end

post '/sign_up' do
  @user = User.new
  @user.username = params[:username]
  @user.password = params[:password]
  if @user.save
    session['user'] = @user
    redirect '/dashboard'
  else
    erb :sign_up
  end
end

post '/login' do
  @user = User.new(:username => params[:username])
  @user.password = params[:password]
  if @user = User.authenticate(@user.username,params[:password])
    session['user_id'] = @user.id
    redirect '/dashboard'
  else
    erb :login
  end
end

get '/logout' do
  session['user_id'] = nil
  redirect '/'
end

get '/user/profile/:id' do
  @user = User.first( :id => params[:id] )
  erb :profile
end

post '/save' do
  if current_user.update(:cash => params["cash"].to_i, :last_save => DateTime.now)
    true
  else
    puts "Error: User data could not be saved"
    puts params.inspect
    false
  end
end

# galaxy views
# ----------------------------------------------------------------

get '/galaxy' do
  @star_count = Star.count
  erb :galaxy
end

get '/galaxy/:arm' do
  @arm = params[:arm]
  @star_count = Star.count :galactic_arm => @arm
  @stars = Star.all( :galactic_arm => params[:arm] )
  erb :sectors
end

get '/galaxy/:arm/:sector' do
  @arm = params[:arm]
  @sector = params[:sector]
  @stars = Star.all( :galactic_arm => @arm, :galactic_sector => @sector )
  @clusters = []
  @stars.each do |star|
    unless @clusters.include?(star.cluster)
      @clusters.push star.cluster
    end
  end
  erb :clusters
end

get '/galaxy/:arm/:sector/:cluster' do
  @arm = params[:arm]
  @sector = params[:sector]
  @cluster = params[:cluster]
  @stars = Star.all( :galactic_arm => @arm, :galactic_sector => @sector, :cluster => @cluster )
  erb :stars
end

get '/galaxy/:arm/:sector/:cluster/:star' do
  @arm = params[:arm]
  @sector = params[:sector]
  @cluster = params[:cluster]
  @star = Star.first( :galactic_arm => @arm, :galactic_sector => @sector, :cluster => @cluster, :name => params[:star] )
  erb :star
end

get '/galaxy/:arm/:sector/:cluster/:star/:planet' do
  @arm = params[:arm]
  @sector = params[:sector]
  @cluster = params[:cluster]
  @star = Star.first( :galactic_arm => @arm, :galactic_sector => @sector, :cluster => @cluster, :name => params[:star] )
  @planet = Planet.first( :star_id => @star.id, :name => params[:planet] )
  erb :planet
end

get '/city/:city_id' do
  @city = City.first( :id => params[:city_id] )
  erb :city
end

# gameplay
# ----------------------------------------------------------------

get '/colonize/:planet_id' do
  # well... we should probobly check whether they are able to do this at this point... but... ehhhhhh.
  if logged_in?
    planet = Planet.first( :id => params[:planet_id] )
    planet.owner_id = current_user.id
    planet.save
    redirect planet.url
  else
    redirect '/'
  end
end

get '/settle/:city_id' do
  if logged_in?
    @city = City.first( :id => params[:city_id] )
    erb :settle
  else
    redirect "/city/#{city.id}"
  end
end

post '/settle/:city_id' do
  # once again, we should check things, but... what the hell
  city = City.first( :id => params[:city_id] )
  puts "city owner: #{city.planet.owner_id}"
  puts "current user: #{current_user.id}"
  puts "logged in: #{logged_in?}"
  if logged_in? and city.planet.owner_id == current_user.id
    city.settle
    city.update( :name => params[:city_name] )
  end
  redirect "/city/#{city.id}"
end

get '/build/:tile_id' do
  "here's where you'd build things, but for now... just hit the back button"
end


# fanciness!!!
# ----------------------------------------------------------------
get '/star_map' do
  @stars = Star.all
  erb :star_map
end