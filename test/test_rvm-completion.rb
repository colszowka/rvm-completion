require 'helper'

class TestRvmCompletion < Test::Unit::TestCase
  completion_for 'rvm' do
    should_include "debug", "fetch", "gem", "gemdir", "gemset", "implode", "info", "install", "list", 
                   "monitor", "notes", "package", "rake", "reload", "remove", "reset", "ruby", "specs", 
                   "srcdir", "tests", "uninstall", "update", "usage", "use", "version", "wrapper"
  end
  
  completion_for 'rvm insta' do
    should_include 'install'
  end
  
  completion_for 'rvm install' do
    should_include "ironruby", "jruby", "macruby", "maglev", "mput", "rbx", "ree", "ruby"
  end
  
  completion_for 'rvm install rub' do
    should_include "ruby"
  end
  
  completion_for 'rvm install ruby' do
    should_include_nothing
  end
  
  completion_for 'rvm us' do
    should_include 'use', 'usage'
  end
  
  completion_for 'rvm use', 'rvm uninstall', 'rvm remove' do
    should_include "system", "default", "macruby-0.6", "rbx-1.0.1-20100603", "ree-1.8.7-2010.02", 
                   "ruby-1.8.7-p174", "ruby-1.8.7-p299", "ruby-1.9.1-p378", "ruby-1.9.2-rc2"
  end
  
  completion_for 'rvm use ruby', 'rvm uninstall ruby', 'rvm remove ruby' do
    should_include "macruby-0.6", "ruby-1.8.7-p174", "ruby-1.8.7-p299", "ruby-1.9.1-p378", "ruby-1.9.2-rc2"
  end
  
  completion_for 'rvm use ruby-1.8', 'rvm uninstall ruby-1.8', 'rvm remove ruby-1.8' do
    should_include "ruby-1.8.7-p174", "ruby-1.8.7-p299"
  end
  
  completion_for 'rvm use ruby-1.8.7-p1', 'rvm uninstall ruby-1.8.7-p1', 'rvm remove ruby-1.8.7-p1' do
    should_include "ruby-1.8.7-p174"
  end
  
  completion_for 'rvm use ruby-1.8.7-p174', 'rvm uninstall ruby-1.8.7-p174', 'rvm remove ruby-1.8.7-p174' do
    should_include_nothing
  end
  
  completion_for 'rvm use 174', 'rvm uninstall 174', 'rvm remove 174' do
    should_include "ruby-1.8.7-p174"
  end
  
  completion_for 'rvm use 1.9.1' do
    should_include "ruby-1.9.1-p378"
  end
  
  completion_for 'rvm use 1.9', 'rvm uninstall 1.9', 'rvm remove 1.9' do
    should_include "ruby-1.9.1-p378", "ruby-1.9.2-rc2"
  end
  
  completion_for 'rvm usa' do
    should_include 'usage'
  end
  
  completion_for 'rvm usage' do
    should_include_nothing
  end
  
  completion_for 'rvm gems' do
    should_include 'gemset'
  end
  
  completion_for 'rvm gemset' do
    should_include "clear", "copy", "create", "delete", "dir", "empty", "export", "gemdir", "import", "install", "list", "name", "pristine", "use"
  end
  
  using_ruby 'ruby-1.8.7-p174', :gemsets => ['foo', 'bar'] do
    completion_for 'rvm gemset use', 'rvm gemset copy', 'rvm gemset clear', 'rvm gemset delete', 'rvm gemset export' do
      should_include 'global', 'foo', 'bar'
    end
    
    completion_for 'rvm gemset use o', 'rvm gemset copy o', 'rvm gemset clear o', 'rvm gemset delete o', 'rvm gemset export o' do
      should_include 'global', 'foo'
    end
    
    completion_for 'rvm gemset use fo', 'rvm gemset copy fo', 'rvm gemset clear fo', 'rvm gemset delete fo', 'rvm gemset export fo' do
      should_include 'foo'
    end
    
    completion_for 'rvm gemset use foo', 'rvm gemset copy foo', 'rvm gemset clear foo', 'rvm gemset delete foo', 'rvm gemset export foo' do
      should_include_nothing
    end
  end
  
  using_ruby 'ruby-1.8.7-p299' do
    completion_for 'rvm gemset use', 'rvm gemset copy', 'rvm gemset clear', 'rvm gemset delete', 'rvm gemset export' do
      should_include 'global'
    end
    
    completion_for 'rvm gemset use global', 'rvm gemset copy global', 'rvm gemset clear global', 'rvm gemset delete global', 'rvm gemset export global' do
      should_include_nothing
    end
  end
end
