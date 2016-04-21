Sequel.migration do
  up do
    alter_table(:comparators) do
      add_column :kind, String
    end
  end
end
