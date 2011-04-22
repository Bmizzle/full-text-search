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
      @totalclaimed = totalclaimed
      claim = {:email => params[:email], :amount => @totalclaimed}
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
end
