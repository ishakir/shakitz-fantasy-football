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
  def get_assigns(action, variable, params = nil) 
    
    get action, params
    return assigns(variable)
    
  end
  
  def assert_assigns_not_nil(action, variable, params = nil, message = nil)
    
    get action, params
    assert_not_nil assigns(variable), message
    
  end
  
  def can_view_action(action, params=nil)
    get action, params
    assert_response :success 
  end
  
  def can_view_template(action, params=nil)
    get action, params
    assert_template action
  end
  
  def can_view_layout(action, layout, params=nil)
    get action, params
    assert_template layout: layout
  end
  
end
