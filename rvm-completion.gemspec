# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rvm-completion}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Christoph Olszowka"]
  s.date = %q{2010-07-20}
  s.default_executable = %q{install-rvm-completion}
  s.description = %q{bash completion for Ruby Version Manager including installed rubies and gemsets for current ruby}
  s.email = %q{christoph at olszowka de}
  s.executables = ["install-rvm-completion"]
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "bin/install-rvm-completion",
     "lib/rvm-completion.rb",
     "rvm-completion.gemspec",
     "test/helper.rb",
     "test/test_rvm-completion.rb"
  ]
  s.homepage = %q{http://github.com/colszowka/rvm-completion}
  s.post_install_message = %q{
To install rvm completion v0.1.0, please run 'install-rvm-completion' in your terminal now!

}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{bash completion for Ruby Version Manager}
  s.test_files = [
    "test/helper.rb",
     "test/test_rvm-completion.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<shoulda>, [">= 0"])
    else
      s.add_dependency(%q<shoulda>, [">= 0"])
    end
  else
    s.add_dependency(%q<shoulda>, [">= 0"])
  end
end

