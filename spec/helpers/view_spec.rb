require File.join(File.dirname(__FILE__), '../spec_helper')

require 'helpers/view'

describe Representers::Helpers::View do

  # couldn't figure out how to test that
  # if Representers::Base.helper Representers::Helpers::View 
  # is called -> test that all_view_helpers.each are included in Base-Class
  # somehow I don't understand flexmock

end
