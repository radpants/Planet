class ExampleModel
  include DataMapper::Resource
  property :id, Serial
  property :title, String
  
  validates_present :title
end