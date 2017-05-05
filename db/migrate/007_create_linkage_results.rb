Sequel.migration do
  up do
    create_table(:linkage_results) do
      primary_key :id
      String :database_path
      Integer :linkage_id
      Integer :job_id
    end

    alter_table(:jobs) do
      add_column :linkage_result_id, Integer
    end
  end
end
