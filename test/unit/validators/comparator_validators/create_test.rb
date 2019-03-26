require 'test_helper'

module Coupler
  module API
    module UnitTests
      module ComparatorValidatorsTest
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
            @validator = ComparatorValidators::Create.new
          end

          def test_validate_requires_kind_exists
            @data.delete(:kind)
            errors = @validator.validate(@data)
            assert_equal ['kind must be present'], errors
          end

          def test_validate_requires_kind_is_valid
            @data[:kind] = 'foo'
            errors = @validator.validate(@data)
            assert_equal ['kind is not valid'], errors
          end

          def test_validate_requires_set_1
            @data.delete(:set_1)
            errors = @validator.validate(@data)
            assert_equal ['set_1 must be present'], errors
          end

          def test_validate_requires_set_1_array
            @data[:set_1] = 'foo'
            errors = @validator.validate(@data)
            assert_equal ['set_1 is not valid'], errors
          end

          def test_validate_requires_set_1_string_array
            @data[:set_1] = [1]
            errors = @validator.validate(@data)
            assert_equal ['set_1 is not valid'], errors
          end

          def test_validate_requires_set_2
            @data.delete(:set_2)
            errors = @validator.validate(@data)
            assert_equal ['set_2 must be present'], errors
          end

          def test_validate_requires_set_2_array
            @data[:set_2] = 'foo'
            errors = @validator.validate(@data)
            assert_equal ['set_2 is not valid'], errors
          end

          def test_validate_requires_set_2_string_array
            @data[:set_2] = [1]
            errors = @validator.validate(@data)
            assert_equal ['set_2 is not valid'], errors
          end

          def test_validate_requires_options
            @data.delete(:options)
            errors = @validator.validate(@data)
            assert_equal ['options must be present'], errors
          end

          def test_validate_requires_options_hash
            @data[:options] = 'foo'
            errors = @validator.validate(@data)
            assert_equal ['options is not valid'], errors
          end

          def test_validate_requires_order_number
            @data[:order] = 'foo'
            errors = @validator.validate(@data)
            assert_equal ['order is not valid'], errors
          end

          def test_validate_requires_linkage_id
            @data.delete(:linkage_id)
            errors = @validator.validate(@data)
            assert_equal ['linkage_id must be present'], errors
          end

          def test_validate_requires_linkage_id_number
            @data[:linkage_id] = 'foo'
            errors = @validator.validate(@data)
            assert_equal ['linkage_id is not valid'], errors
          end

          def test_validate_compare_requires_equal_length_sets
            @data[:set_2] = ['foo', 'bar']
            errors = @validator.validate(@data)
            assert_equal ['sets must be equal in length'], errors
          end

          def test_validate_compare_requires_options_operation
            @data[:options] = {}
            errors = @validator.validate(@data)
            assert_equal ['options.operation must be present'], errors
          end

          def test_validate_compare_requires_options_operation_valid
            @data[:options] = { 'operation' => 'foo' }
            errors = @validator.validate(@data)
            assert_equal ['options.operation is not valid'], errors
          end

          def test_validate_strcompare_requires_set_1_length
            @data.update(:kind => 'strcompare', :options => { 'operation' => 'jarowinkler' })
            @data[:set_1] = ['foo', 'bar']
            errors = @validator.validate(@data)
            assert_equal ['set_1 is not valid'], errors
          end

          def test_validate_strcompare_requires_set_2_length
            @data.update(:kind => 'strcompare', :options => { 'operation' => 'jarowinkler' })
            @data[:set_2] = ['foo', 'bar']
            errors = @validator.validate(@data)
            assert_equal ['set_2 is not valid'], errors
          end

          def test_validate_strcompare_requires_options_operation
            @data.update(:kind => 'strcompare', :options => { 'operation' => 'jarowinkler' })
            @data[:options] = {}
            errors = @validator.validate(@data)
            assert_equal ['options.operation must be present'], errors
          end

          def test_validate_strcompare_requires_options_operation_valid
            @data.update(:kind => 'strcompare', :options => { 'operation' => 'jarowinkler' })
            @data[:options] = { 'operation' => 'foo' }
            errors = @validator.validate(@data)
            assert_equal ['options.operation is not valid'], errors
          end

          def test_validate_within_requires_set_1_length
            @data.update(:kind => 'within', :options => { 'value' => 'foo' })
            @data[:set_1] = ['foo', 'bar']
            errors = @validator.validate(@data)
            assert_equal ['set_1 is not valid'], errors
          end

          def test_validate_within_requires_set_2_length
            @data.update(:kind => 'within', :options => { 'value' => 'foo' })
            @data[:set_2] = ['foo', 'bar']
            errors = @validator.validate(@data)
            assert_equal ['set_2 is not valid'], errors
          end

          def test_validate_within_requires_options_value
            @data.update(:kind => 'within', :options => { 'value' => 'foo' })
            @data[:options] = {}
            errors = @validator.validate(@data)
            assert_equal ['options.value must be present'], errors
          end
        end
      end
    end
  end
end
