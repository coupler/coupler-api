require 'test_helper'

class Coupler::API::IntegrationTests::DatasetTest < Minitest::Test
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
    count = @db[:datasets].count
    post_json("/datasets", {
      'name' => 'foo',
      'type' => 'mysql',
      'host' => 'localhost',
      'database_name' => 'foo',
      'username' => 'foo',
      'table_name' => 'foo'
    })
    assert_nil last_response_body['errors']
    assert_equal count + 1, @db[:datasets].count
  end

  def test_index
    @db[:datasets].insert({
      'name' => 'foo',
      'type' => 'mysql',
      'host' => 'localhost',
      'database_name' => 'foo',
      'username' => 'foo',
      'table_name' => 'foo'
    })

    get("/datasets")
    assert_equal 1, last_response_body.length
  end

  def test_show
    id = @db[:datasets].insert({
      'name' => 'foo',
      'type' => 'mysql',
      'host' => 'localhost',
      'database_name' => 'foo',
      'username' => 'foo',
      'table_name' => 'foo'
    })

    get("/datasets/#{id}")
    assert_equal 'foo', last_response_body['name']
  end

  def test_update
    data = {
      'name' => 'foo',
      'type' => 'mysql',
      'host' => 'localhost',
      'database_name' => 'foo',
      'username' => 'foo',
      'table_name' => 'foo'
    }
    id = @db[:datasets].insert(data)

    put_json("/datasets/#{id}", data.merge({'name' => 'bar'}))
    assert_nil last_response_body['errors']
    assert_equal id, last_response_body['id']
    assert_equal 'bar', @db[:datasets].first[:name]
  end

  def test_delete
    id = @db[:datasets].insert({
      'name' => 'foo',
      'type' => 'mysql',
      'host' => 'localhost',
      'database_name' => 'foo',
      'username' => 'foo',
      'table_name' => 'foo'
    })
    count = @db[:datasets].count

    delete("/datasets/#{id}")
    assert_nil last_response_body['errors']
    assert_equal id, last_response_body['id']
    assert_equal count - 1, @db[:datasets].count
  end
end
