#!/usr/local/ruby/ruby-2.5.3/bin/ruby -I/home/jcarson/git_clones/msu1_packgen/lib

require 'initialize'

options = Msu1Packgen::ArgumentParser.parse(ARGV)
Msu1Packgen::Generator.new(options).run!
