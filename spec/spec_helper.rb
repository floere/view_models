require 'spec'
require 'flexmock'
require 'active_support'
require 'action_controller'

$:.unshift File.dirname(__FILE__)
$:.unshift File.join(File.dirname(__FILE__), '../lib')

require File.join(File.dirname(__FILE__), '../init')

# Set up flexmock as mock framework
Spec::Runner.configure do |config|
  config.mock_with :flexmock
end

require 'spec_helper_extensions'
include SpecHelperExtensions