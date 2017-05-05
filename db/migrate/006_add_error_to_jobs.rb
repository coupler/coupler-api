Sequel.migration do
  up do
    alter_table(:jobs) do
      add_column :error, String
    end
  end
end
