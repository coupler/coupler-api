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
      'kind' => 'compare',
      'set_1' => %w{foo},
      'set_2' => %w{foo},
      'options' => { 'operation' => 'equal' },
      'linkage_id' => 1
    })
    assert_nil last_response_body['errors']
    assert_equal count + 1, @db[:comparators].count
  end

  def test_index
    id = @db[:comparators].insert({
      'kind' => 'compare',
      'set_1' => '["foo"]',
      'set_2' => '["foo","bar"]',
      'options' => '{"operation":"equal"}',
      'linkage_id' => 1
    })

    get("/comparators")

    expected = [{
      'id' => id,
      'kind' => 'compare',
      'set_1' => %w{foo},
      'set_2' => %w{foo bar},
      'options' => { 'operation' => 'equal' },
      'order' => nil,
      'linkage_id' => 1
    }]
    assert_equal expected, last_response_body
  end

  def test_show
    id = @db[:comparators].insert({
      'kind' => 'compare',
      'set_1' => '["foo"]',
      'set_2' => '["foo","bar"]',
      'options' => '{"operation":"equal"}',
      'linkage_id' => 1
    })

    get("/comparators/#{id}")
    assert last_response.ok?
    assert_equal %w{foo}, last_response_body['set_1']
  end

  def test_update
    id = @db[:comparators].insert({
      'kind' => 'compare',
      'set_1' => '["foo"]',
      'set_2' => '["foo","bar"]',
      'options' => '{"operation":"equal"}',
      'linkage_id' => 1
    })

    put_json("/comparators/#{id}", {
      'kind' => 'compare',
      'set_1' => %w{bar},
      'set_2' => %w{foo},
      'options' => { 'operation' => 'equal' },
      'linkage_id' => 1
    })
    assert last_response.ok?
    assert_nil last_response_body['errors']
    assert_equal id, last_response_body['id']
    assert_equal '["bar"]', @db[:comparators].first[:set_1]
  end

  def test_delete
    id = @db[:comparators].insert({
      'kind' => 'compare',
      'set_1' => '["foo"]',
      'set_2' => '["foo","bar"]',
      'options' => '{"operation":"equal"',
      'linkage_id' => 1
    })
    count = @db[:comparators].count

    delete("/comparators/#{id}")
    assert_nil last_response_body['errors']
    assert_equal id, last_response_body['id']
    assert_equal count - 1, @db[:comparators].count
  end
end
