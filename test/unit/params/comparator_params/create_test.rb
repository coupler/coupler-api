require 'test_helper'

module Coupler
  module API
    module UnitTests
      module ComparatorParamsTest
        class CreateTest < Minitest::Test
          def setup
            @data = {
              :kind => 'compare',
              :set_1 => ['foo'],
              :set_2 => ['bar'],
              :order => 0,
              :options => { 'operation' => 'equal' },
              :linkage_id => 1
            }
            @params = ComparatorParams::Create.new
          end

          def test_process_excludes_extraneous_data
            data = {
              'kind' => 'compare',
              'set_1' => ['foo'],
              'set_2' => ['bar'],
              'order' => 0,
              'options' => { 'operation' => 'equal' },
              'linkage_id' => 1,
              'foo' => 'foo'
            }
            result = @params.process(data)
            assert_equal [:kind, :set_1, :set_2, :options, :order, :linkage_id].sort, result.keys.sort
          end
        end
      end
    end
  end
end
