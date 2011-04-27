class Authorization < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :user_id, :uid, :provider
  validates_uniqueness_of :uid, :scope => [:provider, :user_id]
  
  def self.find_from_hash(hash)
    find_by_provider_and_uid_and_login(hash['provider'], hash['uid'], true)
  end
  
  def self.create_from_hash(hash, user = nil)
    user ||= User.create_from_hash(hash)    
    Authorization.create(:user_id => user.id, :uid => hash['uid'], :provider => hash['provider'], :token =>(hash['credentials']['token'] rescue nil), :secret => (hash['credentials']['secret'] rescue nil))
  end
end
