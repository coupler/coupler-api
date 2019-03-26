module Coupler::API
  module CsvImports
    autoload :Create, "coupler/api/actions/csv_imports/create"
    autoload :Update, "coupler/api/actions/csv_imports/update"
    autoload :Show, "coupler/api/actions/csv_imports/show"
    autoload :Index, "coupler/api/actions/csv_imports/index"
    autoload :Download, "coupler/api/actions/csv_imports/download"
  end
end
