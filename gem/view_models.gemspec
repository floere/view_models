# encoding: utf-8
#
Gem::Specification.new do |s|
  s.name = %q{view_models}
  s.version = "2.0.0.ruby19"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Florian Hanke", "Kaspar Schiess", "Niko Dittmann", "Andreas Schacke"]
  s.description = %q{For Padrino and Rails 2 views. Adds the missing R (Representation) to Rails' MVC. Provides simple proxy functionality for your models, thus helps you keep the model and view representation separate. Define focused helper methods on the (view) model, more quickly understood and more easily testable. Also: Hierarchical rendering for your hierarchical models. So, in a nutshell: Polymorphism not just in the model, but also in the view. Have fun!}
  s.email = %q{florian.hanke@gmail.com}
  s.files = Dir[
    "lib/init.rb",
    "lib/padrino/README.textile",
    "lib/padrino/*.rb",
    "lib/padrino/lib/**/*.rb",
    
    "lib/rails2/README.textile",
    "lib/rails2/TODO.textile",
    "lib/rails2/generators/**/*",
    "lib/rails2/generators/**/*.rb",
    "lib/rails2/generators/**/*.html.erb",
    "lib/rails2/generators/**/*.html.haml",
    "lib/rails2/generators/**/*.text.erb",
     "lib/rails2/init.rb",
     "lib/rails2/lib/experimental/modules_in_render_hierarchy.rb",
     "lib/rails2/lib/**/*.rb",
     "lib/shared/README.textile",
     "lib/shared/init.rb",
     "lib/shared/lib/**/*.rb",
     "lib/view_models.rb"
  ]
  s.homepage = %q{http://floere.github.com/view_models}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{A model proxy for Rails views. Helps you keep the representation of a model and the model itself separate.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activesupport>, [">= 2.2.0"])
      s.add_development_dependency(%q<rspec>, [">= 1.2.9"])
    else
      s.add_dependency(%q<activesupport>, [">= 2.2.0"])
      s.add_dependency(%q<rspec>, [">= 1.2.9"])
    end
  else
    s.add_dependency(%q<activesupport>, [">= 2.2.0"])
    s.add_dependency(%q<rspec>, [">= 1.2.9"])
  end
end

