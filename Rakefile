def require_if task, name
  require name if ARGV[0] =~ %r{^#{task}}
end

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'spec/rake/spectask'
require 'spec/rake/verify_rcov'

require_if :metrics, 'metric_fu'

task :default => :spec

# run with rake spec
Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_opts = %w{--colour --format progress --loadby mtime --reverse}
  t.spec_files = Dir.glob('spec/**/*_spec.rb')
  t.warning = false
end

# run with rake rcov
Spec::Rake::SpecTask.new(:rcov) do |t|
  t.spec_opts = %w{--colour --format progress --loadby mtime --reverse}
  t.spec_files = Dir.glob('spec/**/*_spec.rb')
  t.warning = false
  t.rcov = true
  puts "Open coverage/index.html for the rcov results."
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "view_models"
    gemspec.summary = "A model proxy for Rails views. Helps you keep the representation of a model and the model itself separate."
    gemspec.email = "florian.hanke@gmail.com"
    gemspec.homepage = "http://floere.github.com/view_models"
    gemspec.description = "The view models gem adds the missing R (Representation) to Rails' MVC. It provides simple proxy functionality for your models and thus helps you keep the model and view representations of a model separate, as it should be. Also, you can define helper methods on the (view) model instead of globally to keep them focused, more quickly understood and more easily testable. View Models also introduce hierarchical rendering for your hierarchical models. If the account view is not defined for the subclass FemaleUser, it checks if it is defined for User, for example, to see when there is no specific view, if there is a general view. So, in other words: Polymorphism not just in the model, but also in the view. Have fun!"
    gemspec.authors = ["Florian Hanke", "Kaspar Schiess", "Niko Dittmann", "Andreas Schacke"]
    gemspec.rdoc_options = ["--inline-source", "--charset=UTF-8"]
    gemspec.files = FileList["[A-Z]*", "{generators,lib,rails,spec}/**/*"]
  end
  Jeweler::GemcutterTasks.new
rescue LoadError => e
  puts "Jeweler not available (#{e}). Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end