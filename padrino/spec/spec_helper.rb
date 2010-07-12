require 'rubygems'
require 'spec'

require 'padrino'

$:.unshift File.dirname(__FILE__)
$:.unshift File.join(File.dirname(__FILE__), '../lib')

# Load the init.
#
require File.join(File.dirname(__FILE__), '../init')