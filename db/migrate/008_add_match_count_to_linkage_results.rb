Sequel.migration do
  up do
    alter_table(:linkage_results) do
      add_column :match_count, Integer
    end
  end
end
