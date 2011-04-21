class ClaimMainsController < ApplicationController
  
  before_filter :require_user, :only => ['claim_it']
  
  def show
    @id = params[:id]
    @claim_main = ClaimMain.where({:id=>@id}).first
    
    if @claim_main.nil?      
      redirect_to("/404.html")
    end
    
    store_location
  end
  
  def claim_it
    @claim_main = ClaimMain.where({:id=>params[:id]}).first
    
    render :layout => false        
  end
  
  def email_to_friend
    
  end
end
