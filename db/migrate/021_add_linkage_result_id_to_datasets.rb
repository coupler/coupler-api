Sequel.migration do
  up do
    alter_table(:datasets) do
      add_column :linkage_result_id, Integer
    end
  end
end
