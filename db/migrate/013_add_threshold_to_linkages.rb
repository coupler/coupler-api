Sequel.migration do
  up do
    alter_table(:linkages) do
      add_column :threshold, Float
    end
  end
end
