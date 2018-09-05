module CouplerAPI
  module CsvImportValidators
    autoload :Create, "coupler-api/validators/csv_import_validators/create"
    autoload :Update, "coupler-api/validators/csv_import_validators/update"
    autoload :Show, "coupler-api/validators/csv_import_validators/show"
    autoload :Download, "coupler-api/validators/csv_import_validators/download"
  end
end
