require 'rubygems'

# require 'bundler'
# Bundler.require :default, :rails2

require 'spec'

require 'action_controller'

require File.join(File.dirname(__FILE__), '/../../lib/rails2/init')

require File.join(File.dirname(__FILE__), 'spec_helper_extensions')
include SpecHelperExtensions