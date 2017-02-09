require 'test_helper'

class CouplerAPI::UnitTests::ComparatorRepositoryTest < Minitest::Test
  def setup
    @adapter = stub('adapter')
    @repo = CouplerAPI::ComparatorRepository.new(@adapter)
  end

  def test_unserialize
    @adapter.expects(:first).with(:comparators, 'conditions').returns({
      set_1: '[1,2,3]', set_2: '[4,5,6]', options: '{"foo":"bar"}'
    })
    comparator = @repo.first('conditions')
    assert_equal [1, 2, 3], comparator.set_1
    assert_equal [4, 5, 6], comparator.set_2
    assert_equal({ "foo" => "bar" }, comparator.options)
  end

  def test_serialize
    comparator = CouplerAPI::Comparator.new({
      set_1: [1, 2, 3], set_2: [4, 5, 6], options: { "foo" => "bar" }
    })
    @adapter.expects(:create).with(:comparators, {
      set_1: '[1,2,3]', set_2: '[4,5,6]', options: '{"foo":"bar"}'
    }).returns(1)
    @repo.save(comparator)
  end
end
