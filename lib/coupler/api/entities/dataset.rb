module Coupler
  module API
    class Dataset
      def initialize(attributes)
        @attributes = attributes
      end

      def id
        @attributes[:id]
      end

      def table_name
        @attributes[:table_name]
      end

      def field_names
        dataset.columns
      end

      def to_h
        @attributes.dup
      end

      private

      def container
        case @attributes[:type]
        when 'mysql'
          host, database_name, username, password, table_name = @attributes.values_at(:host, :database_name, :username, :password, :table_name)
          Rom.container(:sql, "mysql2://#{host}/#{database}?username=#{username}&password=#{password}") do |rom|
            use :macros
            rom.relation(table_name.to_sym)
          end
        end
      end

      def dataset
        gateway = container.gateway[:default]
        gateway.dataset(table_name.to_sym)
      end
    end
  end
end
