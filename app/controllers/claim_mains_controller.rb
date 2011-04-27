class ClaimMainsController < ApplicationController
  
  before_filter :require_user, :only => ['claim_it', 'email_to_friend']
  
  def show
    @id = params[:id]
    @claim_main = ClaimMain.where({:id=>@id}).first
    
    @claim_amount = ClaimAmount.find(:first, :conditions => {:user_id => current_user.id, :claim_main_id => @claim_main.id}) if current_user
    
    if !@claim_amount.nil?
      #flash[:alert] = "This amount is already claimed."
    end
    
    if @claim_main.nil?      
      redirect_to("/404.html")
    end
    
    store_location
  end
  
  def claim_it
    @claim_main = ClaimMain.where({:id=>params[:id]}).first    
    render :layout => false        
  end
  
  def claim
    id = params[:id]   
    @claim_main = ClaimMain.find(id)
    @claim_amount = ClaimAmount.find(:first, :conditions=> {:user_id => current_user.id, :claim_main_id => @claim_main.id})
    if !@claim_amount.nil?
      @is_claimed = true      
    else
      ClaimAmount.create({:user_id => current_user.id, :claim_main_id => @claim_main.id, :amount => @claim_main.dollars_remitted})
      @is_claimed = false
    end
    
    respond_to do |format|
      format.js
    end
  end
  
  def email_to_friend    
    if params[:commit] == 'Send'
      claim_main = ClaimMain.find(params[:id])
      claim = {:email => params[:email], :amount => claim_main.dollars_remitted, :user_id=>current_user.id, :claim_url=>claim_main_path(:id=>claim_main.id, :user_id=>current_user.id)}
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
  
  def search_friends
    
    @search_friends = []
    @names = []
    #facebook friends
    @fb_friends = current_user.facebook_friends  
    @fb_friends.each do |fb_friend|
      @names << fb_friend.name    
    end
    
    #twitter followrs
    @followers = current_user.twitter_followers
    @followers.each do |follower|
      @names << follower.name
    end
    
    #gmail contacts
    @contacts = current_user.contacts
    @contacts.each do |contact|
      @names << contact.username if !contact.username.nil?
    end
    
    #search in claim mails
    @names.each do |name|
      search = ClaimMain.solr_search do |s|
        s.keywords(name, {:fields => [:lastname, :firstname]})
      end
      
      search.results.each do |result|
        @search_friends << result
      end    
    end
    
  end
  
  def get_friends
    
    redirect_to search_friends_claim_mains_path
  end
end
