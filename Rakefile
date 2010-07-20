require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "rvm-completion"
    gem.summary = %Q{bash completion for Ruby Version Manager}
    gem.description = %Q{bash completion for Ruby Version Manager including installed rubies and gemsets for current ruby}
    gem.email = "christoph at olszowka de"
    gem.homepage = "http://github.com/colszowka/rvm-completion"
    gem.authors = ["Christoph Olszowka"]
    gem.bindir = 'bin'
    gem.executables = ['install-rvm-completion']
    gem.default_executable = 'install-rvm-completion'
    gem.add_development_dependency "shoulda", ">= 0"
    gem.post_install_message = "To install the completion, execute 'install-rvm-completion' in your terminal now!"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "rvm-completion #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
