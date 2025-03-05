ENV['RAILS_ENV'] ||= 'test'
require 'minitest/autorun'
require 'rubygems'
require "redis"
require "minitest/reporters"

reporters = []
reporters << Minitest::Reporters::SpecReporter.new(color: true)
# reporters << Minitest::Reporters::HtmlReporter.new(color: true)
reporters << Minitest::Reporters::DefaultReporter.new(color: true) unless ENV['DEBUG']
reporters << Minitest::Reporters::JUnitReporter.new

Minitest::Reporters.use! reporters

