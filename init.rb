require 'extensions/active_record'
require 'extensions/model_reader'

require 'view_models'
require 'view_models/base'
require 'view_models/view'

require 'helpers/view'
require 'helpers/rails'
require 'helpers/collection'

# 
# ActionController::Base.send :helper, ViewModels::Helper::Rails
ActionController::Base.send :include, ViewModels::Helper::Rails
ActionView::Base.send       :include, ViewModels::Helper::Rails