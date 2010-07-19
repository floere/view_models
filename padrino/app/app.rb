require 'view_models'

class Application < Padrino::Application
  
  register Padrino::Mailer
  register Padrino::Helpers
  register Padrino::ViewModels
  
end