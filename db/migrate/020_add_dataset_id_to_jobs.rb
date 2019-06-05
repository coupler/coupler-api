Sequel.migration do
  up do
    alter_table(:jobs) do
      add_column :dataset_id, Integer
    end
  end
end
