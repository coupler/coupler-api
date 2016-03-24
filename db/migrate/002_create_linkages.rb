Sequel.migration do
  up do
    create_table(:linkages) do
      primary_key :id
      String :name
      String :description
      Fixnum :dataset_1_id
      Fixnum :dataset_2_id
    end
  end
end
