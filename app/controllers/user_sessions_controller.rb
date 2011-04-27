class UserSessionsController < ApplicationController
  before_filter :require_user, :only => :destroy
  
  def new
    @user_session = UserSession.new
    if current_user
      redirect_back_or_default search_path
    end
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])    
    if @user_session.save      
      flash[:notice] = "Login successful!"      
      redirect_back_or_default search_path
    else
      render :action => :new
    end
  end
  
  def destroy
    current_user_session.destroy
    session[:return_to] = nil
    flash[:notice] = "Logout successful!"
    redirect_back_or_default(root_path)
  end
  
end
