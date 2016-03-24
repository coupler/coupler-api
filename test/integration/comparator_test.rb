require 'test_helper'

class Coupler::API::IntegrationTests::ComparatorTest < Minitest::Test
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
    count = @db[:comparators].count
    post_json("/comparators", {
      'set_1' => 'foo',
      'set_2' => 'foo bar',
      'options' => 'baz',
      'linkage_id' => 1
    })
    assert_nil last_response_body['errors']
    assert_equal count + 1, @db[:comparators].count
  end

  def test_index
    @db[:comparators].insert({
      'set_1' => 'foo',
      'set_2' => 'foo bar',
      'options' => 'baz',
      'linkage_id' => 1
    })

    get("/comparators")
    assert_equal 1, last_response_body.length
  end

  def test_show
    id = @db[:comparators].insert({
      'set_1' => 'foo',
      'set_2' => 'foo bar',
      'options' => 'baz',
      'linkage_id' => 1
    })

    get("/comparators/#{id}")
    assert last_response.ok?
    assert_equal 'foo', last_response_body['set_1']
  end

  def test_update
    data = {
      'set_1' => 'foo',
      'set_2' => 'foo bar',
      'options' => 'baz',
      'linkage_id' => 1
    }
    id = @db[:comparators].insert(data)

    put_json("/comparators/#{id}", data.merge({'set_1' => 'bar'}))
    assert last_response.ok?
    assert_nil last_response_body['errors']
    assert_equal id, last_response_body['id']
    assert_equal 'bar', @db[:comparators].first[:set_1]
  end

  def test_delete
    id = @db[:comparators].insert({
      'set_1' => 'foo',
      'set_2' => 'foo bar',
      'options' => 'baz',
      'linkage_id' => 1
    })
    count = @db[:comparators].count

    delete("/comparators/#{id}")
    assert_nil last_response_body['errors']
    assert_equal id, last_response_body['id']
    assert_equal count - 1, @db[:comparators].count
  end
end
