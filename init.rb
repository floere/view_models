require 'view_models'
require 'view_models/base'
require 'view_models/view'

require 'helpers/view'
require 'helpers/rails'
require 'helpers/collection'

require 'extensions/active_record'

ActionController::Base.send :helper, ViewModels::Helper::Rails
ActionController::Base.send :include, ViewModels::Helper::Rails