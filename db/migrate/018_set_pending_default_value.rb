Sequel.migration do
  up do
    alter_table(:datasets) do
      set_column_default :pending, false
    end
  end
end
