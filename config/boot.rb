ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)

require 'bundler/setup' # Set up gems listed in the Gemfile.
require 'bootsnap/setup' unless (RbConfig::CONFIG['host_os'] =~ /mswin|mingw|cygwin/)