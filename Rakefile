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

desc "Ryeppp c generation"
task :c_generation do
  current_dir = __FILE__.split(/\//)[0..-2].join('/')
  require File.join(current_dir, 'ext/templates/ryeppp.c.rb')
  c_code = [
    HEADERS,
    PRIMARY,
    FUNCS.call(nil, 'Add'),
    FUNCS.call(nil, 'Subtract'),
    FUNCS.call('Multiply', 'Multiply'),
    DOT_PRODUCT,
    MIN_MAX,
    PAIRWISE_MIN_MAX,
    CONSTANT_MIN_MAX,
    NEGATE,
    SUMS,
    INITIALIZER
  ].join("\n\n")
  File.open(File.join(current_dir, 'ext/ryeppp/ryeppp.c'), 'w') do |f|
    f.write(c_code)
  end
end

task :default => [:c_generation, :compile, :spec]
