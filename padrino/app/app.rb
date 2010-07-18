require 'view_models'

class Application < Padrino::Application
  
  register Padrino::Mailer
  register Padrino::Helpers
  register ViewModels::Helpers
  
end