namespace :ecb do
  desc "Fetch rates from European Central Bank and append any missing records to database"
  task import_rates: :environment do
    import_result = ImportRatesFromEcb.call

    if import_result.success?
      puts import_result.resolve_message
    else
      "There were some errors while trying to import new rates:\n" \
      "#{import_result.error_message}"
    end
  end
end
