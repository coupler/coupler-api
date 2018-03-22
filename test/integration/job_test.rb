require 'test_helper'

class CouplerAPI::IntegrationTests::JobTest < Minitest::Test
  include CouplerAPI::IntegrationTest

  attr_reader :app

  def setup
    @tempfile = Tempfile.new('coupler_api')
    @db = Sequel.connect(database_uri)
    @builder = CouplerAPI::Builder.new({ "database_uri" => database_uri })
    @app = @builder.app
  end

  def teardown
    @tempfile.unlink
  end

  def database_uri
    (RUBY_PLATFORM == "java" ? 'jdbc:sqlite' : 'sqlite') + '://' + @tempfile.path
  end

  def test_create
    count = @db[:jobs].count
    post_json("/jobs", {
      'kind' => 'linkage',
      'linkage_id' => 1,
    })
    assert_nil last_response_body['errors']
    assert_equal count + 1, @db[:jobs].count
  end

  def test_show
    id = @db[:jobs].insert({
      'kind' => 'linkage',
      'linkage_id' => 1
    })

    get("/jobs/#{id}")
    assert_equal id, last_response_body['id']
  end

=begin
  def test_index
    @db[:jobs].insert({
      'name' => 'foo',
      'type' => 'mysql',
      'host' => 'localhost',
      'database_name' => 'foo',
      'username' => 'foo',
      'table_name' => 'foo'
    })

    get("/jobs")
    assert_equal 1, last_response_body.length
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
    id = @db[:jobs].insert(data)

    put_json("/jobs/#{id}", data.merge({'name' => 'bar'}))
    assert_nil last_response_body['errors']
    assert_equal id, last_response_body['id']
    assert_equal 'bar', @db[:jobs].first[:name]
  end

  def test_delete
    id = @db[:jobs].insert({
      'name' => 'foo',
      'type' => 'mysql',
      'host' => 'localhost',
      'database_name' => 'foo',
      'username' => 'foo',
      'table_name' => 'foo'
    })
    count = @db[:jobs].count

    delete("/jobs/#{id}")
    assert_nil last_response_body['errors']
    assert_equal id, last_response_body['id']
    assert_equal count - 1, @db[:jobs].count
  end

  def test_fields
    id = @db[:jobs].insert({
      'name' => 'foo',
      'type' => 'mysql',
      'host' => 'localhost',
      'database_name' => 'test_coupler_api',
      'username' => 'coupler_api',
      'password' => 'secret',
      'table_name' => 'foo'
    })
    db2 = Sequel.connect("mysql2://localhost/test_coupler_api?username=coupler_api&password=secret")
    db2.create_table! :foo do
      primary_key :id
      String :foo
      String :bar
    end

    get("/jobs/#{id}/fields")
    assert_nil last_response_body['errors']
    assert_equal [{ 'name' => 'id', 'type' => 'integer' }, { 'name' => 'foo', 'type' => 'string' }, { 'name' => 'bar', 'type' => 'string' }], last_response_body['fields']
  end
=end
end
