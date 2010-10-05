require 'rubygems'

require 'spec'
require 'action_controller'

require File.expand_path File.join(File.dirname(__FILE__), '/../../lib/rails2/init')

require File.expand_path 'spec_helper_extensions', File.dirname(__FILE__)
include SpecHelperExtensions