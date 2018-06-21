module CouplerAPI
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
    def to_sanitized_hash
      result = super()
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
