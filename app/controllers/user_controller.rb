class UserController < ApplicationController
  def viewall
    @users = User.all
  end
  
  def show
    @user = User.find(params[:id])
  end
end
