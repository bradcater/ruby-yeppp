require "bundler/gem_tasks"
require "rake/extensiontask"
require "rspec/core/rake_task"

spec = Gem::Specification.load('ryeppp.gemspec')
Rake::ExtensionTask.new('ryeppp', spec)

task :default => [:compile]
