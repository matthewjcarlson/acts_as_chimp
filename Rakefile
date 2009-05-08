require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

# Run the unit tests
namespace :test do
  Rake::TestTask.new(:units) do |t|
    t.pattern = 'test/unit/**/chimp_test.rb'
    t.ruby_opts << '-rubygems'
    t.verbose = true
  end

  Rake::TestTask.new(:remote) do |t|
    t.pattern = 'test/remote/chimp_test.rb'
    t.ruby_opts << '-rubygems'
    t.verbose = true
  end
end

desc 'Generate documentation for the acts_as_chimp plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'ActsAsChimp'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
