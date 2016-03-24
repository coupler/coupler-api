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

  def test_index
    @db[:linkages].insert({
      'name' => 'foo',
      'description' => 'foo bar',
      'dataset_1_id' => 1,
      'dataset_2_id' => 2
    })

    get("/linkages")
    assert_equal 1, last_response_body.length
  end

  def test_show
    id = @db[:linkages].insert({
      'name' => 'foo',
      'description' => 'foo bar',
      'dataset_1_id' => 1,
      'dataset_2_id' => 2
    })

    get("/linkages/#{id}")
    assert last_response.ok?
    assert_equal 'foo', last_response_body['name']
  end

  def test_update
    data = {
      'name' => 'foo',
      'description' => 'foo bar',
      'dataset_1_id' => 1,
      'dataset_2_id' => 2,
    }
    id = @db[:linkages].insert(data)

    put_json("/linkages/#{id}", data.merge({'name' => 'bar'}))
    assert last_response.ok?
    assert_nil last_response_body['errors']
    assert_equal id, last_response_body['id']
    assert_equal 'bar', @db[:linkages].first[:name]
  end
end
