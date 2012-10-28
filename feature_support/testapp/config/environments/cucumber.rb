# -*- encoding : utf-8 -*-
# use "test" settings
eval File.read(File.join(File.dirname(__FILE__), 'test.rb'))

Testapp::Application.configure do

  # controller
  config.action_controller.allow_forgery_protection = true
  # views
  # config.action_view.cache_template_loading = true
end
