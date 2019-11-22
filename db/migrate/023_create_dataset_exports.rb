Sequel.migration do
  up do
    create_table(:dataset_exports) do
      primary_key :id
      Integer :dataset_id
      Integer :job_id
      String :kind
      String :path
      TrueClass :pending
    end
  end
end
