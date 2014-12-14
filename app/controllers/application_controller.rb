# -*- encoding : utf-8 -*-
require 'illegal_state_error'
require 'active_record/validations'
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception

  ### Validation of controller parameters
  # params: as provided to you in a controller method
  before_action :set_transfer_amount

  def set_transfer_amount
    if session[:user_id]
      @transfer_amount = TransferRequest.where(status: 'pending', target_user_id: session[:user_id]).count
    else
      @transfer_amount = 0
    end
  end

  def validate_all_parameters(expected_params, params)
    expected_params.each do |parameter|
      next if params.key?(parameter)
      fail ArgumentError, "Expecting '#{parameter}' in params, but could not find it"
    end
  end

  def validate_user_session(user_id)
    fail ArgumentError, 'User is not authorised to perform this action' if session[:user_id] != user_id
  end

  def validate_at_least_number_of_parameters(expected_params, params, minimum_expected)
    parameters_found = []

    expected_params.each do |parameter|
      parameters_found.push(parameter) if params.key?(parameter)
    end

    return unless parameters_found.size < minimum_expected
    parameters_found_string = parameters_found.join(', ')
    fail ArgumentError, "Expected at least #{minimum_expected} but found #{parameters_found_string}"
  end

  def return_nfl_player_and_team_data
    players = NflPlayer.includes(:nfl_team)
    tmp = {}
    players.each do |player|
      player_tmp = { player: player }
      name_tmp = { team: player.nfl_team.name }
      tmp[player.id] = player_tmp.merge!(name_tmp)
    end
    tmp.to_json
  end

  def ok_response
    { response: 'OK', status: 200 }
  end

  ### Controller exception handling
  # Stuff that's going to return a 404
  rescue_from ActiveRecord::RecordNotFound do |error|
    trace_error(error)
    render file: "#{Rails.root}/public/404.html", layout: false, status: :not_found
  end

  def render_unprocessable_entity
    render file: "#{Rails.root}/public/422.html", layout: false, status: :unprocessable_entity
  end

  # Utility methods
  def render_internal_server_error
    render file: "#{Rails.root}/public/500.html", layout: false, status: :exception
  end

  # Stuff that's going to return a 422
  rescue_from ArgumentError do |error|
    trace_error(error)
    render_unprocessable_entity
  end

  rescue_from ActiveRecord::RecordInvalid do |error|
    trace_error(error)
    render_unprocessable_entity
  end

  # Stuff that's going to return a 500
  rescue_from IllegalStateError do |error|
    trace_error(error)
    render_internal_server_error
  end

  private

  def trace_error(error)
    Rails.logger.error error.message
    Rails.logger.error error.backtrace
  end
end
