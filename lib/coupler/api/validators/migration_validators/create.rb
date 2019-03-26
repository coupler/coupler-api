module Coupler::API
  module MigrationValidators
    class Create
      ADD_FIELD_KEYS = %w{name field_name type}
      ADD_FIELD_TYPES = %w{integer string float}
      CAST_KEYS = %w{name field_name new_type}
      CAST_TYPES = %w{integer string float}
      MERGE_KEYS = %w{name left_field_names right_field_names}
      REMOVE_FIELD_KEYS = %w{name field_name}
      RENAME_KEYS = %w{name field_name new_field_name}
      SELECT_KEYS = %w{name field_names}

      def self.dependencies
        []
      end

      def validate(data)
        if !data.is_a?(Hash)
          raise ArgumentError, "expected argument to be a Hash"
        end

        errors = []

        if data.has_key?(:description)
          if !data[:description].is_a?(String)
            errors.push("description must be a string")
          elsif data[:description].empty?
            errors.push("description must not be empty")
          end
        end

        if data[:operations].nil?
          errors.push("operations must be present")
        elsif !data[:operations].is_a?(Array)
          errors.push("operations must be an array")
        elsif data[:operations].empty?
          errors.push("operations must not be empty")
        else
          data[:operations].each_with_index do |op, i|
            if !op.is_a?(Hash)
              errors.push("operations[#{i}] must be a hash")
            elsif op.empty?
              errors.push("operations[#{i}] must not be empty")
            elsif !op.has_key?('name')
              errors.push("operations[#{i}]['name'] must be present")
            elsif !op['name'].is_a?(String)
              errors.push("operations[#{i}]['name'] must be a string")
            else
              op_errors =
                case op['name']
                when 'add_field'
                  validate_operation_add_field(op)
                when 'cast'
                  validate_operation_cast(op)
                when 'merge'
                  validate_operation_merge(op)
                when 'remove_field'
                  validate_operation_remove_field(op)
                when 'rename'
                  validate_operation_rename(op)
                when 'select'
                  validate_operation_select(op)
                else
                  { 'name' => 'is not valid' }
                end

              op_errors.each_pair do |k, v|
                if !v.is_a?(Array)
                  v = [v]
                end
                v.each do |msg|
                  errors.push("operations[#{i}]['#{k}'] #{msg}")
                end
              end
            end
          end
        end

        if data[:input_dataset_id].nil?
          errors.push("input_dataset_id must be present")
        elsif !data[:input_dataset_id].is_a?(Integer)
          errors.push("input_dataset_id is not valid")
        end

        if data[:output_dataset].nil?
          errors.push("output_dataset must be present")
        elsif !data[:output_dataset].is_a?(Hash)
          errors.push("output_dataset must be a hash")
        else
          output_dataset = data[:output_dataset]

          # TODO: DRY up dataset validation
          if output_dataset[:name].nil?
            errors.push("output_dataset.name must be present")
          elsif !output_dataset[:name].is_a?(String)
            errors.push("output_dataset.name must be a string")
          elsif output_dataset[:name].empty?
            errors.push("output_dataset.name must not be empty")
          end

          if output_dataset[:type].nil?
            errors.push("output_dataset.type must be present")
          elsif !%w{mysql}.include?(output_dataset[:type])
            errors.push("output_dataset.type is not valid (#{output_dataset[:type]})")
          else
            case data[:type]
            when "mysql"
              if output_dataset[:host].nil?
                errors.push("output_dataset.host must be present")
              elsif !output_dataset[:host].is_a?(String)
                errors.push("output_dataset.host must be a string")
              elsif output_dataset[:host].empty?
                errors.push("output_dataset.host must not be empty")
              end

              if output_dataset[:database_name].nil?
                errors.push("output_dataset.database_name must be present")
              elsif !output_dataset[:database_name].is_a?(String)
                errors.push("output_dataset.database_name must be a string")
              elsif output_dataset[:database_name].empty?
                errors.push("output_dataset.database_name must not be empty")
              end

              if output_dataset[:username].nil?
                errors.push("output_dataset.username must be present")
              elsif !output_dataset[:username].is_a?(String)
                errors.push("output_dataset.username must be a string")
              elsif output_dataset[:username].empty?
                errors.push("output_dataset.username must not be empty")
              end

              if output_dataset[:table_name].nil?
                errors.push("output_dataset.table_name must be present")
              elsif !output_dataset[:table_name].is_a?(String)
                errors.push("output_dataset.table_name must be a string")
              elsif output_dataset[:table_name].empty?
                errors.push("output_dataset.table_name must not be empty")
              end
            end
          end
        end

        errors
      end

      def validate_operation_add_field(op)
        errors = {}

        (ADD_FIELD_KEYS - op.keys).each do |key|
          errors[key] = 'is not a valid parameter name'
        end

        if !op.has_key?('field_name')
          errors['field_name'] = 'must be present'
        elsif !op['field_name'].is_a?(String)
          errors['field_name'] = 'must be a string'
        elsif op['field_name'].empty?
          errors['field_name'] = 'must not be empty'
        end

        if !op.has_key?('type')
          errors['type'] = 'must be present'
        elsif !op['type'].is_a?(String)
          errors['type'] = 'must be a string'
        elsif !ADD_FIELD_TYPES.include?(op['type'])
          errors['type'] = 'is not valid'
        end

        errors
      end

      def validate_operation_cast(op)
        errors = {}

        (CAST_KEYS - op.keys).each do |key|
          errors[key] = 'is not a valid parameter name'
        end

        if !op.has_key?('field_name')
          errors['field_name'] = 'must be present'
        elsif !op['field_name'].is_a?(String)
          errors['field_name'] = 'must be a string'
        elsif op['field_name'].empty?
          errors['field_name'] = 'must not be empty'
        end

        if !op.has_key?('new_type')
          errors['new_type'] = 'must be present'
        elsif !op['new_type'].is_a?(String)
          errors['new_type'] = 'must be a string'
        elsif !CAST_TYPES.include?(op['new_type'])
          errors['new_type'] = 'is not valid'
        end

        errors
      end

      def validate_operation_merge(op)
        errors = {}

        (MERGE_KEYS - op.keys).each do |key|
          errors[key] = 'is not a valid parameter name'
        end

        if !op.has_key?('left_field_names')
          errors['left_field_names'] = 'must be present'
        end

        %w{left_field_names right_field_names}.each do |key|
          next if !op.has_key?(key)

          if !op[key].is_a?(Array)
            errors[key] = 'must be an array'
          elsif op[key].empty?
            errors[key] = 'must not be empty array'
          else
            op[key].each_with_index do |field, i|
              msg = nil
              if !field.is_a?(String)
                msg = "was not a string"
              elsif field.empty?
                msg = "was empty"
              end

              if !msg.nil?
                errors[key] ||= []
                errors[key] << "element at index #{i} #{msg}"
              end
            end
          end
        end

        if op.has_key?('right_field_names') && !errors.has_key?('left_field_names') &&
            !errors.has_key?('right_field_names')

          if op['left_field_names'].length != op['right_field_names'].length
            errors['right_field_names'] = "must have the same number of elements as 'left_field_names'"
          end
        end

        errors
      end

      def validate_operation_remove_field(op)
        errors = {}

        (REMOVE_FIELD_KEYS - op.keys).each do |key|
          errors[key] = 'is not a valid parameter name'
        end

        if !op.has_key?('field_name')
          errors['field_name'] = 'must be present'
        elsif !op['field_name'].is_a?(String)
          errors['field_name'] = 'must be a string'
        elsif op['field_name'].empty?
          errors['field_name'] = 'must not be empty'
        end

        errors
      end

      def validate_operation_rename(op)
        errors = {}

        (RENAME_KEYS - op.keys).each do |key|
          errors[key] = 'is not a valid parameter name'
        end

        if !op.has_key?('field_name')
          errors['field_name'] = 'must be present'
        elsif !op['field_name'].is_a?(String)
          errors['field_name'] = 'must be a string'
        elsif op['field_name'].empty?
          errors['field_name'] = 'must not be empty'
        end

        if !op.has_key?('new_field_name')
          errors['new_field_name'] = 'must be present'
        elsif !op['new_field_name'].is_a?(String)
          errors['new_field_name'] = 'must be a string'
        elsif op['new_field_name'].empty?
          errors['new_field_name'] = 'must not be empty'
        end

        errors
      end

      def validate_operation_select(op)
        errors = {}

        (SELECT_KEYS - op.keys).each do |key|
          errors[key] = 'is not a valid parameter name'
        end

        if !op.has_key?('field_names')
          errors['field_names'] = 'must be present'
        elsif !op['field_names'].is_a?(Array)
          errors['field_names'] = 'must be an array'
        elsif op['field_names'].empty?
          errors['field_names'] = 'must not be empty'
        else
          op['field_names'].each do |name|
            msg = nil
            if !name.is_a?(String)
              msg = 'was not a string'
            elsif name.empty?
              msg = 'was empty'
            end

            if !msg.nil?
              errors['field_names'] ||= []
              errors['field_names'] << "element at index #{i} #{msg}"
            end
          end
        end

        errors
      end
    end
  end
end
