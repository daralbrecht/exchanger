module Ecb
  # Class for storing example responses from European Central Bank API
  class ExampleResponses
    def self.successful_response_body
      "Data Source in SDW: null\r\n,EXR.D.USD.EUR.SP00.A\r\n,\"ECB reference exchange rate, US dollar/Euro, 2:15 pm (C.E.T.)\"\r\nCollection:,Average of observations through period (A)\r\nPeriod\\Unit:,[US dollar ]\r\n2017-11-17,1.1795\r\n2017-11-16,1.1771\r\n2017-11-15,1.1840\r\n2017-11-14,1.1745\r\n2017-11-13,1.1656\r\n2017-11-10,1.1654\r\n2017-11-09,1.1630\r\n2017-11-08,1.1590\r\n2017-11-07,1.1562\r\n2017-11-06,1.1590\r\n2017-11-03,1.1657\r\n2017-11-02,1.1645\r\n2017-11-01,1.1612\r\n2017-10-31,1.1638\r\n2017-10-30,1.1612\r\n2017-10-27,1.1605\r\n2017-10-26,1.1753\r\n2017-10-25,1.1785\r\n2017-10-24,1.1761\r\n2017-10-23,1.1740"
    end

    def self.failed_response_body
      'There is no series in the cube to be exported'
    end
  end
end
