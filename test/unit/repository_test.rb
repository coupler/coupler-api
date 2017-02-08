require 'test_helper'

class CouplerAPI::UnitTests::RepositoryTest < Minitest::Test
  def setup
    @adapter = stub('adapter')
    klass = Class.new(CouplerAPI::Repository) do
      def initialize(*args)
        super
        @name = 'foo'
      end
    end
    @repo = klass.new(@adapter)
  end

  def test_dependencies
    assert_equal ['adapter'], CouplerAPI::Repository.dependencies
  end

  def test_find
    @adapter.expects(:find).with('foo').returns(:return_value)
    assert_equal :return_value, @repo.find
  end

  def test_first
    @adapter.expects(:first).with('foo', 'conditions').returns(:return_value)
    assert_equal :return_value, @repo.first('conditions')
  end

  def test_create
    @adapter.expects(:create).with('foo', 'data').returns(:return_value)
    assert_equal :return_value, @repo.create('data')
  end

  def test_update
    @adapter.expects(:update).with('foo', 'conditions', 'data').returns(:return_value)
    assert_equal :return_value, @repo.update('conditions', 'data')
  end

  def test_delete
    @adapter.expects(:delete).with('foo', 'conditions').returns(:return_value)
    assert_equal :return_value, @repo.delete('conditions')
  end
end
