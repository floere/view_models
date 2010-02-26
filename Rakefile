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