# Set up a faked rvm environment for tests

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

FileUtils.mkdir_p(File.join(tmp_root, 'scripts'))
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