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
    data = config['dataset_1'].merge({
      'name' => 'foo'
    })
    post_json("/datasets", data)
    assert_nil last_response_body['errors']
    assert_equal count + 1, @db[:datasets].count
  end

  def test_index
    data = config['dataset_1'].merge({
      'name' => 'foo'
    })
    @db[:datasets].insert(data)

    get("/datasets")
    assert_equal 1, last_response_body.length
  end

  def test_show
    data = config['dataset_1'].merge({
      'name' => 'foo'
    })
    id = @db[:datasets].insert(data)

    get("/datasets/#{id}")
    assert_equal 'foo', last_response_body['name']
  end

  def test_update
    data = config['dataset_1'].merge({
      'name' => 'foo'
    })
    id = @db[:datasets].insert(data)

    put_json("/datasets/#{id}", data.merge({'name' => 'bar'}))
    assert_nil last_response_body['errors']
    assert_equal id, last_response_body['id']
    assert_equal 'bar', @db[:datasets].first[:name]
  end

  def test_delete
    data = config['dataset_1'].merge({
      'name' => 'foo'
    })
    id = @db[:datasets].insert(data)
    count = @db[:datasets].count

    delete("/datasets/#{id}")
    assert_nil last_response_body['errors']
    assert_equal id, last_response_body['id']
    assert_equal count - 1, @db[:datasets].count
  end

  def test_fields
    sandbox = config['mysql_sandbox']
    uri =
      if RUBY_PLATFORM == "java"
        "jdbc:mysql://%s/%s?user=%s&password=%s" %
          sandbox.values_at('host', 'database_name', 'username', 'password')
      else
        "mysql2://%s/%s?username=%s&password=%s" %
          sandbox.values_at('host', 'database_name', 'username', 'password')
      end

    db2 = Sequel.connect(uri)
    db2.create_table! :foo do
      primary_key :id
      String :foo
      String :bar
    end

    data = sandbox.merge({
      'name' => 'foo',
      'type' => 'mysql',
      'table_name' => 'foo'
    })
    id = @db[:datasets].insert(data)

    get("/datasets/#{id}/fields")
    assert_nil last_response_body['errors']
    assert_equal [{ 'name' => 'id', 'type' => 'integer' }, { 'name' => 'foo', 'type' => 'string' }, { 'name' => 'bar', 'type' => 'string' }], last_response_body['fields']
  end
end
