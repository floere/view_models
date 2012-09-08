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

task :spec => [:'shared:spec', :'padrino:spec', :'rails:spec']
task :'rails:spec' => [:'rails2:spec'] # TODO Add Rails 3 here

namespace :spec do

  # run with rake spec
  Spec::Rake::SpecTask.new(:spec) do |t|
    t.spec_opts = %w{--colour --format progress --loadby mtime --reverse}
    t.spec_files = Dir.glob("spec/**/*_spec.rb")
    t.warning = false
  end

  # run with rake rcov
  Spec::Rake::SpecTask.new(:rcov) do |t|
    t.spec_opts = %w{--colour --format progress --loadby mtime --reverse}
    t.spec_files = Dir.glob("spec/**/*_spec.rb")
    t.warning = false
    t.rcov = true
  end

end
