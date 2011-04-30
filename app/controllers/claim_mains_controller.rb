class ClaimMainsController < ApplicationController
  
  before_filter :require_user, :only => ['claim_it', 'email_to_friend', 'send_to_facebook', 'send_to_twitter']
  
  def show
    @id = params[:id]
    @claim_main = ClaimMain.where({:id=>@id}).first
    
    @claim_amount = ClaimAmount.find(:first, :conditions => {:claim_main_id => @claim_main.id}) if current_user   
        
    if @claim_main.nil?      
      redirect_to("/404.html")
    end
    
    store_location
  end
  
  def claim_it
    @claim_main = ClaimMain.where({:id=>params[:id]}).first
    
    @provider = params[:provider]
    @screen_name = params[:screen_name]    
    @uid = params[:uid]
    @is_right_user = true
    
    #is_right_user
    if @provider == 'twitter'
      twitter = TwitterFollower.where(:screen_name => @screen_name).first
      @is_right_user = false if auth_provider.nil?
      @is_right_user = false if (!auth_provider.nil? && auth_provider.uid != twitter.twitter_id)
    elsif @provider == 'facebook'
      @is_right_user = false if auth_provider.nil?
      @is_right_user = false if (!auth_provider.nil? && auth_provider.uid != @uid)
    end
    
    render :layout => false        
  end
  
  def claim
    id = params[:id]   
    tracker_user_id = nil
    tracker_user_id = params[:tracker_user_id] if(current_user.id.to_s != params[:tracker_user_id]) 
    
    @claim_main = ClaimMain.find(id)
    @claim_amount = ClaimAmount.find(:first, :conditions=> {:claim_main_id => @claim_main.id})
    if !@claim_amount.nil?
      @is_claimed = true      
    else      
      ClaimAmount.create({:user_id => current_user.id, :claim_main_id => @claim_main.id, :amount => @claim_main.dollars_remitted, :tracker_user_id => tracker_user_id})
      @is_claimed = false
      
      #check facebook
      if !auth_provider.nil? && auth_provider.provider == "facebook"
        @fb = current_user.facebook
        @fb.feed!(
          :message => "I found $#{@claim_main.dollars_remitted.to_f} on ClaimVille.com. Find you missing money",
          :link => 'http://www.claimville.com',
          :name => 'ClaimVille'
        )       
      elsif !auth_provider.nil? && auth_provider.provider == "twitter"
        @t = current_user.twitter
        @t.update("I found $#{@claim_main.dollars_remitted.to_f} on ClaimVille.com. Find you missing money Via @ClaimVille")
      end
    end
    
    respond_to do |format|
      format.js
    end
  end
  
  def email_to_friend    
    if params[:commit] == 'Send'
      claim_main = ClaimMain.find(params[:id])
      claim = {:email => params[:email], :amount => claim_main.dollars_remitted, :user_id=>current_user.id, :claim_url=>claim_main_url(:id=>claim_main.id, :tracker_user_id=>current_user.id)}
      if ENV['RAILS_ENV'] == "development"
        friendmail = Notifier.email_to_friend(claim)
        logger.debug friendmail
      elsif ENV['RAILS_ENV'] == "production"
        Notifier.email_to_friend(claim).deliver      
      end
      
      flash[:notice] = "Mail Successfully sent."
      
      redirect_to :back
    end
  end
  
  def send_to_facebook
    
    id = params[:id]
    uid = params[:uid]
    tracker_user_id = current_user.id
    name = params[:name] 
    
    url = claim_main_url(:id=>id, :tracker_user_id=>current_user.id, :uid=>uid, :provider => 'facebook')
    
    claim_main = ClaimMain.find(id)   
    
    #check amount is claim or not   
    claim_amount = ClaimAmount.where(:claim_main_id => id, :user_id => current_user.id).first
    if !claim_amount.nil?
      title = "I found $#{claim_main.dollars_remitted.to_f} on ClaimVille.com. Find you missing money"
    else
      title = "I found $#{claim_main.dollars_remitted.to_f} on ClaimVille.com for #{name} check it out #{url}"
    end
        
    facebook = current_user.authorization.find_by_provider('facebook') 
    if facebook.nil?
        store_location
        redirect_to "/auth/facebook"
    else
      @fb = FbGraph::User.me(facebook.token)
      if uid.nil?
        @fb.feed!(:message => title, :link => 'http://www.claimville.com', :name => 'ClaimVille')
      else
        @fb.feed!(:message => title, :link => 'http://www.claimville.com', :name => 'ClaimVille', :to => [{:id => uid.to_s, :name => name}])      
      end      
      redirect_to :back
    end        
  end  
end
