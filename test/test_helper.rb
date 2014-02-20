ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all
  self.use_instantiated_fixtures = true

  # Add more helper methods to be used by all tests here...
  def get_assigns(action, variable) 
    
    get action
    return assigns(variable)
    
  end
  
  def assert_assigns_not_nil(action, variable, message = nil)
    
    get action
    instance_variable = assigns(variable)
    
    assert_not_nil instance_variable, message
    
  end
  
end
