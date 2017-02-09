Sequel.migration do
  up do
    create_table(:comparators) do
      primary_key :id
      String :set_1, text: true
      String :set_2, text: true
      String :options, text: true
      Integer :order
      Integer :linkage_id
    end
  end
end
