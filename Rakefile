require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task' unless RUBY_VERSION.match(/1\.8/)
require 'rdoc/task'

task :default => [:lint, :spec]

desc 'Run the specs.'
RSpec::Core::RakeTask.new do |t|
  t.pattern = 'spec/*_spec.rb'
  t.rspec_opts = '-f doc'
end

desc 'Generate lorj documentation'
RDoc::Task.new do |rdoc|
  rdoc.main = 'README.md'
  rdoc.rdoc_files.include('README.md', 'lib', 'example', 'bin')
end

if RUBY_VERSION.match(/1\.8/)
  desc 'no lint with ruby 1.8'
  task :lint
else
  desc 'Run RuboCop on the project'
  RuboCop::RakeTask.new(:lint) do |task|
    task.formatters = ['progress']
    task.verbose = true
    task.fail_on_error = true
  end
end

desc 'Run spec with docker for ruby 1.8'
task :spec18 do
  system('build/build_with_proxy.sh -t ruby/1.8')
  `docker inspect subhash`
  if $?.exitstatus == 0 # rubocop: disable Style/SpecialGlobalVars
    system('docker start -ai subhash')
  else
    system('docker run -it --name subhash -v $(pwd):/src -w /src ruby/1.8 '\
           '/tmp/bundle.sh')
  end
end

task :build => [:lint, :spec]
