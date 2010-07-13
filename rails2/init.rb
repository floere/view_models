# require 'experimental/modules_in_render_hierarchy'

require 'view_models'
require File.join(File.dirname(__FILE__), '/../shared/init')
require 'view_models/base'
require 'view_models/view'

require 'helpers/view'
require 'helpers/collection'

ActionController::Base.send :include, ViewModels::Helpers::Mapping
ActionView::Base.send       :include, ViewModels::Helpers::Mapping