module Ecb
  # ECB API wrapper for fetching rates data
  class API
    include HTTParty

    base_uri 'http://sdw.ecb.europa.eu'

    class << self
      # Connect with ECB and download rates data
      #
      # @return [RatesData]
      def download_rates
        response = get('/quickviewexport.do',
                       query: { SERIES_KEY: '120.EXR.D.USD.EUR.SP00.A',
                                type: 'csv' })
        rates_data(response)
      rescue SocketError => e
        rates_error_data(e)
      end

      private

      # Struct definition for rates data returned from API
      RatesData = Struct.new(:success?, :rates, :error_message)

      # Check response status and return Struct with result
      #
      # @param response [HTTParty::Response]
      #
      # @return [RatesData]
      def rates_data(response)
        if response.code == 200 && response.parsed_response.is_a?(Array)
          RatesData.new(true, valid_rates(response))
        else
          RatesData.new(false, [], response.parsed_response)
        end
      end

      # Check response status and return Struct with result
      #
      # @param response [Exception]
      #
      # @return [RatesData]
      def rates_error_data(exception)
        RatesData.new(false, [], exception.message)
      end

      # Iterate through downloaded file lines and return only valid rate data
      #
      # @param response [HTTParty::Response]
      #
      # @return [Array<Array>]
      def valid_rates(response)
        response.parsed_response.map { |row| row if rate_data?(row) }.compact
      end

      # Check if given array contains rate data
      #
      # @param row [Array<String>]
      #
      # @return [Boolean]
      def rate_data?(row)
        row.compact.size == 2 && row[0].a_date? && row[1].a_number?
      end
    end
  end
end
