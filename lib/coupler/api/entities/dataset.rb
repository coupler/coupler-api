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

      def uri
        case @attributes[:type]
        when 'mysql'
          host, database_name, username, password = @attributes.values_at(:host, :database_name, :username, :password)
          if RUBY_PLATFORM == "java"
            "jdbc:mysql://#{host}/#{database_name}?user=#{username}&password=#{password}"
          else
            "mysql2://#{host}/#{database_name}?username=#{username}&password=#{password}"
          end
        end
      end

      def fields
        schema.collect do |(name, info)|
          { 'name' => name, 'type' => info[:type].to_s }
        end
      end

      def to_h
        @attributes.dup
      end

      private

      def container
        case @attributes[:type]
        when 'mysql'
          table_name = @attributes[:table_name]
          ROM.container(:sql, uri) do |rom|
            rom.use :macros
            rom.relation(table_name.to_sym)
          end
        end
      end

      def gateway
        container.gateways[:default]
      end

      def dataset
        gateway.dataset(table_name.to_sym)
      end

      def schema
        gateway.connection.schema(table_name.to_sym)
      end
    end
  end
end
