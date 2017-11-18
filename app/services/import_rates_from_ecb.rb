# Connects to European Central Bank service and downloads exchange rates in CSV
# file. Then in updates exchange rates in database by adding new ones.
class ImportRatesFromEcb
  # Class method for triggerring call action directly on a class, without
  # instantiating it.
  #
  # @param args [any list of arguments]
  def self.call(*args)
    new(*args).call
  end

  # Instance initializer
  def initialize
    @success = true
  end

  # Download rates from ECB and store any new ones in database. Returns Struct
  # with info about operation status.
  #
  # @return [ImportResult]
  def call
    rates_data = download_rates_from_ecb

    if error_message.nil? && rates_present?(rates_data)
      append_missing_rates(rates_data)
    end
    result
  end

  private

  attr_reader :resolve_message, :error_message, :success

  # Struct definition for returned value
  ImportResult = Struct.new(:success?, :resolve_message, :error_message)

  # Returns Struct with status and possible error message
  #
  # return [ImportResult]
  def result
    ImportResult.new(success, resolve_message, error_message)
  end

  # Use Ecb::API wrapper to download exchange rates and set status to failure
  # if any error occured.
  #
  # @return [Array<Array>]
  def download_rates_from_ecb
    rates_result = Ecb::API.download_rates
    if rates_result.success?
      rates_result.rates
    else
      @success = false
      @error_message = rates_result.error_message
      []
    end
  end

  # Checks if rates data contains any values
  #
  # @return [Boolean]
  def rates_present?(rates_data)
    return true unless rates_data.empty?
    @resolve_message = 'No rates given for import!'
    false
  end

  # Inserts any new rates into database and sets resolve message with info about
  # how many new rates were added.
  #
  # @param rates [Array<Array>]
  def append_missing_rates(rates)
    columns = %i[period value]
    result = ExchangeRate.import(columns, rates, on_duplicate_key_ignore: true)
    import_size = result.ids.size

    @resolve_message = if import_size.zero?
                         'No new rates for import'
                       else
                         "#{import_size} new #{'rate'.pluralize(import_size)}" \
                         ' imported successfully'
                       end
  end
end
