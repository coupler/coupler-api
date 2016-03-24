require 'test_helper'

class Coupler::API::IntegrationTests::LinkageTest < Minitest::Test
  include Coupler::API::IntegrationTest

  attr_reader :app

  def setup
    @tempfile = Tempfile.new('coupler_api')
    @db = Sequel.connect(database_uri)
    @app = Coupler::API::Builder.create({
      adapter: 'sql',
      uri: database_uri
    })
  end

  def teardown
    @tempfile.unlink
  end

  def database_uri
    'sqlite://' + @tempfile.path
  end

  def test_create
    count = @db[:linkages].count
    post_json("/linkages", {
      'name' => 'foo',
      'description' => 'foo bar',
      'dataset_1_id' => 1,
      'dataset_2_id' => 2
    })
    assert_nil last_response_body['errors']
    assert_equal count + 1, @db[:linkages].count
  end
end
