require 'view_models'
require 'view_models/base'
require 'view_models/active_record'

require 'helpers/view'
require 'helpers/rails'

require 'view_models_generator'

ActionController::Base.send :helper, ViewModels::Helper::Rails
ActionController::Base.send :include, ViewModels::Helper::Rails