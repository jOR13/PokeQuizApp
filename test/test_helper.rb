# frozen_string_literal: true

require 'simplecov'
require 'webmock/minitest'
require 'minitest/mock'
require 'minitest/autorun'
require_relative '../config/environment'
require 'rails/test_help'

SimpleCov.start do
  add_filter '/test/'
  add_group 'Models', 'app/models'
  add_group 'Controllers', 'app/controllers'
  add_group 'Helpers', 'app/helpers'
  add_group 'Views', 'app/views'
  add_group 'Mailers', 'app/mailers'
end
WebMock.disable_net_connect!(allow_localhost: true)

ENV['RAILS_ENV'] ||= 'test'

module ActiveSupport
  class TestCase
    parallelize(workers: :number_of_processors)

    fixtures :all
  end
end
