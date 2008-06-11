require 'presenters'
require 'presenters/base'
require 'presenters/active_record'

require 'helpers/presenter_helper'

ActionController::Base.send :helper, PresenterHelper
ActionController::Base.send :include, PresenterHelper