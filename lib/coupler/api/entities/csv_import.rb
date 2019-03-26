module Coupler::API
  CsvImport = Entity([
    :id,
    :original_name,
    :file_size,
    :file_path,
    :sha1_sum,
    :fields,
    :created_at,
    :dataset_id
  ]) do
    def to_h
      result = super
      if result[:created_at].is_a?(Time)
        result[:created_at] = result[:created_at].iso8601
      end
      result
    end

    def to_sanitized_hash
      result = super
      if result[:created_at].is_a?(Time)
        result[:created_at] = result[:created_at].iso8601
      end
      result.delete(:file_path)
      result
    end

    def rows(row_count = 20)
      csv = CSV.open(file_path, headers: true)
      rows = []
      while !csv.eof? && rows.length < row_count
        rows << csv.shift.to_h
      end
      csv.close
      rows
    end

    def generate_table_name
      original_name.downcase.sub(/\..+?$/, "").gsub(/[^a-z0-9_]+/, "_")
    end
  end
end
