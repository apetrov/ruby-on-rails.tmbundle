project = ENV['TM_PROJECT_DIRECTORY']
require 'yaml'
database = File.read(File.join(project,'config',"database.yml"))
config = YAML.load(database)
config = config["development"]


class String
  def to_fixed_size(i=50)
    result = self
    result+' '*(i-result.length)
  end
end

require 'rubygems'
require 'activesupport'

word = ENV['TM_CURRENT_WORD'].to_s.pluralize

case config['adapter']
when 'mysql','mysql2'
  require "mysql" rescue nil
  require "mysql2" rescue nil
  
  puts config
  my = Mysql::new(config['host']||'localhost', config['username'], config['password'], config['database'])
  res = my.query("SHOW INDEX FROM #{word}")
  indexes = []
  
  res.each do |row|
    indexes<<[row[2],row[4],row[6],row[10]]
  end
  
  indexes.group_by(&:first).sort_by(&:first).each do |k,v|
    puts [k.to_fixed_size(70),
    v.map{|t| t[1]}.join(', ').to_fixed_size(30),
    v[0][2].to_fixed_size(10),
    v[0][3].to_fixed_size(10)].join("|") rescue nil   
  end
  
end
