this = File.dirname __FILE__

require File.join(this, '/../shared/init')

require File.join(this, '/lib/view_models/base')
require File.join(this, '/lib/helpers/collection')

Padrino::Application.send :include, ViewModels::Helpers::Mapping