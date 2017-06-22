class SessionsController < ApplicationController

  before_action require_logged_in

  def new
    #@session = Session.new
    render :new
  end

  def create
    user = User.find_by_credentials(params[:user][:username],
                                    params[:user][:password]
                                    )
    if user.nil?
      flash.now[:errors] = ["Invalid Username or Password"]
      render :new
    else
      login_user!(user)
      redirect_to cats_url
    end
  end


end
