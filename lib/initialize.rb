require 'rubygems'
require 'bundler/setup'

require 'pathname'
require 'yaml'
require 'optparse'
require 'ostruct'

require 'ruby-lazy-const'

LazyConst::Config.base_dir = './lib'
