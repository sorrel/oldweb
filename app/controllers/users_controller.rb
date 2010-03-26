class UsersController < ApplicationController

  def new
    @title = "Sign up"
    @user = User.new
  end
  
  def show
    @user = User.find(params[:id])
    @title = @user.name
  end
  
  def create
    @user = User.new(params[:user])
    
    # Check if it's valid, before trying to save it
    # and if it's not determine which values are problems...
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      @title = "Sign Up"
      #Clear the fields that failed
      @user.password = ""
      @user.password_confirmation = ""
      render 'new'
    end
  end
end