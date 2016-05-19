module CouplerAPI
  module LinkageParams
    class Update < Base
      def self.process(data)
        result = super
        if data.has_key?('id')
          result[:id] = data['id']
        end
        result
      end

      def self.validate(data)
        errors = super

        if data[:id].nil?
          errors.push("id must be present")
        elsif !data[:id].is_a?(Fixnum)
          errors.push("id must be a number")
        end

        errors
      end
    end
  end
end
