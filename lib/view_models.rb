require 'view_models/extensions/model_reader'

require 'view_models/helpers/mapping'
require 'view_models/helpers/collection'
require 'view_models/helpers/view'

require 'view_models/path_store'
require 'view_models/render_options'
require 'view_models/context_extractor'
require 'view_models/base'

require 'view_models/view'

ActionController::Base.send :include, ViewModels::Helpers::Mapping
ActionView::Base.send       :include, ViewModels::Helpers::Mapping
