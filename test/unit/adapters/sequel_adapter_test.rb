require 'test_helper'

class CouplerAPI::UnitTests::SequelAdapterTest < Minitest::Test
  def setup
    @relation = stub('relation')
    @db = stub('db')
    @options = { foo: 'bar' }
    @adapter = CouplerAPI::SequelAdapter.new(@options)
    Sequel.stubs(:connect).returns(@db)
  end

  def test_find
    @db.expects(:[]).with(:foo).returns(@relation)
    @relation.expects(:all).returns(:return_value)
    Sequel.expects(:connect).with(@options).returns(@db)
    assert_equal :return_value, @adapter.find(:foo)
  end

  def test_find_with_conditions
    @db.expects(:[]).with(:foo).returns(@relation)
    @relation.expects(:where).with('condition').returns(@relation)
    @relation.expects(:all).returns(:return_value)
    assert_equal :return_value, @adapter.find(:foo, 'condition')
  end

  def test_first
    @db.expects(:[]).with(:foo).returns(@relation)
    @relation.expects(:where).with('condition').returns(@relation)
    @relation.expects(:first).returns(:return_value)
    assert_equal :return_value, @adapter.first(:foo, 'condition')
  end

  def test_create
    @db.expects(:[]).with(:foo).returns(@relation)
    @relation.expects(:insert).with('data').returns(:return_value)
    assert_equal :return_value, @adapter.create(:foo, 'data')
  end

  def test_update
    @db.expects(:[]).with(:foo).returns(@relation)
    @relation.expects(:where).with('conditions').returns(@relation)
    @relation.expects(:update).with('data').returns(:return_value)
    assert_equal :return_value, @adapter.update(:foo, 'conditions', 'data')
  end

  def test_delete
    @db.expects(:[]).with(:foo).returns(@relation)
    @relation.expects(:where).with('conditions').returns(@relation)
    @relation.expects(:delete).returns(:return_value)
    assert_equal :return_value, @adapter.delete(:foo, 'conditions')
  end

  def test_migrate
    Sequel.extension(:migration)
    Sequel::Migrator.expects(:apply).with(@db, 'foo')
    @adapter.migrate('foo')
  end

  def test_schema
    @db.expects(:schema).with(:foo).returns(:return_value)
    assert_equal :return_value, @adapter.schema(:foo)
  end
end
