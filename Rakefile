def require_if task, name
  require name if ARGV[0] =~ %r{^#{task}}
end

require 'rake'
require 'rake/testtask'
require 'rdoc/task'
require 'rspec/core/rake_task'

require_if :metrics, 'metric_fu'

task :default => :spec

namespace :spec do

  # run with rake spec
  RSpec::Core::RakeTask.new(:spec) do |t|
    t.rspec_opts  = %w{--colour --format progress --loadby mtime --reverse}
    t.pattern     = "spec/**/*_spec.rb"
    t.ruby_opts   = '-w false'
  end

  # run with rake rcov
  RSpec::Core::RakeTask.new(:rcov) do |t|
    t.rspec_opts  = %w{--colour --format progress --loadby mtime --reverse}
    t.pattern     = "spec/**/*_spec.rb"
    t.ruby_opts   = '-w false'
    t.rcov        = true
  end

end
