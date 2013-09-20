require "bundler/gem_tasks"
require "rake/extensiontask"
require "rspec/core/rake_task"

spec = Gem::Specification.load('ryeppp.gemspec')
Rake::ExtensionTask.new('ryeppp', spec)

desc "Ryeppp unit tests"
RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = "spec/*_spec.rb"
  t.verbose = true
end

task :default => [:compile, :spec]
