Sequel.migration do
  up do
    create_table(:jobs) do
      primary_key :id
      String :kind
      String :status
      Integer :linkage_id
      DateTime :started_at
      DateTime :ended_at
    end
  end
end
