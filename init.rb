require 'representers'
require 'representers/base'
require 'representers/active_record'

require 'helpers/view'
require 'helpers/rails'

ActionController::Base.send :helper, Representers::Helper::Rails
ActionController::Base.send :include, Representers::Helper::Rails