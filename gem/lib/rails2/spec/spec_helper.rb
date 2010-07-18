require 'rubygems'
require 'spec'

require 'active_support'
require 'action_controller'

$:.unshift File.dirname(__FILE__)
$:.unshift File.join(File.dirname(__FILE__), '../lib')

require File.join(File.dirname(__FILE__), '../init')

require 'spec_helper_extensions'
include SpecHelperExtensions