$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'coupler-api'

require 'tempfile'
require 'rack/test'
require 'sequel'

module CouplerAPI
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
  end
end

require 'minitest/autorun'
