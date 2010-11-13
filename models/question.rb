require 'mongo_mapper'

class Question
  include MongoMapper::Document
  
  key :screen_name, String, :required => true
  key :text, String, :required => true
  timestamps!
  
  def user
    User.find_by_screen_name(screen_name)
  end
end
