Sequel.migration do
  up do
    create_table(:csv_imports) do
      primary_key :id
      String :original_name
      String :file_size
      String :file_path
      String :detected_fields
      DateTime :created_at
      Integer :dataset_id
    end
  end
end
