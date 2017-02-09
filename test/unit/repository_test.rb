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
    @adapter.expects(:find).with('foo', nil).returns([1, 2, 3])
    expected = (1..3).collect { |i| @entity_klass.new(i) }
    assert_equal expected, @repo.find
  end

  def test_find_with_conditions
    @adapter.expects(:find).with('foo', 'conditions').returns([1, 2, 3])
    expected = (1..3).collect { |i| @entity_klass.new(i) }
    assert_equal expected, @repo.find('conditions')
  end

  def test_find_with_unserialize
    @repo_klass.class_eval(<<-EOF)
      def unserialize(obj)
        obj + 1
      end
    EOF
    @adapter.expects(:find).with('foo', nil).returns([1, 2, 3])
    expected = (2..4).collect { |i| @entity_klass.new(i) }
    assert_equal expected, @repo.find
  end

  def test_first
    @adapter.expects(:first).with('foo', 'conditions').returns(1)
    expected = @entity_klass.new(1)
    assert_equal expected, @repo.first('conditions')
  end

  def test_first_with_unserialize
    @repo_klass.class_eval(<<-EOF)
      def unserialize(obj)
        obj + 1
      end
    EOF
    @adapter.expects(:first).with('foo', 'conditions').returns(1)
    expected = @entity_klass.new(2)
    assert_equal expected, @repo.first('conditions')
  end

  def test_first_nil
    @adapter.expects(:first).with('foo', 'conditions').returns(nil)
    assert_nil @repo.first('conditions')
  end

  def test_save_new
    obj = mock(:to_h => { foo: 'bar' })
    @adapter.expects(:create).with('foo', { foo: 'bar' }).returns(1)
    obj.expects(:id=).with(1)
    assert_same obj, @repo.save(obj)
  end

  def test_save_new_with_serialize
    @repo_klass.class_eval(<<-EOF)
      def serialize(hsh)
        hsh[:foo] += "baz"
        hsh
      end
    EOF
    obj = mock(:to_h => { foo: 'bar' })
    @adapter.expects(:create).with('foo', { foo: 'barbaz' }).returns(1)
    obj.expects(:id=).with(1)
    assert_same obj, @repo.save(obj)
  end

  def test_save_new_failure
    obj = mock(:to_h => { foo: 'bar' })
    @adapter.expects(:create).with('foo', { foo: 'bar' }).returns(nil)
    obj.expects(:id=).never
    assert_raises(Exception) do
      @repo.save(obj)
    end
  end

  def test_save_not_new
    obj = mock(:to_h => { id: 123, foo: 'bar' })
    @adapter.expects(:update).with('foo', { id: 123 }, { id: 123, foo: 'bar' }).returns(1)
    obj.expects(:id=).never
    assert_same obj, @repo.save(obj)
  end

  def test_save_not_new_with_serialize
    @repo_klass.class_eval(<<-EOF)
      def serialize(hsh)
        hsh[:foo] += "baz"
        hsh
      end
    EOF
    obj = mock(:to_h => { id: 123, foo: 'bar' })
    @adapter.expects(:update).with('foo', { id: 123 }, { id: 123, foo: 'barbaz' }).returns(1)
    obj.expects(:id=).never
    assert_same obj, @repo.save(obj)
  end

  def test_save_not_new_failure
    obj = mock(:to_h => { id: 123, foo: 'bar' })
    @adapter.expects(:update).with('foo', { id: 123 }, { id: 123, foo: 'bar' }).returns(0)
    obj.expects(:id=).never
    assert_raises(Exception) do
      @repo.save(obj)
    end
  end

  def test_delete
    obj = mock(:to_h => { id: 123 })
    @adapter.expects(:delete).with('foo', { id: 123 }).returns(1)
    assert_same obj, @repo.delete(obj)
  end

  def test_delete_failure
    obj = mock(:to_h => { id: 123 })
    @adapter.expects(:delete).with('foo', { id: 123 }).returns(0)
    assert_raises(Exception) do
      @repo.delete(obj)
    end
  end
end
