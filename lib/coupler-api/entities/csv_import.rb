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
  end
end
