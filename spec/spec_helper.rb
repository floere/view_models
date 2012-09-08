$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', 'lib')
$LOAD_PATH.unshift File.dirname(__FILE__)
require 'rubygems' #1.8.7

require 'rspec'
# 
require 'rails'
require 'action_controller'
require 'active_support'
# 
require 'spec_helper_extensions'
include SpecHelperExtensions

require 'view_models'

RSpec.configure do |config|
  
end