module CouplerAPI
  CsvImport = Entity([
    :id,
    :original_name,
    :file_size,
    :file_path,
    :detected_fields,
    :created_at,
    :dataset_id
  ]) do
  end
end
