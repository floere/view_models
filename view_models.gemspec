# Generated by jeweler
# DO NOT EDIT THIS FILE
# Instead, edit Jeweler::Tasks in Rakefile, and run `rake gemspec`
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{view_models}
  s.version = "1.5.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Florian Hanke", "Kaspar Schiess", "Niko Dittmann", "Andreas Schacke"]
  s.date = %q{2010-03-01}
  s.description = %q{The view models gem adds the missing R (Representation) to Rails' MVC. It provides simple proxy functionality for your models and thus helps you keep the model and view representations of a model separate, as it should be. Also, you can define helper methods on the (view) model instead of globally to keep them focused, more quickly understood and more easily testable. View Models also introduce hierarchical rendering for your hierarchical models. If the account view is not defined for the subclass FemaleUser, it checks if it is defined for User, for example, to see when there is no specific view, if there is a general view. So, in other words: Polymorphism not just in the model, but also in the view. Have fun!}
  s.email = %q{florian.hanke@gmail.com}
  s.extra_rdoc_files = [
    "README.textile"
  ]
  s.files = [
    "CHANGELOG",
     "MIT-LICENSE",
     "README.textile",
     "Rakefile",
     "VERSION.yml",
     "generators/view_models/USAGE",
     "generators/view_models/templates/README",
     "generators/view_models/templates/spec/view_model_spec.rb",
     "generators/view_models/templates/view_models/view_model.rb",
     "generators/view_models/templates/views/_empty.html.haml",
     "generators/view_models/templates/views/view_models/collection/_collection.html.erb",
     "generators/view_models/templates/views/view_models/collection/_collection.html.haml",
     "generators/view_models/templates/views/view_models/collection/_collection.text.erb",
     "generators/view_models/templates/views/view_models/collection/_list.html.erb",
     "generators/view_models/templates/views/view_models/collection/_list.html.haml",
     "generators/view_models/templates/views/view_models/collection/_list.text.erb",
     "generators/view_models/templates/views/view_models/collection/_pagination.html.haml",
     "generators/view_models/templates/views/view_models/collection/_pagination.text.erb",
     "generators/view_models/templates/views/view_models/collection/_table.html.haml",
     "generators/view_models/templates/views/view_models/collection/_table.text.erb",
     "generators/view_models/view_models_generator.rb",
     "lib/extensions/active_record.rb",
     "lib/extensions/model_reader.rb",
     "lib/extensions/view.rb",
     "lib/helpers/collection.rb",
     "lib/helpers/rails.rb",
     "lib/helpers/view.rb",
     "lib/view_models.rb",
     "lib/view_models/base.rb",
     "lib/view_models/controller_extractor.rb",
     "lib/view_models/path_store.rb",
     "lib/view_models/render_options.rb",
     "lib/view_models/view.rb",
     "rails/init.rb",
     "spec/integration/integration_spec.rb",
     "spec/integration/models/sub_subclass.rb",
     "spec/integration/models/subclass.rb",
     "spec/integration/view_models/project.rb",
     "spec/integration/view_models/sub_subclass.rb",
     "spec/integration/view_models/subclass.rb",
     "spec/integration/views/view_models/collection/_collection.html.erb",
     "spec/integration/views/view_models/collection/_collection.text.erb",
     "spec/integration/views/view_models/collection/_list.html.erb",
     "spec/integration/views/view_models/collection/_list.text.erb",
     "spec/integration/views/view_models/sub_subclass/_capture_in_template.erb",
     "spec/integration/views/view_models/sub_subclass/_capture_in_view_model.erb",
     "spec/integration/views/view_models/sub_subclass/_collection_example.html.erb",
     "spec/integration/views/view_models/sub_subclass/_collection_example.text.erb",
     "spec/integration/views/view_models/sub_subclass/_collection_item.html.erb",
     "spec/integration/views/view_models/sub_subclass/_collection_item.text.erb",
     "spec/integration/views/view_models/sub_subclass/_exists.erb",
     "spec/integration/views/view_models/sub_subclass/_exists.html.erb",
     "spec/integration/views/view_models/sub_subclass/_exists.text.erb",
     "spec/integration/views/view_models/sub_subclass/_exists_in_both.erb",
     "spec/integration/views/view_models/sub_subclass/_inner.also_explicit.erb",
     "spec/integration/views/view_models/sub_subclass/_inner.nesting.erb",
     "spec/integration/views/view_models/sub_subclass/_list_example.html.erb",
     "spec/integration/views/view_models/sub_subclass/_list_example.text.erb",
     "spec/integration/views/view_models/sub_subclass/_list_item.html.erb",
     "spec/integration/views/view_models/sub_subclass/_list_item.text.erb",
     "spec/integration/views/view_models/sub_subclass/_outer.explicit.erb",
     "spec/integration/views/view_models/sub_subclass/_outer.nesting.erb",
     "spec/integration/views/view_models/sub_subclass/_part_that_is_dependent_on_the_view_model.erb",
     "spec/integration/views/view_models/sub_subclass/show.html.erb",
     "spec/integration/views/view_models/sub_subclass/show.text.erb",
     "spec/integration/views/view_models/subclass/_exists_in_both.erb",
     "spec/integration/views/view_models/subclass/_no_sub_subclass.erb",
     "spec/integration/views/view_models/subclass/_not_found_in_sub_subclass.erb",
     "spec/lib/extensions/active_record_spec.rb",
     "spec/lib/extensions/model_reader_spec.rb",
     "spec/lib/helpers/collection_spec.rb",
     "spec/lib/helpers/rails_spec.rb",
     "spec/lib/helpers/view_spec.rb",
     "spec/lib/view_models/base_spec.rb",
     "spec/lib/view_models/view_spec.rb",
     "spec/spec_helper.rb",
     "spec/spec_helper_extensions.rb"
  ]
  s.homepage = %q{http://floere.github.com/view_models}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{A model proxy for Rails views. Helps you keep the representation of a model and the model itself separate.}
  s.test_files = [
    "spec/integration/integration_spec.rb",
     "spec/integration/models/sub_subclass.rb",
     "spec/integration/models/subclass.rb",
     "spec/integration/view_models/project.rb",
     "spec/integration/view_models/sub_subclass.rb",
     "spec/integration/view_models/subclass.rb",
     "spec/lib/extensions/active_record_spec.rb",
     "spec/lib/extensions/model_reader_spec.rb",
     "spec/lib/helpers/collection_spec.rb",
     "spec/lib/helpers/rails_spec.rb",
     "spec/lib/helpers/view_spec.rb",
     "spec/lib/view_models/base_spec.rb",
     "spec/lib/view_models/view_spec.rb",
     "spec/spec_helper.rb",
     "spec/spec_helper_extensions.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end