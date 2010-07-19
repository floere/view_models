this = File.dirname __FILE__

require File.join(this, '/../shared/init')

ViewModels::Helpers::Mapping

require File.join(this, '/lib/view_models/base')
require File.join(this, '/lib/helpers/collection')

require File.join(this, '/lib/padrino/view_models')