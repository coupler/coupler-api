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

      def fields
        dataset.columns.collect do |name|
          { 'name' => name }
        end
      end

      def to_h
        @attributes.dup
      end

      private

      def container
        case @attributes[:type]
        when 'mysql'
          host, database_name, username, password, table_name = @attributes.values_at(:host, :database_name, :username, :password, :table_name)
          ROM.container(:sql, "mysql2://#{host}/#{database_name}?username=#{username}&password=#{password}") do |rom|
            rom.use :macros
            rom.relation(table_name.to_sym)
          end
        end
      end

      def dataset
        gateway = container.gateways[:default]
        gateway.dataset(table_name.to_sym)
      end
    end
  end
end
