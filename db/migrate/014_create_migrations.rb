Sequel.migration do
  up do
    create_table(:migrations) do
      primary_key :id
      String :description, text: true
      String :operations, text: true
      Integer :input_dataset_id
      Integer :output_dataset_id
    end
  end
end
