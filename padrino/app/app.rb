# TODO Replace with
#      require 'view_models'
#
require File.join(File.dirname(__FILE__), '/../../gem/init.rb')

class Application < Padrino::Application
  
  register Padrino::Mailer
  register Padrino::Helpers
  register ViewModels::Helpers
  
end