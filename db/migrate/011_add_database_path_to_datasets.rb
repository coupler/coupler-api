Sequel.migration do
  up do
    alter_table(:datasets) do
      add_column :database_path, String
      add_column :csv_import_id, Integer
      drop_column :csv
    end
  end
end
