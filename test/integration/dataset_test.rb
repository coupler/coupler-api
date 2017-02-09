require 'test_helper'

class CouplerAPI::IntegrationTests::DatasetTest < Minitest::Test
  include CouplerAPI::IntegrationTest

  attr_reader :app

  def setup
    @tempfile = Tempfile.new('coupler_api')
    @db = Sequel.connect(database_uri)
    @app = CouplerAPI::Builder.create({
      uri: database_uri
    })
  end

  def teardown
    @tempfile.unlink
  end

  def database_uri
    (RUBY_PLATFORM == "java" ? 'jdbc:sqlite' : 'sqlite') + '://' + @tempfile.path
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

  def test_fields
    id = @db[:datasets].insert({
      'name' => 'foo',
      'type' => 'mysql',
      'host' => 'localhost',
      'database_name' => 'test_coupler_api',
      'username' => 'coupler_api',
      'password' => 'secret',
      'table_name' => 'foo'
    })
    uri =
      if RUBY_PLATFORM == "java"
        "jdbc:mysql://localhost/test_coupler_api?user=coupler_api&password=secret"
      else
        "mysql2://localhost/test_coupler_api?username=coupler_api&password=secret"
      end
    db2 = Sequel.connect(uri)
    db2.create_table! :foo do
      primary_key :id
      String :foo
      String :bar
    end

    get("/datasets/#{id}/fields")
    assert_nil last_response_body['errors']
    assert_equal [{ 'name' => 'id', 'type' => 'integer' }, { 'name' => 'foo', 'type' => 'string' }, { 'name' => 'bar', 'type' => 'string' }], last_response_body['fields']
  end
end
