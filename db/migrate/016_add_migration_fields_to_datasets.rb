Sequel.migration do
  up do
    alter_table(:datasets) do
      add_column :migration_id, Integer
      add_column :pending, TrueClass
    end
  end
end
