#!/usr/bin/env ruby
# encoding: utf-8

project = ENV['TM_PROJECT_DIRECTORY']
word = ENV['TM_CURRENT_WORD']


require File.dirname(__FILE__)+"/rails_schema.rb"

require "#{project}/db/schema.rb"

name = word.singularize.underscore
table  = TableDefinition.tables.select{|t| t.name == name.strip}.first
puts table.to_s