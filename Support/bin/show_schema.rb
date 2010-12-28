#!/usr/bin/env ruby
# encoding: utf-8
require 'rubygems'
require "activesupport"

project = ENV['TM_PROJECT_DIRECTORY']
word = ENV['TM_CURRENT_WORD']


class String
  def to_fixed_size()
    result = self
    result+' '*(50-result.length)
  end
end


class TableDefinition
  attr_accessor :name
  attr_accessor :columns
  def initialize(name)
    @name = name
    @columns=[]
  end

  def method_missing(method_name,*opts)
    @columns<<[opts.first,method_name.to_s]
  end

  class<<self
    attr_accessor :tables
  end
  
  def to_s
    columns = @columns.sort{|a,b| a.first<=>b.first}
    ([@name]+columns.map { |column| "#{column.first.to_fixed_size}#{column.last}" }).join("\r\n")
  end

end


def create_table(name,options,&block)  
  table = TableDefinition.new(name.to_s.singularize.underscore)
  yield(table)
  TableDefinition.tables||=[]
  TableDefinition.tables<<table
end

def add_index(*opts)
end



module ActiveRecord
  class Schema
    def self.define(opts,&block)
      yield
    end
  end
end

require "#{project}/db/schema.rb"

name = word.singularize.underscore
table  = TableDefinition.tables.select{|t| t.name == name.strip}.first
puts table.to_s