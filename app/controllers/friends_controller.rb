class FriendsController < ApplicationController
  
  before_filter :require_user
  
  def index        
    if auth_provider.provider == 'facebook'
      @fb_friends = current_user.facebook_friends
      @fb_status = current_user.facebook_status
    elsif auth_provider.provider == 'twitter'
      @followers = current_user.twitter_followers
      @t_status = current_user.twitter_status
    elsif auth_provider.provider == 'open_id'
      @contacts = current_user.contacts
    end
  end
  
  def user_friends
    provider = (params[:provider] ||= '')
#    provider = params[:provider] = auth_provider.provider if !auth_provider.nil?
    
        
    @search_friends = []
    @names = []
        
    if provider == 'facebook'     
      if current_user.authorization.find_by_provider('facebook').nil?
        redirect_to "/auth/facebook"
      end      
            
      @fb_friends = current_user.facebook_friends
      @fb_friends.each do |fb_friend|
        @names << {:name=>fb_friend.name,:uid=>fb_friend.facebook_uid,:provider=>"facebook"}
      end
      
    elsif provider == 'twitter'
      
      if current_user.authorization.find_by_provider('twitter').nil?
        redirect_to "/auth/twitter"        
      end
     
      @followers = current_user.twitter_followers
      @followers.each do |follower|
        @names << {:name=>follower.name, :uid=>follower.screen_name, :provider=>"twitter"}   
      end
      
    elsif provider == 'gmail'
      
      if current_user.authorization.find_by_provider('open_id').nil?
        redirect_to "/auth/open_id?openid_url=https://www.google.com/accounts/o8/id"        
      end
      
      @contacts = current_user.contacts
      @contacts.each do |contact|
        @names << {:name=>contact.username, :uid=>contact.email, :provider=>"gmail"} if !contact.username.nil?    
      end
      
    end
    
    #search in claim mails
    @names.each do |name|
      search = ClaimMain.solr_search do |s|
        s.keywords(name[:name], {:fields => [:lastname, :firstname]})
      end
      
      if !search.results.empty?
        @search_friends << name
      end
    end
  end
  
  def get_facebook_friends    
    facebook_friends         
    if params[:target_page] == 'user_friends'
      redirect_to user_friends_friends_path(:provider=>'facebook')
    else
      redirect_to friends_path(:source => 'facebook')  
    end    
  end
  
  def get_twitter_followers
    twitter_followers    
    if params[:target_page] == 'user_friends'
      redirect_to user_friends_friends_path(:provider=>'twitter')
    else
      redirect_to friends_path(:source => 'twitter')  
    end    
  end
  
  def get_contacts
    
    @contacts = Contacts::Gmail.new(params[:username], params[:password]).contacts
    
    @contacts.each do |contact|
      c = Contact.find_by_email(contact[1])
      c.update_attributes({:username => contact[0]}) if !c.nil?
      Contact.create({:user_id => current_user.id, :source => 'gmail', :username => contact[0], :email => contact[1]})
    end
    
    if params[:target_page] == 'user_friends'
      redirect_to user_friends_friends_path(:provider=>'gmail')
    else
      redirect_to friends_path(:source => 'open_id')
    end
    
  end
  
  private 
  
  def facebook_friends
    @fb = current_user.facebook
    @fb.fetch
    @fb_status = @fb.feed.first
    
    FacebookStatus.delete_all(:user_id => current_user.id)
    
#    FacebookStatus.create({
#      :user_id => current_user.id,
#      :facebook_status_id => @fb_status.identifier,
#      :name => @fb_status.name,
#      :link => @fb_status.link,
#      :caption => @fb_status.caption,
#      :description => @fb_status.description,
#      :source => @fb_status.source,
#      :status_type => @fb_status.type
#    })    
    
    @fb_friends = @fb.friends
    
    @fb_friends.each do |fb_friend|
      fb = current_user.facebook_friends.find_by_facebook_uid(fb_friend.identifier)
      fb.update_attributes({:name => fb_friend.name}) if !fb.nil?
      fb = FacebookFriend.create({:user_id => current_user.id, :facebook_uid => fb_friend.identifier, :name => fb_friend.name}) if fb.nil?      
    end
  end
  
  def twitter_followers
    
    @t = current_user.twitter
    
    @status = @t.user.status
    
    TwitterStatus.delete_all(:user_id => current_user.id)
    
#    TwitterStatus.create({
#      :user_id => current_user.id,
#      :twitter_status_id => @status.id,
#      :text => @status.text
#    })
        
    @followers = @t.followers.users
    
    @followers.each do |follower|    
      t = TwitterFollower.find_by_twitter_id_and_user_id(follower.id, current_user.id)
      t.update_attributes({:name => follower.name}) if !t.nil?
      t = TwitterFollower.create({:user_id => current_user.id, :twitter_id => follower.id, :name => follower.name, :screen_name => follower.screen_name}) if t.nil?
    end
  end
  
end
