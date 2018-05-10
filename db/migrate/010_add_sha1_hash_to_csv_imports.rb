Sequel.migration do
  up do
    alter_table(:csv_imports) do
      add_column :sha1_sum, String
    end
  end
end
