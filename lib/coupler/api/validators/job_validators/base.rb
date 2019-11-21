module Coupler::API
  module JobValidators
    class Base
      # Hash for valid kinds and which additional fields are required for each.
      KINDS = {
        'linkage' => [
          :linkage_id
        ],
        'migration' => [
          :migration_id
        ],
        'linkage_result_export' => [
          :linkage_result_id
        ],
        'dataset_export' => [
          :dataset_id, :dataset_export_kind
        ]
      }

      def self.dependencies
        []
      end

      def validate(data)
        if !data.is_a?(Hash)
          raise ArgumentError, "expected argument to be a Hash"
        end

        errors = []

        if data[:kind].nil? || data[:kind].empty?
          errors.push("kind must be present")
          return errors
        end

        kind = data[:kind]
        if !KINDS.has_key?(kind)
          errors.push("kind is not valid")
          return errors
        end

        # check for presence of required keys and absence of other keys
        required_keys = KINDS[kind]
        required_keys.each do |key|
          if data[key].nil?
            errors.push("#{key.to_s} must be present when kind is '#{kind}'")
          end
        end
        (data.keys - required_keys).each do |key|
          next if key == :kind
          if !data[key].nil?
            errors.push("#{key.to_s} must not be present when kind is '#{kind}'")
          end
        end
        if !errors.empty?
          return errors
        end

        case kind
        when 'linkage'
          if !data[:linkage_id].is_a?(Integer)
            errors.push("linkage_id is not valid")
          end

        when 'migration'
          if !data[:migration_id].is_a?(Integer)
            errors.push("migration_id is not valid")
          end

        when 'linkage_result_export'
          if !data[:linkage_result_id].is_a?(Integer)
            errors.push("linkage_result_id is not valid")
          end

        when 'dataset_export'
          if !data[:dataset_id].is_a?(Integer)
            errors.push("dataset_id is not valid")
          end

          if !%w{sqlite3 csv}.include?(data[:dataset_export_kind])
            errors.push("dataset_export_kind is not valid")
          end
        end

        errors
      end
    end
  end
end
