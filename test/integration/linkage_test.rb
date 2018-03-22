require 'test_helper'

class CouplerAPI::IntegrationTests::LinkageTest < Minitest::Test
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
    assert_nil last_response_body['errors']
    assert last_response.ok?
    assert_equal id, last_response_body['id']
    assert_equal 'bar', @db[:linkages].first[:name]
  end

  def test_delete
    id = @db[:linkages].insert({
      'name' => 'foo',
      'description' => 'foo bar',
      'dataset_1_id' => 1,
      'dataset_2_id' => 2
    })
    count = @db[:linkages].count

    delete("/linkages/#{id}")
    assert_nil last_response_body['errors']
    assert_equal id, last_response_body['id']
    assert_equal count - 1, @db[:linkages].count
  end

  def test_comparators
    id = @db[:linkages].insert({
      'name' => 'foo',
      'description' => 'foo bar',
      'dataset_1_id' => 1,
      'dataset_2_id' => 2
    })
    comparator_id = @db[:comparators].insert({
      'kind' => 'compare',
      'set_1' => '["foo"]',
      'set_2' => '["bar"]',
      'linkage_id' => id
    })

    get("/linkages/#{id}/comparators")

    expected = [{
      'id' => comparator_id,
      'kind' => 'compare',
      'set_1' => %w{foo},
      'set_2' => %w{bar},
      'options' => nil,
      'order' => nil,
      'linkage_id' => id
    }]
    assert_equal expected, last_response_body
  end
end
