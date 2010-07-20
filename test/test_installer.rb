require 'helper'

class TestInstaller < Test::Unit::TestCase
  with_rvm_scripts_path '' do
    running_install_script do
      should_print 'Failed to find rvm scripts path - is rvm installed correctly?'
      should_not_have_copied_the_script
    end
  end
  
  with_rvm_scripts_path File.expand_path(File.join(File.dirname(__FILE__), '../tmp')) do
    running_install_script do
      should_print "Success! rvm completion"
      should_print "If you didn't do so before, please add the following line at the end of your"
      should_have_copied_the_script
    end
  end
end
