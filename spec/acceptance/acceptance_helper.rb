require File.dirname(__FILE__) + "/../spec_helper"
require "steak"
require 'capybara/rails'

DatabaseCleaner.strategy = :truncation

Spec::Runner.configure do |config|
  config.use_transactional_fixtures = false
  config.include Capybara, :type => :acceptance
  config.before(:each, :type => :acceptance) do
    DatabaseCleaner.clean
    Capybara.reset_sessions!
  end

  config.after(:all, :type => :acceptance) do
    DatabaseCleaner.clean  
  end
end

# Put your acceptance spec helpers inside /spec/acceptance/support
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}
