require 'helper'

class TestInstaller < Test::Unit::TestCase
  tmp_root = File.expand_path(File.join(File.dirname(__FILE__), '../tmp'))
  scripts_dir = File.expand_path(File.join(File.dirname(__FILE__), '../tmp/scripts'))

  with_rvm_scripts_path nil do
    with_rvm_path nil do
      running_install_script scripts_dir do
        should_print 'Failed to find rvm scripts path - is rvm installed correctly?'
        should_not_have_copied_the_script scripts_dir
      end
    end

    with_rvm_path tmp_root do
      running_install_script scripts_dir do
        should_print "Success! rvm completion"
        should_print "If you didn't do so before, please add the following line at the end of your"
        should_have_copied_the_script scripts_dir
      end
    end
  end

  with_rvm_scripts_path scripts_dir do
    running_install_script scripts_dir do
      should_print "Success! rvm completion"
      should_print "If you didn't do so before, please add the following line at the end of your"
      should_have_copied_the_script scripts_dir
    end
  end
end
