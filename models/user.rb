require 'helpers/helpers'
require 'digest/sha1'

class User
  include DataMapper::Resource
  property :id, Serial
  property :username, String
  property :hashed_password, String
  property :salt, String
  property :created_at, DateTime, :default => DateTime.now
  property :last_login, DateTime
  property :last_save, DateTime
  
  property :cash, Integer, :default => 0
  property :cash_flow, Integer, :default => 2
  
  validates_present :username
  
  def password=(pass)
    @password = pass
    self.salt = Helpers.random_string(10)
    self.hashed_password = User.encrypt(@password, self.salt)
  end
  
  def projection
    t = self.last_save.nil? ? ( self.last_login.nil? ? DateTime.now : self.last_login ) : self.last_save
    last = (t.yday*24*60*60) + (t.hour*60*60) + (t.min*60) + (t.sec)
    t = DateTime.now
    now = (t.yday*24*60*60) + (t.hour*60*60) + (t.min*60) + (t.sec)
    seconds_passed = now - last
    self.update :cash => ( self.cash + seconds_passed * self.cash_flow )    
  end
  
  def self.encrypt(pass, salt)
    Digest::SHA1.hexdigest(pass + salt)
  end
  
  def self.authenticate(username, password)
    u = User.first(:username => username)
    return nil if u.nil?
    if User.encrypt(password, u.salt) == u.hashed_password
      u.projection
      u.update :last_login => Time.now
      return u
    end
  end
end