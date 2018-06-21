Sequel.migration do
  up do
    alter_table(:csv_imports) do
      rename_column :detected_fields, :fields
    end
  end
end
