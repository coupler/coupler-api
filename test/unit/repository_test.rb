require 'test_helper'

class CouplerAPI::UnitTests::RepositoryTest < Minitest::Test
  def setup
    @entity_klass = Class.new do
      attr_reader :attribs
      def initialize(attribs)
        @attribs = attribs
      end

      def ==(other)
        @attribs == other.instance_variable_get(:@attribs)
      end
    end

    @repo_klass = Class.new(CouplerAPI::Repository)
    @repo_klass.class_eval(<<-EOF)
      def initialize(*args)
        super
        @name = 'foo'
        @constructor = @@constructor
      end
    EOF
    @repo_klass.class_variable_set(:@@constructor, @entity_klass)

    @adapter = stub('adapter')
    @repo = @repo_klass.new(@adapter)
  end

  def test_dependencies
    assert_equal ['adapter'], CouplerAPI::Repository.dependencies
  end

  def test_find
    @adapter.expects(:find).with('foo').returns([1, 2, 3])
    expected = (1..3).collect { |i| @entity_klass.new(i) }
    assert_equal expected, @repo.find
  end

  def test_first
    @adapter.expects(:first).with('foo', 'conditions').returns(1)
    expected = @entity_klass.new(1)
    assert_equal expected, @repo.first('conditions')
  end

  def test_first_nil
    @adapter.expects(:first).with('foo', 'conditions').returns(nil)
    assert_equal nil, @repo.first('conditions')
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
    @adapter.expects(:delete).with('foo', 'conditions').returns([1, 2, 3])
    expected = (1..3).collect { |i| @entity_klass.new(i) }
    assert_equal expected, @repo.delete('conditions')
  end
end
