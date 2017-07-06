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
        field = { 'name' => name, 'kind' => info[:type].to_s }
        if info[:primary_key]
          field['primary_key'] = info[:primary_key]
        end
        field
      end
    end

    def to_h(include_fields = false)
      result = super()
      result['fields'] = fields if include_fields
      result
    end

    def can_connect?
      begin
        schema
        true
      rescue Exception
        false
      end
    end

    def fetch_records(conditions)
      result = nil
      adapter do |adapter|
        result = adapter.find(table_name.to_sym, conditions)
      end
      result
    end

    private

    def adapter
      adapter =
        case type
        when 'mysql'
          SequelAdapter.new(uri)
        end
      yield adapter
      adapter.close
    end

    def schema
      result = nil
      adapter do |adapter|
        result = adapter.schema(table_name.to_sym)
      end
      result
    end
  end
end
