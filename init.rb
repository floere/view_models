require 'representers'
require 'representers/base'
require 'representers/active_record'

require 'helpers/representer_helper'

ActionController::Base.send :helper, RepresenterHelper
ActionController::Base.send :include, RepresenterHelper