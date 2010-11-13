require 'mongo_mapper'

class User
  include MongoMapper::Document
  
  key :uid, String, :required => true
  key :screen_name, String, :required => true
  key :name, String, :required => true
  
  def questions
    Question.where(:screen_name => screen_name)
  end
  
  def self.authenticate(auth_hash)
    user = User.find_by_uid(auth_hash['uid'].to_s)
    user ||= User.create!(
      :uid => auth_hash['uid'].to_s, 
      :screen_name => auth_hash['user_info']['nickname'],
      :name => auth_hash['user_info']['name']
    )
    user
  end
  
  def serializable_hash(include_questions = true)
    {
      :screen_name => self.screen_name,
      :questions => self.questions
    }
  end
end