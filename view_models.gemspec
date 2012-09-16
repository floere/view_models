$LOAD_PATH << File.join(File.dirname(__FILE__), 'lib')
require 'view_models/version'

Gem::Specification.new do |s|
  s.name        = "view_models"
  s.version     = ViewModels::VERSION.dup
  s.authors     = ["Florian Hanke", "Kaspar Schiess", "Beat Richartz"]
  s.date        = Time.now.strftime("%Y-%m-%d")
  s.email       = "support@viewmodels.com"
  s.homepage    = "http://florianhanke.com/view_models/"
  s.summary     = "The missing R to the Rails MVC"
  s.description = "The missing R to the Rails MVC"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'activesupport', '>= 3.0.0'
  s.add_dependency 'actionpack',    '>= 3.0.0'

  s.add_development_dependency 'appraisal',           '~> 0.4.0'
  s.add_development_dependency 'aruba'  
  s.add_development_dependency 'bundler',             '>= 1.1.0'
  s.add_development_dependency 'cucumber-rails',      '>= 1.3.0'
  s.add_development_dependency 'cucumber',            '~> 1.2.0'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'factory_girl_rails',  '~> 1.7.0'
  s.add_development_dependency 'factory_girl',        '~> 2.6.4'
  s.add_development_dependency 'slim-rails',          '~> 1.0.0'
  s.add_development_dependency 'rails',               '>= 3.0'
  s.add_development_dependency 'rake',                '>= 0.8.7'
  s.add_development_dependency 'rspec-rails',         '~> 2.11.0'
end
