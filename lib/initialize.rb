require 'rubygems'
require 'bundler/setup'

require 'pathname'
require 'yaml'
require 'optparse'
require 'ostruct'

require 'ruby-lazy-const'

module Kernel
  def puts_error(msg)
    puts "[\033[0;31mERROR\033[0;0m] - #{msg}"
  end

  def puts_info(msg)
    puts "[\033[0;33mINFO\033[0;0m] - #{msg}"
  end
end

LazyConst::Config.base_dir = './lib'
