ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'minitest/autorun'
require 'minitest/reporters'
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

class MiniTest::Spec
  include FactoryGirl::Syntax::Methods
end

class IntegrationTest < MiniTest::Spec
  include Rails.application.routes.url_helpers
  include ActionDispatch::Assertions::RoutingAssertions
  register_spec_type /integration$/, self
  register_spec_type /routes/, self
end