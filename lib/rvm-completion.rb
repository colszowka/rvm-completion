#!/usr/bin/env ruby

#
# Bash completion for Ruby Version Manager commands, Rubies and gemsets
#
# Add the following line to your ~/.profile or ~/.bashrc:
# complete -C PATH/TO/rvm_completion.rb -o default rvm
# Don't forget to make the completion script executable with chmod +x!
#
# Written by Christoph Olszowka, based upon Project Completion script by Ryan Bates
# (see http://github.com/ryanb/dotfiles/blob/master/bash/completion_scripts/project_completion)
#
class RVMCompletion
  def initialize(comp_line)
    @comp_line = comp_line
  end
  
  # Find a match for the current command line input
  def matches
    # Completion for root level rvm commands
    if rvm_command_incomplete?(shell_argument)
      return select(rvm_commands, shell_argument)
    end
    
    case shell_argument 
      when /^use|uninstall|remove/
        return [] if shell_argument(3).length > 0
        select(rubies, shell_argument(2))
      when /^install/
        select(rvm_ruby_aliases, shell_argument(2))
      
      when /^gemset/
        case shell_argument(2)
          when /use|copy|clear|delete|export/
            select(gemsets, shell_argument(3))
          else
            select(gemset_commands, shell_argument(2))
        end
      else
        []
    end
    
  end
  
  # Retrieves the shell argument at the specified position, defaults to first argument
  def shell_argument(level=1)
    @comp_line.split(' ')[level] || ''
  end
  
  # Checks whether the first rvm command is complete
  def rvm_command_incomplete?(cmd)
    not rvm_commands.include?(cmd.strip)
  end
  
  # Matches the given (partial?) command against the given collection
  def select(collection, command)
    collection.select do |item|
      item[0, command.length] == command or item =~ /#{command}/
    end.sort
  end
  
  # Retrieves the current rvm ruby
  def current_ruby
    @current_ruby ||= `which ruby`.strip.chomp.gsub(ENV['rvm_rubies_path']+'/', '').split('/').first
  end
  
  # Retrieves all available rubies
  def rubies
    @rubies ||= Dir[File.join(ENV['rvm_rubies_path'], '*')].map {|r| File.basename(r) } + %w(system)
  end
  
  # Retrieves all available gemsets for the current ruby active in rvm
  def gemsets
    @gemsets ||= Dir[File.join(ENV['rvm_gems_path'], "#{current_ruby}#{ENV['rvm_gemset_separator']}*")].map do |r|
      File.basename(r).split(ENV['rvm_gemset_separator']).last
    end
  end
  
  def rvm_commands
    %w(usage version use reload implode update reset info debug install uninstall remove wrapper ruby gem rake tests specs monitor gemset gemdir srcdir list fetch package notes)
  end
  
  def gemset_commands
    %w(import export create copy empty delete name dir list gemdir install pristine clear use)
  end
  
  def rvm_ruby_aliases
    %w(ruby jruby rbx ree macruby maglev ironruby mput)
  end
end

# A simple logger for debugging the completion
def log(msg)
  File.open(File.dirname(__FILE__) + "/log.txt", "a+") do |f|
    f.puts msg
  end
end

# Debug output
# File.open(File.dirname(__FILE__) + "/log.txt", "a+") do |f|
#   f.puts
#   f.puts ENV["COMP_LINE"]
#   f.puts RVMCompletion.new(ENV["COMP_LINE"]).shell_argument.inspect
#   f.puts RVMCompletion.new(ENV["COMP_LINE"]).shell_argument(2).inspect
#   f.puts RVMCompletion.new(ENV["COMP_LINE"]).matches.inspect
# end

puts RVMCompletion.new(ENV["COMP_LINE"]).matches
exit 0
