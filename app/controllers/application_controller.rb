# -*- encoding : utf-8 -*-
require 'illegal_state_error'
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception

  ### Validation of controller parameters
  # params: as provided to you in a controller method
  def validate_all_parameters(expected_params, params)
    expected_params.each do |parameter|
      next if params.key?(parameter)
      fail ArgumentError, "Expecting '#{parameter}' in params, but could not find it"
    end
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

  ### Controller exception handling
  # Stuff that's going to return a 404
  rescue_from ActiveRecord::RecordNotFound do
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
  rescue_from ArgumentError do
    render_unprocessable_entity
  end

  rescue_from ActiveRecord::RecordInvalid do
    render_unprocessable_entity
  end

  # Stuff that's going to return a 500
  rescue_from IllegalStateError do
    render_internal_server_error
  end
end
