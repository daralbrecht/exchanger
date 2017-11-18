# Converts amount in USD to EUR using latest exchange rate in database or from
# specified date.
class ConvertUsdToEur
  class << self
    def call(amount, date = Date.today)
      rate = ExchangeRate.current_value(date)
      raise 'No exchange rates available!' unless rate
      (amount.to_d * 1 / rate).round(2)
    end
  end
end
