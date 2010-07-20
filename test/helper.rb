require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'fileutils'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rvm-completion'

# Define path to tmp directory
tmp_root = File.expand_path(File.join(File.dirname(__FILE__), '../tmp'))

# Set environment vars used in completion to test-specific ones
ENV['rvm_rubies_path'] = File.join(tmp_root, 'rubies')
ENV['rvm_gems_path'] = File.join(tmp_root, 'gems')
ENV['rvm_gemset_separator'] = '@'

# Clean up and prepare test folders
FileUtils.rm_rf(tmp_root) if File.exist?(tmp_root)

def mock_gemset(ruby_name, gemset_name=nil)
  if gemset_name.nil?
    FileUtils.mkdir_p(File.join(ENV['rvm_gems_path'], "#{ruby_name}"))
  else
    FileUtils.mkdir_p(File.join(ENV['rvm_gems_path'], "#{ruby_name}#{ENV['rvm_gemset_separator']}#{gemset_name}"))
  end
end

FileUtils.mkdir_p(File.join(ENV['rvm_rubies_path'], 'default'))

["macruby-0.6", "rbx-1.0.1-20100603", "ree-1.8.7-2010.02", "ruby-1.8.7-p174", 
  "ruby-1.8.7-p299", "ruby-1.9.1-p378", "ruby-1.9.2-rc2"].each do |ruby_name|
    FileUtils.mkdir_p(File.join(ENV['rvm_rubies_path'], ruby_name))
    mock_gemset(ruby_name)
    mock_gemset(ruby_name, 'global')
end

class RVMCompletion
  # Required for mocking gemsets based upon selected ruby
  attr_writer :current_ruby_path
end

class Test::Unit::TestCase
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
  
  def self.should_include_nothing
    should "include nothing in completion" do
      assert_equal 0, subject.length
    end
  end
end
