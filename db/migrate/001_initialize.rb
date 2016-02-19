Sequel.migration do
  up do
    create_table(:datasets) do
      primary_key :id
      String :name
      String :type
      String :host
      String :username
      String :password
      String :database_name
      String :table_name
      String :csv, text: true
    end
  end
end
