$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'coupler-api'

require 'tempfile'
require 'tmpdir'
require 'fileutils'
require 'rack/test'
require 'sequel'
require 'ostruct'

# setup mocha
gem 'mocha'
require 'minitest/autorun'
require 'minitest/mock'
require 'mocha/minitest'

module Coupler
  module API
    module UnitTests
    end

    module IntegrationTests
    end

    module IntegrationTest
      include Rack::Test::Methods

      def post_json(uri, params)
        post(uri, JSON.generate(params), { "Content-Type" => "application/json" })
      end

      def put_json(uri, params)
        put(uri, JSON.generate(params), { "Content-Type" => "application/json" })
      end

      def last_response_body
        JSON.parse(last_response.body)
      end

      def config
        @config ||= YAML.load_file(File.join(__dir__, "config.yml"))
      end
    end
  end
end
