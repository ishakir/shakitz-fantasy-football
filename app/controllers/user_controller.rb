class UserController < ApplicationController
  def show
    if params[:id].present?
      @user = User.find(params[:id])
    else 
      @users = User.all
    end
   
  end
  
  def create
    username = params[:username]
    User.create("name" => username)
  end
  
  def delete
    User.destroy(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    #we need to specifically permit the use of a value in the params
    #we can also do: params[:user], permit[:name] if we have a parent object
    if @user.update_attributes(params.permit(:name))
      flash[:success] = "Successfully edited user " + @user.name
      #handle success
    else
      #handle failure
      flash[:error] = "There was an error when trying to edit " + @user.name
    end
  end
end
