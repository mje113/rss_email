require 'simplecov'
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start
#Coveralls.wear!

ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/mock'
require 'ostruct'

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...

  def raw_stories(size)
    size.times.map { |i|
      OpenStruct.new(
        entry_id:  "entry_#{i}",
        published: i.days.ago,
        updated:   i.days.ago,
        url:       "http://example.com/blog/#{i}",
        content:   i.to_s * 10,
        author:    'fred'
      )
    }
  end
end
