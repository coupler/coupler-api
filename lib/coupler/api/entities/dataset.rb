module Coupler::API
  Dataset = Entity([
    :id,
    :name,
    :type,
    :host,
    :username,
    :password,
    :database_name,
    :database_path,
    :table_name,
    :csv_import_id,
    :migration_id,
    :linkage_result_id,
    :pending
  ]) do
    def uri
      case type
      when 'mysql'
        if RUBY_PLATFORM == "java"
          "jdbc:mysql://#{host}/#{database_name}?user=#{username}&password=#{password}"
        else
          "mysql2://#{host}/#{database_name}?username=#{username}&password=#{password}"
        end
      when 'sqlite3'
        if RUBY_PLATFORM == "java"
          "jdbc:sqlite:#{database_path}"
        else
          "sqlite://#{database_path}"
        end
      end
    end

    def fields
      schema.collect do |(name, info)|
        field = { 'name' => name.to_s, 'kind' => info[:type].to_s }
        if info[:primary_key]
          field['primary_key'] = info[:primary_key]
        end
        field
      end
    end

    def primary_key
      fields.find { |f| f['primary_key'] }
    end

    def to_h(include_fields = false)
      result = super()
      result['fields'] = fields if include_fields
      result
    end

    def can_connect?
      begin
        result = false
        adapter do |adapter|
          result = true
        end
        result
      rescue Exception
        false
      end
    end

    def table_exists?
      begin
        !schema.nil?
      rescue Exception => e
        false
      end
    end

    def has_primary_key?
      result = false
      ds = ::Linkage::Dataset.new(uri, table_name)
      !ds.field_set.primary_key.nil?
    end

    def fetch_records(conditions = nil, limit = nil, offset = nil)
      result = nil
      adapter do |adapter|
        result = adapter.find(table_name.to_sym, conditions, limit, offset)
      end
      result
    end

    def count_records(conditions = nil)
      result = nil
      adapter do |adapter|
        result = adapter.count(table_name.to_sym, conditions)
      end
      result
    end

    private

    def adapter
      adapter =
        case type
        when 'mysql', 'sqlite3'
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
