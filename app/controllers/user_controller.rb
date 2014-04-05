class UserController < ApplicationController
  def show
    if params[:id].present?
      @user = User.find(params[:id])
    else
      @users = User.all
    end
  end

  def create
    validate_all_parameters([:user_name, :team_name], params)

    username = params[:user_name]
    teamname = params[:team_name]
    User.create!(name: username, team_name: teamname)
  end

  def delete
    validate_all_parameters([:id], params)

    user = User.find(params[:id])
    user.destroy
  end

  def update
    validate_all_parameters([:id], params)
    validate_at_least_number_of_parameters([:user_name, :team_name], params, 1)

    user = User.find(params[:id])

    if params.key?(:user_name)
      user.name = params[:user_name]
    end
    if params.key?(:team_name)
      user.team_name = params[:team_name]
    end

    user.save!
  end
end
