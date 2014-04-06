class UserController < ApplicationController
  USER_ID_KEY = :user_id
  USER_NAME_KEY = :user_name
  TEAM_NAME_KEY = :team_name

  def create
    validate_all_parameters([USER_NAME_KEY, TEAM_NAME_KEY], params)

    user = User.new
    update_user_entity(user, params)

    redirect_to action: :show
  end

  def show
    @users = User.all
  end

  def update
    validate_all_parameters([USER_ID_KEY], params)
    validate_at_least_number_of_parameters([USER_NAME_KEY, TEAM_NAME_KEY], params, 1)

    user = User.find(params[USER_ID_KEY])
    update_user_entity(user, params)

    redirect_to action: :show
  end

  def delete
    validate_all_parameters([USER_ID_KEY], params)

    user = User.find(params[USER_ID_KEY])
    user.destroy!

    redirect_to action: :show
  end

  # Subroutines

  def update_user_entity(user, params)
    user.name = params[USER_NAME_KEY] if params.key?(USER_NAME_KEY)
    user.team_name = params[TEAM_NAME_KEY] if params.key?(TEAM_NAME_KEY)

    user.save!
  end
end
