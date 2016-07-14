module CouplerAPI
  Dataset = Entity([
    :id,
    :name,
    :type,
    :host,
    :username,
    :password,
    :database_name,
    :table_name
    :csv
  ]) do
    def uri
      case type
      when 'mysql'
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

    private

    def container
      case type
      when 'mysql'
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
