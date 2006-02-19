#!/usr/bin/env ruby
path = ARGV.first || ENV['TM_FILEPATH']
parents = [case path
  when %r{/controllers/}, %r{_controller\.rb$} then 'test/functional'
  when %r{/(models|helpers)/} then 'test/unit'
  when %r{/test/unit/} then %w(app/models app/helpers lib)
  when %r{/test/functional/} then 'app/controllers'
  when %r(/test/|(_test\.rb$)) then %w(app lib)
end].flatten
 
file_name = File.basename path
if parents.any? { |parent| parent =~ %r{test(/|$)} }
  file_name.gsub!(/\.rb$/, '_test.rb')
else
  file_name.gsub!(/_test\.rb$/, '.rb')
end

def shell_escape (str)
  "'" + str.gsub(/'/, "'\\\\''") + "'"
end
 
find_parents = parents.collect { |parent| File.join(ENV['TM_PROJECT_DIRECTORY'], parent) }
find_parents = find_parents.find_all { |file| File.exists?(file) }
 
matches = `find #{find_parents.collect { |str| shell_escape str } * ' '} -name #{shell_escape file_name} -maxdepth 1`.strip.split("\n").collect {|match| match.strip} unless find_parents.empty?

`mate #{matches.collect { |str| shell_escape str } * ' '} &>/dev/null &` unless matches.empty?
