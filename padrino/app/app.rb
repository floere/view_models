require File.join(File.dirname(__FILE__), '/../../gem/lib/padrino/init')
# require 'view_models'

class Application < Padrino::Application
  
  register Padrino::Mailer
  register Padrino::Helpers
  register Padrino::ViewModels
  
end