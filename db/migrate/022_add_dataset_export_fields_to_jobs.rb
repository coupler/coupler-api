Sequel.migration do
  up do
    alter_table(:jobs) do
      add_column :dataset_export_kind, String
      add_column :dataset_export_id, Integer
    end
  end
end
