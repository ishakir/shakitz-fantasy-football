class UserController < ApplicationController
  def show
    @users = User.all
  end

  def create
    validate_all_parameters([:user_name, :team_name], params)

    username = params[:user_name]
    teamname = params[:team_name]
    User.create!(name: username, team_name: teamname)

    redirect_to action: :show
  end

  def delete
    validate_all_parameters([:id], params)

    user = User.find(params[:id])
    user.destroy

    redirect_to action: :show
  end

  def update
    validate_all_parameters([:id], params)
    validate_at_least_number_of_parameters([:user_name, :team_name], params, 1)

    user = User.find(params[:id])
    update_user_entity(user, params)

    redirect_to action: :show
  end

  def update_user_entity(user, params)
    if params.key?(:user_name)
      user.name = params[:user_name]
    end
    if params.key?(:team_name)
      user.team_name = params[:team_name]
    end

    user.save!
  end
end
