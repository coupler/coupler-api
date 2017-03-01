module CouplerAPI
  Dataset = Entity([
    :id,
    :name,
    :type,
    :host,
    :username,
    :password,
    :database_name,
    :table_name,
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

    def can_connect?
      begin
        schema
        true
      rescue Exception
        false
      end
    end

    private

    def adapter
      case type
      when 'mysql'
        SequelAdapter.new(uri)
      end
    end

    def schema
      adapter.schema(table_name.to_sym)
    end
  end
end
