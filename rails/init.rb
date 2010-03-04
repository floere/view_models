# require 'experimental/modules_in_render_hierarchy'

require 'extensions/active_record'
require 'extensions/model_reader'

require 'view_models'
require 'view_models/render_options'
require 'view_models/controller_extractor'
require 'view_models/path_store'
require 'view_models/base'
require 'view_models/view'

require 'helpers/view'
require 'helpers/rails'
require 'helpers/collection'

ActionController::Base.send :include, ViewModels::Helpers::Rails
ActionView::Base.send       :include, ViewModels::Helpers::Rails