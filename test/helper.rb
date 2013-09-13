require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'fileutils'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rvm-completion'
require 'rvm_mock_environment'

class Test::Unit::TestCase
  # Fake the path to a ruby install used in rvm. This is required since
  # normally, the completion resorts to the shell command 'which ruby' to
  # determine this, which obviously is not reproducible in unit tests across
  # environmente. Will create all mocked gemsets specified in options[:gemsets] array
  def self.using_ruby(ruby_name, options={})
    options = {:gemsets => []}.merge(options)
    options[:gemsets].each do |gemset|
      mock_gemset ruby_name, gemset
    end
    context "using ruby #{ruby_name}" do
      setup do
        @current_ruby_path = File.join(File.join(ENV['rvm_rubies_path'], ruby_name, 'bin/ruby'))
      end
      yield
    end
  end
  
  # Processes the completion for the given comp line(s) and yields the 
  # shoulda context. If used after using_ruby will use that ruby with a mocked
  # bin path
  def self.completion_for(*comp_lines)
    comp_lines.each do |comp_line|
      context "Completion for '#{comp_line}'" do
        setup do
          # Fake the use of a specific ruby by manipulating rvm bin path
          if @current_ruby_path
            instance = RVMCompletion.new(comp_line)
            instance.current_ruby_path = @current_ruby_path
            @completion = instance.matches
          else
            @completion = RVMCompletion.new(comp_line).matches
          end
          # puts "DEBUG: Complete '#{comp_line}' => #{@completion.inspect}"
        end
        subject { @completion }
        should "return an Array" do
          assert subject.instance_of?(Array)
        end
        yield
      end
    end
  end
  
  # Asserts the completion stored in subject includes the given values (and only those)
  def self.should_include(*values)
    should "return #{values.length} completions" do
      assert_equal values.length, subject.length
    end
    
    values.each do |value|
      should "include '#{value}' in completion" do
        assert subject.include?(value.to_s), "'#{value}' is not included in #{subject.inspect}!"
      end
    end
  end
  
  # Asserts that no completions are returned in subject
  def self.should_include_nothing
    should "include nothing in completion" do
      assert_equal 0, subject.length
    end
  end
  
  def self.with_rvm_scripts_path(path)
    context "with rvm scripts path set to #{path}" do
      setup { ENV['rvm_scripts_path'] = path }
      yield
    end
  end

  def self.with_rvm_path(path)
    context "with rvm path set to #{path}" do
      setup { ENV['rvm_path'] = path }
      yield
    end
  end

  def self.running_install_script(scripts_dir)
    context "running the install script" do
      setup do
        install_script = File.join(scripts_dir, 'rvm-completion.rb')
        File.delete install_script if File.exists? install_script
        @output = `#{File.join(File.dirname(__FILE__), '../bin/install-rvm-completion')}`
      end
      subject { @output }
      yield
    end
  end
  
  def self.should_print(message)
    should "print '#{message}'" do
      assert_match(/#{message}/, subject)
    end
  end
  
  def self.should_not_have_copied_the_script(scripts_dir)
    should "not have copied the completion script" do
      assert !File.exist?(File.join(scripts_dir, 'rvm-completion.rb'))
    end
  end
  
  def self.should_have_copied_the_script(scripts_dir)
    should "have copied the completion script" do
      assert File.exist?(File.join(scripts_dir, 'rvm-completion.rb'))
    end
  end
end
