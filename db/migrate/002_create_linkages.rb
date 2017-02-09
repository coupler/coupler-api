Sequel.migration do
  up do
    create_table(:linkages) do
      primary_key :id
      String :name
      String :description
      Integer :dataset_1_id
      Integer :dataset_2_id
    end
  end
end
