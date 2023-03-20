ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'


class ActiveSupport::TestCase
    include Devise::TestHelpers
  # Add more helper methods to be used by all tests here...
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  # rest of the codes in this file
end