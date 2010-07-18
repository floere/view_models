require 'view_models'
# require File.join(File.dirname(__FILE__), '/../../gem/view_models.rb')

class Application < Padrino::Application
  
  register Padrino::Mailer
  register Padrino::Helpers
  register ViewModels::Helpers
  
end